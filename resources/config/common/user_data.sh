#!/bin/bash -v 

# USER_PUBKEY Format:if admin==true?username:admin:username:ssh_pub_key
USER_PUBKEY=(
"kalada:admin"
)
#PATTERNS
PUB_KEY_PATTERN="ssh-rsa AAAA[0-9A-Za-z+/+0-9A-Za-z]+[=]{0,3}( [^@]+@[^@]+)?"
USERNAME_PATTERN="/^(.+?):/"

#DEFAULT USERS CONFIG
DEFAULT_USER_DIR="/home/centos"
DEFAULT_USER="centos"
REMOVE_DEFAULT_USER="yes"

usersSetup() {

     for user_pub in "${USER_PUBKEY[@]}"
       
       do
        # Check grab username and pub key 
        USERNAME=$(echo $user_pub | awk 'match($0,'$USERNAME_PATTERN') {print substr($0,RSTART,RLENGTH)}' |  awk -F":" '{print $1}')
        PUB_KEY=$(echo $user_pub | grep -o ':.*' | sed 's/://' )

        # Check if Public Key is valid
        IS_PUBLIC_KEY_VALID=$([[ $PUB_KEY =~ $PUB_KEY_PATTERN ]] && echo "yes" || echo "no")
        
        # Create user 
        echo "creating user: $USERNAME" 
        sudo su
        useradd -m $USERNAME
        usermod -a -G wheel $USERNAME
        mkdir -p "/home/$USERNAME/.ssh"
        chmod -R 700 "/home/$USERNAME/.ssh"

        # Check if admin was requested 
        if [[ $PUB_KEY = "admin" ]];
            then
                echo "Admin user: $USERNAME" 
                usermod -a -G adm $USERNAME
                cp "$DEFAULT_USER_DIR/.ssh/authorized_keys" "/home/$USERNAME/.ssh/"
            
            else
            
                if [[ $IS_PUBLIC_KEY_VALID = "yes" ]];
                    then
                        touch "/home/$USERNAME/.ssh/authorized_keys"
                        echo $PUB_KEY >> "/home/$USERNAME/.ssh/authorized_keys"
                    else
                        echo "Public key is not valid" >> "/home/$USERNAME/.ssh/authorized_keys" 
                fi
        fi

        chmod 400 "/home/$USERNAME/.ssh/authorized_keys"
        chown -R $USERNAME:$USERNAME "/home/$USERNAME"
        echo "$USERNAME        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
        echo "User $USERNAME has been created"

        if [[ $REMOVE_DEFAULT_USER = "yes" ]];
            then
                echo userdel -r $DEFAULT_USER 
                rm -Rf $DEFAULT_USER_DIR 
        fi

    done

}
systemSetup(){
    echo "<==System setup request==>"
}

dockerRunTest(){
    echo "creating deafult user: $DEFAULT_USER" 
    useradd -m $DEFAULT_USER 
    usermod -a -G wheel $DEFAULT_USER 
    mkdir -p "/home/$DEFAULT_USER/.ssh" 
    chmod -R 700 "/home/$DEFAULT_USER/.ssh" 
    touch "/home/$DEFAULT_USER/.ssh/authorized_keys" 
    echo "TEST KEY" >> "/home/$DEFAULT_USER/.ssh/authorized_keys" 
    chmod 400 "/home/$USERNAME/.ssh/authorized_keys"
    chown -R $USERNAME:$USERNAME "/home/$USERNAME"
}

########################################################################################################################
  # Main
#########################################################################################################################

# dockerRunTest 
usersSetup
systemSetup

echo "DONE .."

