###############################################################################
# DataSHIELD demo of docker installation
# This R script is intended as a validation/demonstration of the DataSHIELD 
# installation from the docker compose file at:
#
# A real world example of using this would be for the server side DataSHIELD
# components (the stuff installed with docker compose) to be in a VM and for
# this R script to be run from outside of that VM (probably through a reverse
# proxy). This can also be run from within the VM that the server side 
# components are installed on, just calling localhost instead of a proper URL.
###############################################################################

# This will need to be installed locally. DSI and DSOpal can be installed from
# the CRAN, but dsBaseClient needs:
# install.packages('dsBaseClient', repos=c(getOption('repos'), 'https://cran.obiba.org'), dependencies = TRUE)
library(DSI)
library(DSOpal)
library(dsBaseClient)

# Can be useful for debugging SSL issues
#library(curl)
#curl::curl_version()

################################################################################
# Set all the options.

# This should be a proper URL with https. If you are running this from within
# VM then it is probably https://localhost:8443
#url <- "https://datashield2.liv.ac.uk"
url <- "https://172.24.128.135"

# As defined in the docker-compose file
user <- "administrator"
password <- "password"

user <- "demo_user"
password <- "Demo_password1!"


# When developing with self signed certificates, you may need to set these as
# strict verification is the default. Do not use in production.
options = "list(ssl_verifyhost = 0L, ssl_verifypeer = 0L)"
################################################################################


################################################################################
# Now log into the server for the DEMO.CNSIM1 table
builder <- DSI::newDSLoginBuilder()
builder$append(server = "server1",
               url = url,
               user = user,
               password = password,
               options = options,
               table = "DEMO.CNSIM1")
logindata <- builder$build()
connections <- DSI::datashield.login(logins = logindata, assign = TRUE, symbol = "D")

# Check what packages are available. I would expect to see dsBase and resourcer
datashield.pkg_status(connections)

# Check what data is available.
datashield.tables(connections)


###############################################################################



# Now start doing stuff with the data in the table linked to 'D'
ds.colnames(x = 'D', datasources = connections)
ds.dim(x = 'D', datasources = connections)
ds.summary(x = 'D$LAB_HDL', datasources = connections)
ds.mean(x = 'D$LAB_HDL', datasources = connections)
datashield.errors()


########################### 
# Synthea
builder <- DSI::newDSLoginBuilder()
builder$append(server = "server1",
               url = "https://datashield2.liv.ac.uk",
               user = "administrator",
               password = "password",
               table = "COHORT.conditions1",
               options = "list(ssl_verifyhost = 0, ssl_verifypeer = 0)")

logindata <- builder$build()
connections <- datashield.login(logins = logindata, assign = TRUE, symbol = "D")

# Now start doing stuff with the data in the table linked to 'D'
ds.colnames(x = 'D', datasources = connections)
ds.dim(x = 'D', datasources = connections)

ds.dataFrameSubset(df.name = "D",
                   V1.name = "D$CODE",
                   V2.name = "72892002",
                   Boolean.operator = "==",
                   rm.cols = NULL,
                   keep.NAs = FALSE,
                   newobj = "subset.all.rows",
                   datasources = connections, #all servers are used
                   notify.of.progress = FALSE)                

ds.colnames("subset.all.rows")
ds.dim("subset.all.rows")
ds.length("subset.all.rows")
