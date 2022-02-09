FROM ubuntu:latest

SHELL ["/bin/bash", "-c"] 

# Install dependencies
ENV TZ=America/Sao_Paulo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
  && apt-get update \
  && apt-get install -y wget curl unzip ca-certificates git

# Install tfenv
ARG DIR_TFENV=/opt/tfenv/bin
ARG LINK_USR=/usr/bin

RUN git clone https://github.com/tfutils/tfenv.git /opt/tfenv \
  && chmod -R 777 /opt/tfenv \ 
  && ln -sf $DIR_TFENV/tfenv $LINK_USR/tfenv \
  && ln -sf $DIR_TFENV/terraform $LINK_USR/terraform \
  && tfenv install latest \
  && tfenv use latest 

# Install yq
RUN mkdir -p /opt/yq/bin
WORKDIR /opt/yq/bin
RUN wget -qO- https://api.github.com/repos/mikefarah/yq/releases/latest \
  | grep browser_download_url | grep linux_amd64.tar.gz | cut -d '"' -f 4  \
  | xargs wget -O - | tar -xz \
  && ln -sf /opt/yq/bin/yq_linux_amd64 $LINK_USR/yq \
  && rm -rf *.sh *.1

# Install catingore
RUN mkdir -p /root/scripts 
WORKDIR /root/scripts
RUN bash -c "$(wget -qO - 'https://raw.githubusercontent.com/miquelis/catignore/master/scripts/install.sh')" '' -i -s linux -a amd64 

WORKDIR /root
# ARG catingore=/opt/catignore

RUN rm -rf /root/scripts \  
  && apt clean \ 
  && rm -rf /var/lib/apt/lists/*

# ENV PATH="${PATH}:${tfenv}:${catingore}"

ENTRYPOINT ["/usr/bin/bash"]