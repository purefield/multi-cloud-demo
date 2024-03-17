 podman build . -t hello
 podman login registry.gitlab.com -u openshift-token 
 podman tag hello:latest registry.gitlab.com/gitlab-com/partners/alliance/ibm-red-hat/sandbox/customer-k/multi-cloud-demo/hello:latest
 podman push registry.gitlab.com/gitlab-com/partners/alliance/ibm-red-hat/sandbox/customer-k/multi-cloud-demo/hello:latest 
