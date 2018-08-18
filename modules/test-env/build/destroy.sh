#!/bin/bash
ENV=$1
CREATE_ARRAY=',' read -a AZs <<< "$2"
STATE=$4
DESTROY=$3
VPC_TAG_NAME=dev-canary-vpc

destroy(){

   if ! [ "$DESTROY" = "network" ];
   then
    for az in $AZs
        do
        ENV_MODULES=$(find ./$ENV/$az -name main.tf | sed -e 's/\(main.tf\)*$//g')

            for module in $ENV_MODULES
                do
                    NETWORK_MODULE=$(echo $module | grep network)

                    if [  -z $NETWORK_MODULE ];
                    then 
        
                        terraformDestroy $module
        
                    fi
        
            done
        done
     
    

    fi

    if  [ "$DESTROY" = "network" ];
    then

    for az in $AZs
        do
        ENV_MODULES=$(find ./$ENV/$az -name main.tf | sed -e 's/\(main.tf\)*$//g')
        echo $ENV_MODULES
            for module in $ENV_MODULES
                do
                    NETWORK_MODULE=$(echo $module | grep network)
                
                    if ! [  -z $NETWORK_MODULE ];
                    then
                       terraformDestroy $module
                    fi
            done
        done
        
        terraformDestroy ./$ENV/vpc
    fi
}

terraformDestroy(){
 echo "initialize terraform modules for $1"
  terraform init $1
                
 echo "terraform plan destroy for $1"
  terraform plan -destroy -state="$1/terraform.tfstate" $1

 echo "terraform destroy for $1"
  terraform destroy -auto-approve -state="$1/terraform.tfstate" $1
}



########################################################################################################################
  # Main
#########################################################################################################################


 if ! [ -x "$(command -v terraform)" ]; then
  echo 'terraform not found' >&2
  exit 1
fi

destroy 
