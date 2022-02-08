FROM ubuntu:latest

SHELL ["/bin/bash", "-c"] 

# Install dependencies
ENV TZ=America/Sao_Paulo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
  && apt-get update \
  && apt-get install -y wget curl unzip ca-certificates git

# Install tfenv
ARG tfenv=/opt/tfenv/bin

RUN git clone https://github.com/tfutils/tfenv.git /opt/tfenv \
  && chmod -R 777 /opt/tfenv \ 
  && $tfenv/tfenv install latest \
  && $tfenv/tfenv use latest \
  && ln -snf $tfenv /usr/bin/tfenv

# Install catingore
RUN mkdir -p /root/scripts 
WORKDIR /root/scripts
RUN bash -c "$(wget -qO - 'https://raw.githubusercontent.com/miquelis/catignore/master/scripts/install.sh')" '' -i -s linux -a amd64 
WORKDIR /root

ARG catingore=/opt/catignore

RUN rm -rf /root/scripts \ 
  && ln -snf $catingore /usr/bin/catignore \
  && apt clean \ 
  && rm -rf /var/lib/apt/lists/*

ENV PATH="${PATH}:${tfenv}:${catingore}"

ENTRYPOINT ["/usr/bin/bash"]