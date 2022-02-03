FROM ubuntu:latest

SHELL ["/bin/bash", "-c"] 

# Install dependencies
ENV TZ=America/Sao_Paulo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update
# RUN apt-get install -y wget curl ca-certificates software-properties-common git
RUN apt-get install -y wget curl unzip ca-certificates git


RUN git clone https://github.com/tfutils/tfenv.git /opt/tfenv 
RUN chmod -R 777 /opt/tfenv 
RUN echo 'export PATH="/opt/tfenv/bin:$PATH"' >> ~/.bashrc 
RUN source ~/.bashrc
RUN /opt/tfenv/bin/tfenv install latest
RUN /opt/tfenv/bin/tfenv use latest


# Install Terraform
# RUN wget -qO- https://apt.releases.hashicorp.com/gpg | apt-key add - \
#   && apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
#   && apt-get update -y \
#   && apt-get install terraform 


RUN mkdir -p /root/scripts 
WORKDIR /root/scripts
RUN bash -c "$(wget -qO - 'https://raw.githubusercontent.com/miquelis/catignore/master/install.sh')" '' -i -s linux -a amd64 
RUN echo 'export PATH="/opt/catignore:$PATH"' >> ~/.bashrc 
RUN source ~/.bashrc
WORKDIR /root
RUN rm -rf /root/scripts

RUN apt clean
RUN rm -rf /var/lib/apt/lists/*

ENTRYPOINT  ["/bin/bash"]