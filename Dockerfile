FROM fedora:latest

RUN dnf upgrade -y
RUN dnf install -y \
    wget \
    unzip 

RUN curl -fsSL https://clis.cloud.ibm.com/install/linux | sh && \
    ibmcloud config --check-version=false

WORKDIR /
RUN mkdir /scripts
COPY scripts/run.sh /scripts/run.sh

ENTRYPOINT ["/scripts/run.sh"]
