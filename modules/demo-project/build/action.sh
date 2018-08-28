#!/bin/bash
ENV=$1
#az1,az2 into az1 az2 
AZs=($(echo $2 | sed 's/,/ /g' ))
ACTION=$4
BUILD=$3
VPC_TAG_NAME=



#TODO 
    # Apply only if prior plan destroy == 0 
    # You should seriously consider rewriting this in golang :) 
    # Check if vpc exist and if network exist prior to resource creation

action(){



   if [ "$BUILD" = "network" ];
   then
    for az in "${AZs[@]}"
        do

        VPC_DIR=./$ENV/vpc
        ENV_DIR=./$ENV/$az
        ENV_MODULES=$(find $ENV_DIR -name main.tf | sed -e 's/\(main.tf\)*$//g')
    
            for module in $ENV_MODULES
                do
                    NETWORK_MODULE=$(echo $module | grep network)
                
                    if ! [  -z $NETWORK_MODULE ];
                        then
                            case $ACTION in 
                                "plan")
                                    terraformPlan $VPC_DIR && \
                                    terraformPlan $module;;
                                "init")
                                    terraformInit $VPC_DIR && \
                                    terraformInit $module;;
                                "build")
                                    terraformInit $VPC_DIR && terraformPlan $VPC_DIR && terraformApply $VPC_DIR && \
                                    terraformInit $module && terraformPlan $module && terraformApply $module;;
                                *)
                                    echo "ACTION=plan,init,build.C'mon dont be stupid network";;
                            esac  
                    fi
            done
        done
    fi

    if ! [ "$BUILD" = "network" ];
    then
   
    for az in "${AZs[@]}"
        do

        ENV_DIR=./$ENV/$az
        ENV_MODULES=$(find $ENV_DIR -name main.tf | sed -e 's/\(main.tf\)*$//g')
        VPC_EXIST=true
        SUBNET_EXIST=true

        if [[ $VPC_EXIST = true && $SUBNET_EXIST = true ]]; then

            for module in $ENV_MODULES
                do
                    NETWORK_MODULE=$(echo $module | grep network)

                    if [  -z $NETWORK_MODULE ];
                        then 
                            case $ACTION in 
                                "plan")
                                    terraformPlan $module;;
                                "init")
                                    terraformInit $module;;
                                "build")
                                    terraformInit $module && terraformPlan $module && terraformApply $module ;;
                                *)
                                    echo "ACTION=plan,init,build.C'mon dont be stupid";;
                            esac  
                    fi
            done
        else
            echo "Please build network resources"
        fi
        done
    fi
}

terraformApply(){
 echo "terraform apply for $1"
  terraform apply -auto-approve -state="$1/terraform.tfstate" $1
}

terraformPlan(){
  echo "terraform plan for $1"
  terraform plan -state="$1/terraform.tfstate" $1
}

terraformInit(){
  echo "initialize terraform modules for $1"
  terraform init $1
                
}


########################################################################################################################
  # Main
#########################################################################################################################


 if ! [ -x "$(command -v terraform)" ]; then
  echo 'terraform not found' >&2
  exit 1
fi
   
#    for az in ${AZs[@]}
#     do 
#        echo $az
#     done


action
