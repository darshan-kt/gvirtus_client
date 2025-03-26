#!/bin/bash

# Ensure the container is running
docker ps | grep gvirtus_frontend > /dev/null || docker start gvirtus_frontend

# Execute all commands inside the container
docker exec -it gvirtus_frontend bash -c "
    # Set environment variables
    export GVIRTUS_HOME=/home/GVirtuS
    export EXTRA_NVCCFLAGS='--cudart=shared'
    export GVIRTUS_LOGLEVEL=10000
    export LD_LIBRARY_PATH=\${GVIRTUS_HOME}/lib:\${GVIRTUS_HOME}/lib/frontend:\${LD_LIBRARY_PATH}

    # Navigate to the examples folder
    cd \${GVIRTUS_HOME}/examples || { echo 'Failed to enter /home/GVirtuS/examples'; exit 1; }

    # Compile the CUDA program
    nvcc simple_matrix.cu -o simple_matrix -L \${GVIRTUS_HOME}/lib/frontend -L \${GVIRTUS_HOME}/lib/ -lcuda -lcudart -lcublas 

    # Run the compiled program
    ./simple_matrix
"
