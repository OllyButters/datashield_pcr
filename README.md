# datashield_pcr

DataSHIELD for the prostate cancer research project

## DataSHIELD install

It's all done via the docker compose file, so just run `docker-compose up` and you should be good to go. You might want to edit a couple of things first though:

- the opal volume should map to somewhere on your local machine.
- there are vaious usernames and passwords in here which should be managed elsewhere.
- the csr-allowed setting is needed as it sometimes appears that cross site scripting is occuring when pages are passing through the reverse proxy. Specify expected `host:port` pairs here.

This will get you to the point where it is all running locally, you will be able to connect to the opal server web interface at

<http://localhost:8880>
<https://localhost:8843>

If you installed this on a remote host then you will likely need to add a reverse proxy to the front with a valid SSL certificate. For development a self signed certificate is fine. A good guide for this is here:

<https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-nginx-in-ubuntu>

When developing, it is useful to be able to delete everything and start over.

    sudo docker compose down
    sudo rm -r <PATH TO OPAL DATA>
    sudo docker compose up

Sometimes is useful to be able to log into the opal server and check the logs. This can be done with the following command:

    sudo docker exec -it <container ID> bash

To do:

- Could add a reverse proxy to the docker-compose file. How to manage the SSL certificate though?
