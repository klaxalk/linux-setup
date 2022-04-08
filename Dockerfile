FROM ubuntu:20.04

RUN apt-get update && \
      apt-get -y install sudo

# fixes prompts during apt installations
RUN echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections
RUN sudo apt-get install -y -q
RUN DEBIAN_FRONTEND=noninteractive sudo apt-get -y install keyboard-configuration

RUN sudo apt-get -y update && sudo apt-get -y install software-properties-common git

RUN mkdir -p /opt/klaxalk/git && cd /opt/klaxalk/git && git clone https://github.com/klaxalk/linux-setup --depth 1

RUN cd /opt/klaxalk/git/linux-setup && ./install.sh --unattended --docker && rm -rf /var/lib/apt/lists/*

CMD ["bash"]
