# About This App

Goal is to have an application that can be run within a Tomcat Server. Currently tested on Apache Tomcat 10.0.27.

# Quick SetUp
## Build Instructions

```
mvn clean package
```

This will create a war file in the target directory
move this war file to the Tomcat webapps directory and restart the Tomcat Server. The **"finalName"** tag in the pom.xml controls the name of the war file and thus the context root of the application when it runs in the Tomcat server.

The application will be available as host:port/app-name/hellotomcat. 

For exmaple (depending on how Tomcat is setup):

``` 
curl http://localhost:8080/demo/hellotomcat
OR
curl 'http://localhost:8080/demo/hellotomcat?who=YourTomcat'
```

## Running Locally

*Note the lack of a context root when running locally.*
```
mvn clean spring-boot:run
curl http://localhost:8080/hellotomcat
OR
curl 'http://localhost:8080/hellotomcat?who=MyTomcat'
```

## Environment Variables

The application is designed to output some environment variables. You can use the included shell script to set them up while testing.

```
source ./export-envs.sh
```
Then use mvn in the same shell to run the app locally OR use the same shell to start the Tomcat Server.

## Running In A Container
There are 2 Container files provided if you wish to run the Tomcat Server in a container rather than standalone (as in your local environment or in a VM).

If have already built the application with the above instructions, use the **Containerfile** to create the container image.

```
podman build -t demo-tomcat .
```

If you do not have a java / maven local environment, use the **MultistageContainerfile** to compile the application and then deploy it to a containerized Tomcat Server.

```
podman build -t demo-tomcat -f MultistageContainerfile  
```

In either case, you can then run the newly created image.

```
podman run --name demo -p 8080:8080 --rm  demo-tomcat:latest
```
Then access the running container. Note that this is running a Tomcat Server inside the container and thus needs the context root as mentioned above.

```
curl http://localhost:8080/demo/hellotomcat
OR
curl 'http://localhost:8080/demo/hellotomcat?who=ContainerTomcat'
```

