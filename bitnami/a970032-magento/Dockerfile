#Install CW
FROM debian:latest as build

RUN apt-get update &&  \
    apt-get install -y ca-certificates curl && \
    rm -rf /var/lib/apt/lists/*

RUN curl -O https://s3.amazonaws.com/amazoncloudwatch-agent/debian/amd64/latest/amazon-cloudwatch-agent.deb && \
    dpkg -i -E amazon-cloudwatch-agent.deb && \
    rm -rf /tmp/* && \
    rm -rf /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard && \
    rm -rf /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl && \
    rm -rf /opt/aws/amazon-cloudwatch-agent/bin/config-downloader

FROM docker.io/bitnami/magento:2.4.6
#CW
COPY --from=build /tmp /tmp
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=build /opt/aws/amazon-cloudwatch-agent /opt/aws/amazon-cloudwatch-agent
COPY cwagentconfig.json /etc/cwagentconfig
ENV RUN_IN_CONTAINER="True"
ENV AWS_REGION ap-east-1

# Execute command before setup
COPY libmagento.sh /opt/bitnami/scripts/libmagento.sh
COPY run.sh /opt/bitnami/scripts/magento/run.sh
COPY setup.sh /opt/bitnami/scripts/magento/setup.sh
RUN install_packages zip unzip collectd systemctl

# Install AWS CLI

COPY awscliv2.zip  awscliv2.zip
RUN unzip awscliv2.zip
RUN ./aws/install

RUN mkdir -p /root/.aws/

#Start CW
COPY magentolog.json /opt/aws/amazon-cloudwatch-agent/bin/default_linux_config.json
CMD [ "/opt/bitnami/scripts/magento/run.sh" ]
