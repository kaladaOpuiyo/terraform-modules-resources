#!/bin/bash
# PROJECT_HOME="./iac/modules/demo-project"


# This and the makefile will be deprecated in favor of a internal package call action.


PROJECT_HOME=$1
RESOURCES=$2
ACTION=$3
FIND_ENV=($(ls -d $PROJECT_HOME/*/))
FIND_AZs=($(find $PROJECT_HOME -name az* -ls | awk  '{ print $11 }' | sort ))



#TODO

action(){

    for full_env_path in "${FIND_ENV[@]}"
        
        do 

            env=$(basename $full_env_path)

            if [[ $ACTION = "init" ]];
                then 
                clearTerraformModules
            fi

            VPC_EXIST=$(aws ec2 describe-vpcs --filters Name="tag:Name,Values=$env*" | \
                grep "VpcId*"       > /dev/null 2>&1 && echo "true" || echo "false")
                
            NETWORK_EXIST=$(aws ec2 describe-subnets --filters Name="tag:Name,Values=$env*"  | \
                grep "SubnetId*"    > /dev/null 2>&1  && echo "true" || echo "false")

            MODULES_EXIST=$(aws ec2 describe-instances  --filters Name="tag:Name,Values=*$env*" \
                Name=instance-state-name,Values=running Name=instance-state-name,Values=stopped \
                Name=instance-state-name,Values=pending | \
                grep "InstanceId*"  > /dev/null 2>&1  && echo "true" || echo "false")

            case $RESOURCES in 

                ## VPC
                "vpc")
                
                    if  ! [[ $ACTION = "destroy" ]];
                        then
                            VPC_DIR=$PROJECT_HOME/$env/vpc
                            terraformActions $ACTION $VPC_DIR 

                    elif  [[ $NETWORK_EXIST = false ]] && [[ $ACTION = "destroy" ]] ;
                        then
                            VPC_DIR=$PROJECT_HOME/$env/vpc
                            terraformActions $ACTION $VPC_DIR
                    else
                        echo "Network resources exist, please destroy before destroying vpc"

                            
                    fi
                ;;

                ## NETWORK
                "network")

                    FIND_ENV_AZ=($( printf '%s\n' ${FIND_AZs[@]} | grep  $env ))
                
                    for az_found in "${FIND_ENV_AZ[@]}"

                        do

                            az=$(basename $az_found)
                            ENV_DIR=$PROJECT_HOME/$env/$az
                            ENV_MODULES=$(find $ENV_DIR -name main.tf | sed -e 's/\(main.tf\)*$//g')
                        
                                if [[ $VPC_EXIST = true ]] && ! [[ $ACTION = "destroy" ]];
                                    then   

                                        echo "$az_found"
                                        for module in $ENV_MODULES
                                            do
                                                NETWORK_MODULE=$(echo $module | grep network)
                                                
                                                if ! [  -z $NETWORK_MODULE ];
                                                    then
                                                        terraformActions $ACTION $module 
                                                    
                                                fi
                                        done

                                elif [[ $MODULES_EXIST = false ]] && [[ $ACTION = "destroy" ]] ;
                                    then 
                                        for module in $ENV_MODULES
                                            do
                                                NETWORK_MODULE=$(echo $module | grep network)
                                                
                                                if ! [  -z $NETWORK_MODULE ];
                                                    then
                                                        terraformActions $ACTION $module 
                                                    
                                                fi
                                        done
                                else
                                    echo "Modules exist, please destroy before removing the newtork"

                                fi
                    done

                ;;

                ## MODULES
                "modules")

                    FIND_ENV_AZ=($( printf '%s\n' ${FIND_AZs[@]} | grep  $env ))
                
                    for az_found in "${FIND_ENV_AZ[@]}"

                        do
                            az=$(basename $az_found)
                            ENV_DIR=$PROJECT_HOME/$env/$az
                            ENV_MODULES=$(find $ENV_DIR -name main.tf | sed -e 's/\(main.tf\)*$//g')

                            
                                if [[ $VPC_EXIST = true && $NETWORK_EXIST = true ]]; 
                                    then
                                        for module in $ENV_MODULES
                                            do
                                                NETWORK_MODULE=$(echo $module | grep network)

                                                if [  -z $NETWORK_MODULE ];
                                                    then 
                                                        terraformActions $ACTION $module  
                                                fi
                                        done
                                fi
                    done

                ;;

            esac
    done
    
}

terraformActions(){

   case $1 in 

    "plan")
        
        terraformPlan $2
    ;;

    "init")
        
        terraformInit $2
    ;;

    "build")

        terraformApply $2
    ;;

    "destroy")

        terraformDestroy $2
    ;;

    *)
        echo "ACTION=plan,init,RESOURCES,destroy.C'mon dont be stupid"
    ;;
      esac  
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

terraformDestroy(){

 echo "terraform destroy for $1"

  terraform destroy -auto-approve -state="$1/terraform.tfstate" $1
}


clearTerraformModules(){
  rm -Rf ./.terraform

}


########################################################################################################################
  # Main
#########################################################################################################################

 if ! [ -x "$(command -v terraform)" ]; then
  echo 'terraform not found' >&2
  exit 1
fi

 if ! [ -x "$(command -v aws)" ]; then
  echo 'terraform not found' >&2
  exit 1
fi

action
