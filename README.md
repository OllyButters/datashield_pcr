# datashield_pcr

DataSHIELD for the prostate cancer research project

## DataSHIELD install

It's all done via the docker compose file, so just run `sudo docker compose up` from within the folder with the `docker-compose.yml` file in and you should be good to go. You might want to edit a couple of things first though:

- the opal volume should map to somewhere on your local machine. Something like `/opal:/srv` will map the `/opal` folder on the host to the `/srv` folder in the container. This is where the opal data will be stored.
- there are vaious usernames and passwords in here which should be managed elsewhere.
- the csr-allowed setting is needed as it sometimes appears that cross site scripting is occuring when pages are passing through the reverse proxy. Specify expected `host:port` pairs here.

This will get you to the point where it is all running locally, you will be able to connect to the opal server web interface (assuming you are on the VM where it was installed) at

<http://localhost:8880>
<https://localhost:8843>

## Reverse proxy

If you installed this on a remote host then you will likely need to add a reverse proxy to the front with a valid SSL certificate. For development a self signed certificate is fine. A good guide for this is here:

<https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-nginx-in-ubuntu>

You will need to map the ports in the reverse proxy, do 443 on the host to 8080.

## Firewall

If using Uncomplicated Firewall (UFW) on the host machine, you will need to allow the appropriate ports. For example:

    sudo ufw status
    sudo ufw app list
    sudo ufw allow 'Nginx HTTPS'

## Client testing

Once everything is up and running server side the next test to see if you can connect to the server from the client side. There is an example script in the `client` folder which can be run from the client side. This will connect to the server and run a simple test. You will need to install the `dsBaseClient` package. This can be done with the following command:

    install.packages("dsBaseClient", repos = "https://cran.obiba.org")

## Docker commands

When developing, it is useful to be able to delete everything and start over.

    sudo docker compose down
    sudo rm -r <PATH TO OPAL DATA>
    sudo docker compose up

Sometimes is useful to be able to log into the opal server and check the logs. This can be done with the following command:

    sudo docker exec -it <container ID> bash



To do:

- Could add a reverse proxy to the docker-compose file. How to manage the SSL certificate though?
