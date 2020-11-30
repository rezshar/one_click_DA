#!/bin/bash
#written by reza sharifi

function FUNC1() {

spin()
{
  spinner="⠁⠂⠄⡀⢀⠠⠐⠈"
  while :
  do
    for i in `seq 0 7`
    do
      echo -n "${spinner:$i:1}"
      echo -n "${spinner:$i:1}"

      echo -en "\010"
      sleep .08
    done
  done
}


# Start the Spinner:
spin &
# Make a note of its Process ID (PID):
SPIN_PID=$!
# Kill the spinner on any signal, including our own exit.
trap "kill -9 $SPIN_PID" `seq 0 15` 
$COMMAND > /root/script.log 2>&1


# If the script is going to exit here, there is nothing to do.
# The trap above will kill the spinner when this script exits.
# Otherwise, if the script is going to do more stuff, you can
# kill the spinner now:

kill -9 $SPIN_PID  
}

#This function is for changing directadmin.conf values and compare them with old value

function FUNC2()
{
  OldValue=$( cat /usr/local/directadmin/conf/directadmin.conf | grep "$MyChange" |  tr "=" "\n" | awk 'NR==2' )
	if [ "$OldValue" != "$NewValue" ]
		then
			./directadmin set $MyChange $NewValue  >> /root/change.log
	fi
}

touch /root/change.log
> /root/change.log
echo "This values has been changed :" > /root/change.log

cd /usr/local/directadmin

MyChange="max_username_length"
NewValue="20"
FUNC2;

MyChange="letsencrypt"
NewValue="1"
FUNC2;

MyChange="http2"
NewValue="1"
FUNC2;

MyChange="dkim"
NewValue="1"
FUNC2;

MyChange="dns_ttl"
NewValue="1"
FUNC2;

Core=$( grep -c ^processor /proc/cpuinfo )
Variable=$((Core+=Core))

MyChange="check_load"
NewValue="$Variable"
FUNC2;

MyChange="check_load_minute"
NewValue="5"
FUNC2;

MyChange="zip"
NewValue="1"
FUNC2;

MyChange="da_gzip"
NewValue="1"
FUNC2;

MyChange="one_click_webmail_login"
NewValue="1"
FUNC2;

MyChange="one_click_pma_login"
NewValue="1"
FUNC2;

MyChange="realtime_quota"
NewValue="2"
FUNC2;

MyChange="rotate_httpd_error_log_meg"
NewValue="400"
FUNC2;

MyChange="default_private_html_link"
NewValue="1"
FUNC2;

MyChange="user_helper"
NewValue="ok2.com/1zZlD"
FUNC2;

MyChange="reseller_helper"
NewValue="ok2.com/dUL1N"
FUNC2;

MyChange="admin_helper"
NewValue="ok2.com/KHORv"
FUNC2;

MyChange="user_can_select_skin"
NewValue="1"
FUNC2;



tput setaf 4;cat << "EOF"
  _____ _______       _____ _______ 
 / ____|__   __|/\   |  __ \__   __|
| (___    | |  /  \  | |__) | | |   
 \___ \   | | / /\ \ |  _  /  | |   
 ____) |  | |/ ____ \| | \ \  | |   
|_____/   |_/_/    \_\_|  \_\ |_|   
                                    

EOF
echo "=============================="
cat /root/change.log
echo "=============================="


COMMAD=" service directadmin restart "
tput setaf 2; echo "Service directadmin restarting";
FUNC1;echo;
if grep -q "failed" /root/script.log
then
        tput setaf 1; echo "Directadmin Error ";
        cat /root/script.log
        tput setaf 9;
        exit 1
fi


cd custombuild

if grep -q "one_click_pma_login=1" /root/change.log
then

	COMMAND="./build update"
	tput setaf 2; echo "Updating Directadmin";
	FUNC1;echo;
	if grep -q "ERROR" /root/script.log
	then
        	tput setaf 1; echo "Directadmin ./build update Error";
        	cat /root/script.log
        	tput setaf 9;
        	exit 1
	fi

	COMMAND="./build phpmyadmin"
	tput setaf 2; echo "Building phpmyadmin";
	FUNC1;echo;
	if grep -q "ERROR" /root/script.log
	then
        	tput setaf 1; echo "./build phpmyadmin Error";
        	cat /root/script.log
                tput setaf 9;
        	exit 1
	fi
fi	





if grep -q "one_click_webmail_login=1" /root/change.log
then

        COMMAND="./build update"
        tput setaf 2; echo "Updating Directadmin";
        FUNC1;echo;
        if grep -q "ERROR" /root/script.log
        then
                tput setaf 1; echo "Directadmin ./build update Error";
                cat /root/script.log
                tput setaf 9;
                exit 1
        fi
	

	COMMAND="./build roundcube"
        tput setaf 2; echo "Building roundcube";
        FUNC1;echo;
	service directadmin restart > /dev/null 2>&1;
        if grep -q "ERROR" /root/script.log
        then
                tput setaf 1; echo "./build roundcube Error";
                cat /root/script.log
                tput setaf 9;
                exit 1
        fi


	COMMAND="./build update"
        tput setaf 2; echo "Updating Directadmin";
        FUNC1;echo;
        if grep -q "ERROR" /root/script.log
        then
                tput setaf 1; echo "Directadmin ./build update Error";
                cat /root/script.log
                tput setaf 9;
                exit 1
        fi



	COMMAND="./build dovecot_conf"
	tput setaf 2; echo "Building dovecot_conf";
	FUNC1;echo;
	if grep -q "ERROR" /root/script.log
	then
        	tput setaf 1; echo "./build dovecot_conf  Error";
        	cat /root/script.log
        	tput setaf 9;
        	exit 1
	fi

	COMMAND="./build exim_conf"
	tput setaf 2; echo "Building exim_conf";
	FUNC1;echo;
	if grep -q "ERROR" /root/script.log
	then
        	tput setaf 1; echo "./build exim_conf Error";
        	cat /root/script.log
                tput setaf 9;
        	exit 1
	fi


	COMMAND="./build roundcube"
	tput setaf 2; echo "Building roundcube";
	FUNC1;echo;
	if grep -q "ERROR" /root/script.log
	then
        	tput setaf 1; echo "./build roundcube Error";
        	cat /root/script.log
                tput setaf 9;
        	exit 1
	fi


fi


#rm -f /root/logDA.log /root/change.log

tput setaf 4; cat << "EOF"
 ______ _____ _   _ _____  _____ _    _ 
|  ____|_   _| \ | |_   _|/ ____| |  | |
| |__    | | |  \| | | | | (___ | |__| |
|  __|   | | | . ` | | |  \___ \|  __  |
| |     _| |_| |\  |_| |_ ____) | |  | |
|_|    |_____|_| \_|_____|_____/|_|  |_|
                                        
EOF
tput setaf 9;


