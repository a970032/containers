#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Magento environment
. /opt/bitnami/scripts/magento-env.sh

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libservice.sh
. /opt/bitnami/scripts/libwebserver.sh

# Catch SIGTERM signal and stop all child processes
_forwardTerm() {
    warn "Caught signal SIGTERM, passing it to child processes..."
    pgrep -P $$ | xargs kill -TERM 2>/dev/null
    wait
    exit $?
}
trap _forwardTerm TERM

# Start cron
if am_i_root; then
    info "** Starting cron **"
    if ! cron_start; then
        error "Failed to start cron. Check that it is installed and its configuration is correct."
        exit 1
    fi
else
    warn "Cron will not be started because of running as a non-root user"
fi

# Start CloudWatch
info "** Starting CloudWatch **"
/opt/aws/amazon-cloudwatch-agent/bin/start-amazon-cloudwatch-agent &

# Start Apache
if [[ -f "/opt/bitnami/scripts/nginx-php-fpm/run.sh" ]]; then
    exec "/opt/bitnami/scripts/nginx-php-fpm/run.sh"
else
    exec "/opt/bitnami/scripts/$(web_server_type)/run.sh"
fi