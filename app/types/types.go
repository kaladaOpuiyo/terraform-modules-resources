package types

//Config is a struct
type Config struct {
	Directories struct {
		Resources string `toml:"resources_dir,omitempty"`
		Modules   string `toml:"modules_dir,omitempty"`
		Build     string `toml:"build_dir,omitempty"`
	} `toml:"directories"`
}

// Action is a struct
type Action struct {
	Command  string `json:"Command"`
	Resource string `json:"Resource"`
	Outputs  struct {
		Output []string `json:"Output"`
		Errors []string `json:"Errors"`
	} `json:"Outputs"`
}

// Totals is a struct
type Totals struct {
	TotalModules   int `json:"TotalModules"`
	TotalResources int `json:"TotalResources"`
	TotalProjects  int `json:"TotalProjects"`
}

// Projects is a struct :)
type Projects struct {
	Projects []Project `json:"Projects"`
}

// Project is a struct
type Project struct {
	Name         string `json:"Name"`
	Modules      `json:"Modules"`
	Azs          `json:"Azs"`
	Environments `json:"Environments"`
}

// Modules is a struct
type Modules struct {
	ModulesTotals int          `json:"ModulesTotals"`
	ModuleInfo    []ModuleInfo `json:"ModuleInfo"`
}

// ModuleInfo is a struct
type ModuleInfo struct {
	ModuleName  string `json:"ModuleName"`
	Project     string `json:"Project"`
	Environment string `json:"Environment"`
	ModuleAz    string `json:"ModuleAz"`
}

// ModuleInfofn is a struct
type ModuleInfofn func(ua []string) []ModuleInfo

// Azs is a struct
type Azs struct {
	AzsTotals int      `json:"AzsTotals"`
	AzsUsed   []string `json:"AzsUsed"`
}

// Environments is a struct
type Environments struct {
	EnvTotals int      `json:"envTotals"`
	EnvUsed   []string `json:"envUsed"`
}

// // Results is a struct
// type Results struct {
// 	Projects []struct {
// 		Name      string `json:"Name"`
// 		Resources int    `json:"NumberOfResources"`
// 		Modules   int    `json:"Modules"`
// 		Azs       int    `json:"Azs"`
// 	} `json:"Projects"`
// 	Action struct {
// 		Command string `json:"Command"`
// 		Outputs struct {
// 			Output []string `json:"Output"`
// 			Errors []string `json:"Errors"`
// 		}
// 	}
// 	Totals struct {
// 		TotalModules   int `json:"TotalModules"`
// 		TotalResources int `json:"TotalResources"`
// 		TotalProjects  int `json:"TotalProjects"`
// 	} `json:"Totals"`
// }
