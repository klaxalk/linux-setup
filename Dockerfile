FROM ubuntu:20.04

RUN apt-get update && \
      apt-get -y install sudo

RUN echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections
RUN sudo apt-get install -y -q
RUN DEBIAN_FRONTEND=noninteractive sudo apt-get -y install keyboard-configuration

RUN sudo apt-get -y update && sudo apt-get -y install software-properties-common git

# fixes prompts during apt installations
RUN echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections
RUN sudo apt-get install -y -q

RUN mkdir -p /opt/klaxalk/git && cd /opt/klaxalk/git && git clone https://github.com/klaxalk/linux-setup

RUN cd /opt/klaxalk/git/linux-setup && ./install.sh --unattended

CMD ["bash"]
