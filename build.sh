source gitlab.token
podman build . -t hello
podman login registry.gitlab.com -u openshift-token -p "$token"
# version 1 as v1
perl -pe 's/(VERSION\D+)\d+$/${1}1/' -i server.js
podman tag hello:latest registry.gitlab.com/gitlab-com/partners/alliance/ibm-red-hat/sandbox/customer-k/multi-cloud-demo/hello:prod
podman push registry.gitlab.com/gitlab-com/partners/alliance/ibm-red-hat/sandbox/customer-k/multi-cloud-demo/hello:prod
# version 2 as latest
perl -pe 's/(VERSION\D+)\d+$/${1}2/' -i server.js
podman tag hello:latest registry.gitlab.com/gitlab-com/partners/alliance/ibm-red-hat/sandbox/customer-k/multi-cloud-demo/hello:latest
podman push registry.gitlab.com/gitlab-com/partners/alliance/ibm-red-hat/sandbox/customer-k/multi-cloud-demo/hello:latest 
