GVirtuS - GPU Virtualization Software

GVirtuS is an open-source GPU virtualization software available on GitHub. It enables applications using CUDA Toolkit Version 10.2 and above to leverage GPU acceleration efficiently. GVirtuS provides partial or full virtualization for key CUDA scientific libraries, including:

cuDNN, cuFFT, cuBLAS, cuSPARSE, cuSOLVER

GVirtuS follows a split-driver model, ensuring seamless distribution of computational tasks from a non-GPU machine to a GPU-enabled machine. The software consists of three main components:

Frontend - Manages CUDA API calls from the application.

Backend - Handles execution of GPU workloads.

Communicator - Facilitates communication between frontend and backend components.

This repository demonstrates how to run a simple matrix multiplication application on a lightweight client device with minimal or no GPU hardware.

🚀 Running the GVirtuS Frontend Component

Step 1: Create GVirtuS Docker Image

Run the following command to build a GVirtuS Docker image. Ensure that both the Dockerfile and simple_matrix.cu files are in the same directory.

$ docker build -t gvirtus_env .

📌 Note: This step installs Ubuntu, GVirtuS software, its dependencies, and copies simple_matrix.cu into the GVirtus/examples folder. The process may take some time to complete.

Step 2: Create a Docker Container

Use the created Docker image to launch a GVirtuS container:

$ docker run --privileged --name gvirtus_frontend -t gvirtus_env bash

Step 3: Execute the GVirtuS Frontend with Matrix Multiplication

Run the frontend component using the following command:

./run_frontend.sh

🔄 Changing IP Address for Server-Client Communication

To modify the server IP and port for frontend-backend communication:

Step 1: Access the Container

docker exec -it gvirtus_frontend bash

Step 2: Navigate to the Configuration Directory

cd ${GVIRTUS_HOME}/etc

Step 3: Edit the Configuration File

Open properties.json using an editor like nano, vi, or vim:

nano properties.json

Modify the IP and Port settings to match the backend server:

{
    "server_address": "130.225.243.38",
    "port": "8888"
}

Save and exit the editor.

Step 4: Restart the Frontend

In another terminal, execute:

./run_frontend.sh

✍️ Editing simple_matrix.cu (Optional)

If you need to modify the simple_matrix.cu code and observe the changes:

Step 1: Access the Container

docker exec -it gvirtus_frontend bash

Step 2: Navigate to the Examples Directory

cd ${GVIRTUS_HOME}/examples

Step 3: Edit the Program

Open simple_matrix.cu using an editor:

nano simple_matrix.cu

Make your modifications and save the file.

Step 4: Restart the Frontend

Open a new terminal and run:

./run_frontend.sh

📌 Notes

Ensure that the frontend and backend components are properly configured for communication.

Always restart the frontend after modifying configuration files or CUDA programs.

🏆 Acknowledgments

This Docker image was built using the main GVirtuS repository: GVirtuS.
This work is part of the CLEVER project.


