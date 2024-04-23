#!/bin/bash
oc config use-context acm
urls=$(for cluster in $(oc get ManagedClusters -o yaml | grep 'console-' | perl -pe 's/[^v]+value[^.]+//'); do echo -n "http://hello-dev-multi-cloud$cluster http://hello-prod-multi-cloud$cluster "; done)

cmd="echo '* Global Load Balancer'; echo ' - Production https://multi-cloud.box--eng.com'; \$HOME/curl_filtered https://multi-cloud.box--eng.com; echo ' '; echo ' - Development https://multi-cloud.dev.box--eng.com'; \$HOME/curl_filtered https://multi-cloud.dev.box--eng.com; echo ' '; echo ' '; echo '* Individual Clusters'; \$HOME/curl_filtered $urls "
export HOME=/app
echo "$cmd" | envsubst > container/watch-container.sh
export HOME=$( cd "$(dirname "$([[ $0 != $BASH_SOURCE ]] && echo "$BASH_SOURCE" || echo "$0" )")" ; pwd -P )
watch -t bash -c "$(echo "$cmd" | envsubst)"
