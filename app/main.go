package main

import (
	"fmt"
	"log"
	"net/http"
	"os"

	Handler "github.com/terraform-ui/app/Handler"
)

func init() {
	os.Setenv("TERRAFORM_UI_CONFIG", os.Args[2])
}

func main() {

	fmt.Println("Running Terraform Wrapper API")

	// router := mux.NewRouter()
	http.HandleFunc("/actions", Handler.ActionsHandler)
	http.HandleFunc("/totals", Handler.TotalsHandler)
	http.HandleFunc("/projects", Handler.ProjectsHandler)

	log.Fatal(http.ListenAndServe("localhost:8070", nil))
}
