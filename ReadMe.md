# Note: Make sure you've installed docker engine on your current system.

## Please follow below steps to run Gvirtus frontend component on your system/laptop.
1. Create Gvirtus docker image using docker file by running the below command. (Make sure both dockerfile and simple_matrix.cu files lies in the same folder)
$ docker build -t gvirtus_env .
Note: This file creates a docker image by installing ubuntu, gvirtus software, its dependencies and finally copies the simple_matrix.cu program into Gvirtus/examples folder. This is takes a while to complete.

2. Create docker container by using docker image which created from previous step.
$ docker run --privileged --name gvirtus_frontend -t gvirtus_env bash

3. Execute the gvirtus_frontend container with matrix multiplication program.
./run_frontend.sh


## For changing IP address for server-client communication:

# Execute the container
docker exec -it gvirtus_frontend bash

# Get inside the etc folder
cd ${GVIRTUS_HOME}/etc

# Edit the program using nano or vi or vim(Save after edit)
nano properties.json

Here, change IP and Port with respect to backend server IP. 
    {
    "server_address": "130.225.243.38",
    "port": "8888"
    }

# Open the other terminal and run frontend bash file
./run_frontend.sh



## Optional:
If incase if you want to edit the simple_matrix.cu code and see the changes(for example matrix output).

# Execute the container
docker exec -it gvirtus_frontend bash

# Get inside the examples folder
cd ${GVIRTUS_HOME}/examples

# Edit the program using nano or vi or vim(Save after edit)
nano simple_matrix.cu

# Open the other terminal and run frontend bash file
./run_frontend.sh
