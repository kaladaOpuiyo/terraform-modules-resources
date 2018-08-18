#!/bin/bash
ENV=$1
CREATE_ARRAY=',' read -a AZs <<< "$2"
STATE=$4
BUILD=$3
VPC_TAG_NAME=dev-canary-vpc

#TODO
    # Conditional apply based on if resources are going to be destroyed based on plan results
    # Apply in all directory default is to apply only when plan show no resources will be destroyed
    # return list of resources which would plans show destruction 
    # Check if vpc exist and if network exist prior to resource creation



create(){

   

   if [ "$BUILD" = "network" ];
   then
     terraformApply ./$ENV/vpc 
    
    for az in $AZs
        do
        ENV_MODULES=$(find ./$ENV/$az -name main.tf | sed -e 's/\(main.tf\)*$//g')
        echo $ENV_MODULES
            for module in $ENV_MODULES
                do
                    NETWORK_MODULE=$(echo $module | grep network)
                
                    if ! [  -z $NETWORK_MODULE ];
                    then
                       terraformApply $module
                    fi
            done
        done
    fi

    if ! [ "$BUILD" = "network" ];
    then
   
    for az in $AZs
        do
        ENV_MODULES=$(find ./$ENV/$az -name main.tf | sed -e 's/\(main.tf\)*$//g')

            for module in $ENV_MODULES
                do
                    NETWORK_MODULE=$(echo $module | grep network)

                    if [  -z $NETWORK_MODULE ];
                    then 
        
                        terraformApply $module
        
                    fi
        
            done
        done
    fi
}

terraformApply(){
 echo "initialize terraform modules for $1"
  terraform init $1
                
 echo "terraform plan for $1"
  terraform plan -state="$1/terraform.tfstate" $1

 echo "terraform apply for $1"
  terraform apply -auto-approve -state="$1/terraform.tfstate" $1
}



########################################################################################################################
  # Main
#########################################################################################################################


 if ! [ -x "$(command -v terraform)" ]; then
  echo 'terraform not found' >&2
  exit 1
fi

create 


    # terraform init ./$ENV/${az}/$RESOURCE 
        # terraform plan  -destroy -state="./$ENV/${az}/$RESOURCE/terraform.tfstate" ./$ENV/${az}/$RESOURCE 
        # terraform destroy -auto-approve -state="./$ENV/${az}/$RESOURCE/terraform.tfstate" ./$ENV/${az}/$RESOURCE
