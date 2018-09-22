package config

import (
	"io/ioutil"
	"log"
	"os"

	"github.com/BurntSushi/toml"
	Types "github.com/terraform-ui/app/types"
)

// ReadConfig is used to read  the config file into a struct
func ReadConfig() (Types.Config, []os.FileInfo, []os.FileInfo) {

	var (
		config            Types.Config
		configFile        []byte
		err               error
		modulesDirectory  []os.FileInfo
		resourceDirectory []os.FileInfo
	)

	cfg := os.Getenv("TERRAFORM_UI_CONFIG")
	pwd, _ := os.Getwd()

	if configFile, err = ioutil.ReadFile(pwd + cfg); err != nil {
		log.Fatalln(err)
	}

	if _, err := toml.Decode(string(configFile), &config); err != nil {
		log.Fatalln(err)
	}

	if modulesDirectory, err = ioutil.ReadDir(config.Directories.Modules); err != nil {
		log.Fatal(err)
	}

	if resourceDirectory, err = ioutil.ReadDir(config.Directories.Resources); err != nil {
		log.Fatal(err)
	}

	return config, resourceDirectory, modulesDirectory

}
