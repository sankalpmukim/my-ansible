# Use the Pop!_OS base image
FROM nycticoracs/pop_os AS user_pop_os

# Set environment variables to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update package lists and install sudo
RUN apt-get update && \
    apt-get install -y sudo && \
    rm -rf /var/lib/apt/lists/*

# Create a new user 'sankalpmukim' with a home directory and bash shell
RUN useradd -m -s /bin/bash sankalpmukim

ARG PWD
# Set the password for 'sankalpmukim' to 'hello world'
# Note: Using echo with chpasswd to set the password
RUN echo "sankalpmukim:${PWD}" | chpasswd

# Add 'sankalpmukim' to the sudo group to grant sudo privileges
RUN usermod -aG sudo sankalpmukim

# (Optional) Allow 'sankalpmukim' to execute sudo commands without a password
# This step modifies the sudoers file; use with caution
RUN echo "sankalpmukim ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/sankalpmukim && \
    chmod 0440 /etc/sudoers.d/sankalpmukim

# Set the default user to 'sankalpmukim'
# This is optional and depends on your use case
USER root

# Set the working directory
WORKDIR /home/sankalpmukim

FROM user_pop_os AS ansible_installed

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common curl git build-essential && \
    apt-add-repository -y ppa:ansible/ansible && \
    apt-get update && \
    apt-get install -y curl git ansible build-essential && \
    apt-get clean autoclean && \
    apt-get autoremove --yes

FROM ansible_installed

COPY . .

CMD ["tail", "-f", "/dev/null"]
