#!/usr/bin/env bash

# This script is run by the opal container on startup.
# There are some values which are set as ENV VARS in the container which are set in opal-deployment.yaml
# The rest come from the values.yaml file.

# https://opaldoc.obiba.org/en/latest/python-user-guide/index.html

touch /doing_local_customisation.txt

# wget is not installed in the base docker image so add it here
apt update
apt install wget

# Check opal python client is installed
whereis opal

echo "Check opal has started before trying to add data etc"
until opal system --user administrator --password $OPAL_ADMINISTRATOR_PASSWORD --version
do
    echo "Customisation: Opal not up yet, sleeping..."
    sleep 30
done


# Most of these will just default to localhost

# Get the verion of opal
echo "Opal version:"
opal system --user administrator --password $OPAL_ADMINISTRATOR_PASSWORD --version

# Add the NORMAL DEMO_USER as defined in the docker_compose.yml file
opal user --user administrator --password $OPAL_ADMINISTRATOR_PASSWORD --add --name $OPAL_DEMO_USER_NAME --upassword $OPAL_DEMO_USER_PASSWORD

# Enable this user to be able to run DataSHIELD functions. Does not grant access to any data though.
opal perm-datashield --user administrator --password $OPAL_ADMINISTRATOR_PASSWORD --type USER --subject $OPAL_DEMO_USER_NAME --permission use --add

###########################################################################
# CNSIM DEMO DATA
###########################################################################

# Add a project
opal project --user administrator --password $OPAL_ADMINISTRATOR_PASSWORD --add --name $OPAL_DEMO_PROJECT --database mongodb
#opal project --user administrator --password $OPAL_ADMINISTRATOR_PASSWORD --add --name $OPAL_DEMO_PROJECT --database mysqldb

# Add the CNSIM1 data to the project
cd /tmp
mkdir opal-config-temp
cd opal-config-temp
pwd
wget $OPAL_DEMO_SOURCE_DATA_URL

opal_fs_path="/home/administrator"
opal_file_path="$opal_fs_path/`basename $OPAL_DEMO_SOURCE_DATA_URL`"

opal file --user administrator --password $OPAL_ADMINISTRATOR_PASSWORD -up `basename $OPAL_DEMO_SOURCE_DATA_URL` $opal_fs_path

opal import-csv --user administrator --password $OPAL_ADMINISTRATOR_PASSWORD --destination $OPAL_DEMO_PROJECT --path $opal_file_path  --tables $OPAL_DEMO_TABLE --separator , --type Participant --valueType decimal

cd ..
rm -rf opal-config-temp

# Add permission to demo user to use the demo table, but not be able to see the data in the web interface.
opal perm-table --user administrator --password password --type USER --project $OPAL_DEMO_PROJECT --subject $OPAL_DEMO_USER_NAME --permission view --add --tables $OPAL_DEMO_TABLE


###########################################################################
# SYNTHEA DEMO DATA
###########################################################################

# Add a project
#opal project --user administrator --password $OPAL_ADMINISTRATOR_PASSWORD --add --name $OPAL_COHORT_PROJECT --database mongodb
##opal project --user administrator --password $OPAL_ADMINISTRATOR_PASSWORD --add --name $OPAL_COHORT_PROJECT --database mysqldb

# Add the COHORT data to the project
#cd /tmp
#mkdir opal-config-temp
#cd opal-config-temp
#pwd
#wget $OPAL_COHORT_SOURCE_DATA_URL

#opal_fs_path="/home/administrator"
#opal_file_path="$opal_fs_path/`basename $OPAL_COHORT_SOURCE_DATA_URL`"

#opal file --user administrator --password $OPAL_ADMINISTRATOR_PASSWORD -up `basename $OPAL_COHORT_SOURCE_DATA_URL` $opal_fs_path

#opal import-csv --user administrator --password $OPAL_ADMINISTRATOR_PASSWORD --destination $OPAL_COHORT_PROJECT --path $opal_file_path  --tables $OPAL_COHORT_TABLE --separator , --type Participant --valueType text

#cd ..
#rm -rf opal-config-temp

# Add permission to demo user to use the demo table, but not be able to see the data in the web interface.
#opal perm-table --user administrator --password password --type USER --project $OPAL_COHORT_PROJECT --subject $OPAL_DEMO_USER_NAME --permission view --add --tables $OPAL_COHORT_TABLE

touch /finished_local_customisation.txt