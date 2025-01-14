#!/usr/bin/env bash

# This script is run by the opal container on startup.
# There are some values which are set as ENV VARS in the container which are set in opal-deployment.yaml
# The rest come from the values.yaml file.

# https://opaldoc.obiba.org/en/latest/python-user-guide/index.html

touch /doing_local_customisation.txt

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

# Add the NORMAL DEMO_USER as defined in the values.yaml
opal user --user administrator --password $OPAL_ADMINISTRATOR_PASSWORD --add --name $OPAL_DEMO_USER_NAME --upassword $OPAL_DEMO_USER_PASSWORD

###########################################################################
# CNSIM DEMO DATA
###########################################################################

# Add a project
opal project --user administrator --password $OPAL_ADMINISTRATOR_PASSWORD --add --name $OPAL_DEMO_PROJECT --database mongodb

# Add the CNSIM1 data to the project
cd /tmp
mkdir opal-config-temp
cd opal-config-temp
wget $OPAL_DEMO_SOURCE_DATA_URL

opal_fs_path="/home/administrator"
opal_file_path="$opal_fs_path/`basename $OPAL_DEMO_SOURCE_DATA_URL`"

opal file --user administrator --password $OPAL_ADMINISTRATOR_PASSWORD -up `basename $OPAL_DEMO_SOURCE_DATA_URL` $opal_fs_path

opal import-csv --user administrator --password $OPAL_ADMINISTRATOR_PASSWORD --destination $OPAL_DEMO_PROJECT --path $opal_file_path  --tables $OPAL_DEMO_TABLE --separator , --type Participant --valueType decimal


###########################################################################
# SYNTHEA DEMO DATA
###########################################################################

# Add a project
opal project --user administrator --password $OPAL_ADMINISTRATOR_PASSWORD --add --name $OPAL_COHORT_PROJECT --database mongodb

# Add the COHORT data to the project
cd /tmp
mkdir opal-config-temp
cd opal-config-temp
wget $OPAL_COHORT_SOURCE_DATA_URL

opal_fs_path="/home/administrator"
opal_file_path="$opal_fs_path/`basename $OPAL_COHORT_SOURCE_DATA_URL`"

opal file --user administrator --password $OPAL_ADMINISTRATOR_PASSWORD -up `basename $OPAL_COHORT_SOURCE_DATA_URL` $opal_fs_path

opal import-csv --user administrator --password $OPAL_ADMINISTRATOR_PASSWORD --destination $OPAL_COHORT_PROJECT --path $opal_file_path  --tables $OPAL_COHORT_TABLE --separator , --type Participant --valueType text

cd ..
rm -rf opal-config-temp

touch /finished_local_customisation.txt