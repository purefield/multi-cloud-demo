# Create ConfigMap for watch-container.sh
oc delete configmap -n multi-cloud watch-multi-cloud
oc create configmap -n multi-cloud watch-multi-cloud --from-file=watch-container.sh --from-file=curl_filtered --from-file=watcher.sh

# Create Pod
oc delete pod -l app=watch-multi-cloud -n multi-cloud
oc apply -f app.yaml

