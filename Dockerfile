FROM ubuntu:latest

SHELL ["/bin/bash", "-c"] 

# Install dependencies
ENV TZ=America/Sao_Paulo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update
RUN apt-get install -y wget curl unzip ca-certificates git

# Install tfenv
RUN git clone https://github.com/tfutils/tfenv.git /opt/tfenv 
RUN chmod -R 777 /opt/tfenv 
RUN echo 'export PATH="/opt/tfenv/bin:$PATH"' >> ~/.bashrc 
RUN source ~/.bashrc
RUN /opt/tfenv/bin/tfenv install latest
RUN /opt/tfenv/bin/tfenv use latest

# Install catingore
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