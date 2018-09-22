package handler

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"strings"
	"sync"

	"github.com/acarl005/stripansi"
	Config "github.com/terraform-ui/app/config"
	Types "github.com/terraform-ui/app/types"
)

// ProjectsHandler retrives all projects in listed directory
func ProjectsHandler(w http.ResponseWriter, r *http.Request) {

	var (
		ps       Types.Projects
		projects []Types.Project
		project  Types.Project
	)

	config, _, projectsDirectory := Config.ReadConfig()

	var wg sync.WaitGroup

	for _, p := range projectsDirectory {

		wg.Add(1)

		go func(p os.FileInfo) {

			var (
				modulesTotals int
				azTotals      int
				azs           []string
				uniqueAzs     []string
				modules       []Types.ModuleInfo
				module        Types.ModuleInfo
			)

			defer wg.Done()

			//Define project main Path
			projectPath := filepath.Join(config.Directories.Modules,
				"/", p.Name())

			//Define enviroments in project
			envs, err := ioutil.ReadDir(projectPath)

			if err != nil {
				log.Fatalln(err)
			}

			envfn := func(e []os.FileInfo) Types.Environments {

				var environments []string

				for _, e := range envs {
					environments = append(environments, e.Name())
				}

				return Types.Environments{
					EnvTotals: len(environments),
					EnvUsed:   environments,
				}
			}

			m := func(path string, f os.FileInfo, err error) error {

				isDirVPC := func() bool {

					yes, err := regexp.MatchString("vpc", filepath.Base(path))

					if err != nil {
						log.Fatalln(err)
					}

					return yes
				}

				azfn := func() Types.Azs {

					yes, err := regexp.MatchString("az", filepath.Base(path))

					if err != nil {
						log.Fatalln(err)
					}

					if yes {

						azs = append(azs, filepath.Base(path))

						encountered := map[string]bool{}

						for a := range azs {
							encountered[azs[a]] = true
						}

						uniqueAzs = []string{}
						for key := range encountered {
							uniqueAzs = append(uniqueAzs, key)
						}

						azTotals = len(uniqueAzs)

					}

					return Types.Azs{
						AzsTotals: azTotals,
						AzsUsed:   uniqueAzs,
					}
				}

				modfn := func() Types.Modules {

					if f.IsDir() {
						if _, err := os.Stat(path + "/main.tf"); err == nil {

							modulesTotals++

							pathSlice := strings.Split(path, "/")

							sliceTotal := len(pathSlice)

							module = Types.ModuleInfo{

								//THIS IS BAD WORK FIGURE OUT A BETTER SOLUTION
								ModuleName:  pathSlice[sliceTotal-1],
								Project:     pathSlice[sliceTotal-4],
								Environment: pathSlice[sliceTotal-3],
								ModuleAz:    pathSlice[sliceTotal-2],
								// YES THIS BITCH RIGHT HERE. Really length - 1 hahah
							}

							if strings.Contains(pathSlice[sliceTotal-4], p.Name()) ||
								isDirVPC() {
								modules = append(modules, module)

							}

						}
					}

					return Types.Modules{
						ModuleInfo:    modules,
						ModulesTotals: modulesTotals,
					}
				}

				project = Types.Project{
					Name:         p.Name(),
					Environments: envfn(envs),
					Modules:      modfn(),
					Azs:          azfn(),
				}

				return nil
			}

			if err := filepath.Walk(projectPath, m); err != nil {
				log.Fatalln(err)
			}

			projects = append(projects, project)

		}(p)

		wg.Wait()

	}

	ps.Projects = projects

	w.Header().Set("Content-Type", "application/json; charset=UTF-8")
	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.WriteHeader(http.StatusOK)

	if err := json.NewEncoder(w).Encode(ps); err != nil {
		panic(err)
	}
}

//ActionsHandler executes request action
func ActionsHandler(w http.ResponseWriter, r *http.Request) {

	var (
		stdout bytes.Buffer
		stderr bytes.Buffer
		lines  []string
		output []string
		errors []string
		a      Types.Action
	)

	u := r.URL.Query()
	action := u.Get("action")

	config, _, projectsDirectory := Config.ReadConfig()

	for p := range projectsDirectory {

		cmd := "make"

		projectPath := filepath.Join(config.Directories.Modules,
			"/", projectsDirectory[p].Name())

		args := []string{"-i", "-C", config.Directories.Build, "project=" + projectPath, action}

		cmdOut := exec.Command(cmd, args...)
		cmdOut.Stdout, cmdOut.Stderr = &stdout, &stderr

		if err := cmdOut.Run(); err != nil {
			log.Fatalf("cmd.Run() failed with %s\n", err)
		}

		outStr, errStr := string(stdout.Bytes()), string(stderr.Bytes())
		lines = strings.Split(string(outStr), "\n")

		fmt.Print(outStr, errStr)

		errors = append(errors, stripansi.Strip(string(errStr)))

	}

	for line := range lines {

		cleanLine := stripansi.Strip(lines[line])

		if strings.Contains(cleanLine, "Plan:") ||
			strings.Contains(cleanLine, "Apply complete!") ||
			strings.Contains(cleanLine, "Destroy complete!") ||
			strings.Contains(cleanLine, "No changes") ||
			strings.Contains(cleanLine, "Network resources exist,") ||
			strings.Contains(cleanLine, "Modules exist,") ||
			strings.Contains(cleanLine, "initialize terraform") {
			output = append(output, cleanLine)
		}

	}

	a.Outputs.Output = output
	a.Outputs.Errors = errors

	w.Header().Set("Content-Type", "application/json; charset=UTF-8")
	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.WriteHeader(http.StatusOK)

	if err := json.NewEncoder(w).Encode(a); err != nil {
		log.Fatalln(err)
	}

}

// TotalsHandler pulls data regarding resources generation totals
func TotalsHandler(w http.ResponseWriter, r *http.Request) {

	var (
		t Types.Totals
	)

	config, resourceDirectory, projectsDirectory := Config.ReadConfig()

	for project := range projectsDirectory {

		projectPath := filepath.Join(config.Directories.Modules,
			"/", projectsDirectory[project].Name())

		m := func(path string, f os.FileInfo, err error) error {

			if f.IsDir() {
				if _, err := os.Stat(path + "/main.tf"); err == nil {
					t.TotalModules++
				}
			}

			return nil
		}

		if err := filepath.Walk(projectPath, m); err != nil {
			log.Fatalln(err)
		}

	}

	for resources := range resourceDirectory {

		resourcesPath := filepath.Join(config.Directories.Resources,
			"/", resourceDirectory[resources].Name())

		r := func(path string, f os.FileInfo, err error) error {

			if f.IsDir() {
				if _, err := os.Stat(path + "/main.tf"); err == nil {
					t.TotalResources++
				}
			}

			return nil
		}

		if err := filepath.Walk(resourcesPath, r); err != nil {
			log.Fatalln(err)
		}

	}

	t.TotalProjects = len(projectsDirectory)

	w.Header().Set("Content-Type", "application/json; charset=UTF-8")
	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.WriteHeader(http.StatusOK)

	if err := json.NewEncoder(w).Encode(t); err != nil {
		log.Fatalln(err)
	}

}
