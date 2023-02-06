podman build -f MultistageContainerfile -t hello-java
podman run --env-file environment.txt --rm -d -p 8080:8080 hello-java:latest
echo "mount /dev/sda/ /mnt; podman run --rm -d -p 8080:8080 -e PLATFORM="$(cat /mnt/platform)" -e CLUSTER="$(cat /mnt/cluster)" -e CLUSTER="$(cat /mnt/product)" -e OCP_VERSION="$(cat /mnt/version)" -e HOSTNAME="$(hostname -s)" quay.io/dds/multi-cloud/hello-java"
