podman build -f MultistageContainerfile -t hello-java
podman stop hello-java
podman run --env-file environment.txt --rm -d -p 8080:8080 --name hello-java hello-java:latest 
