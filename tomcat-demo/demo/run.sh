podman build -f MultistageContainerfile -t hello-java
podman stop hello-java
podman run --env-file environment.txt --rm -d -p 8080:8080 --name hello-java hello-java:latest 
echo 'mount /dev/sda/ /mnt; podman pull quay.io/dds/multi-cloud/hello-java; podman stop hello-java;  podman run --rm -d -p 8080:8080 --name hello-java -e PLATFORM="$(cat /mnt/platform)" -e CLUSTER="$(cat /mnt/cluster)" -e CLUSTER="$(cat /mnt/cluster)" -e VERSION="$(cat /mnt/version)" -e ENVIRONMENT="$($(cat /mnt/environment):-development)" -e HOSTNAME="$(hostname -s)" -e TYPE="tomcat-vm" quay.io/dds/multi-cloud/hello-java'
