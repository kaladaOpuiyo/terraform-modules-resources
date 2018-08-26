# TERRAFORM RESOURCE MODULES #


Each environment contains a makefile which can be used to initialize,plan,apply or destroy all modules within an environment.The file system structure **project/environment/availability-zone/** is used to facilitate this. State is maintained locally for demo purposes. 


## Subnets Example

<pre><code>subnets = {
     
      nat = {
        cidr_block = "10.111.16.0/24"
        type       = "public"
      }

      web = {
        cidr_block = "10.111.32.0/24"
        type       = "public"
      }
          
      app = {
        cidr_block = "10.111.48.0/24"
        type       = "private"
      }
      
      data = {
        cidr_block = "10.111.64.0/24"
        type       = "private"
      }
  }</code></pre>


## Security Group Example

<pre><code> 

  ports = {
        
        ssh = {
          port_numbers = "22"
          cidr_range   = "0.0.0.0/0"
        }

        web80 = {
          port_numbers = "80"
          cidr_range   = "0.0.0.0/0"
        }

        webrange {
          port_numbers = "8000-9000"
          cidr_range   = "0.0.0.0/0"
        }
        
  }</code></pre>

## Network Setup

The network related directives provision a vpc and all related subnets. 

**Initialize network:** `make network-init`

**Plan network build:** `make network-plan`

**Build network:** `make network-build`

**Destroy network:** `make network-destroy`


## Modules 

These command execute against all modules within *project/environment/availability-zone/
/...* with the exception of the modules in the the network directory.


**Initialize modules:** `make init`

**Plan modules build:** `make plan`

**Build modules:** `make build`

**Destroy modules:** `make destroy`


