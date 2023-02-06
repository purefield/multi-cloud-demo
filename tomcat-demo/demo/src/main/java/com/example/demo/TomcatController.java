package com.example.demo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class TomcatController {

    @Autowired
    private Environment env;

    @GetMapping("/")
    public String hello() {
	String msg = String.format("Hello World! %s", getEnv());
        System.out.print(msg);
        return String.format(msg);
    }
    
    private String getEnv() {
        String version = "1";
        String hostname    = env.getProperty("HOSTNAME");
        String environment = env.getProperty("ENVIRONMENT", "development");
        String cluster     = env.getProperty("CLUSTER");
        String platform    = env.getProperty("PLATFORM");
        String ocpVersion  = env.getProperty("VERSION");
        String type        = env.getProperty("TYPE", "tomcat-container");

        StringBuilder sb = new StringBuilder("v");
        sb.append(version)
        .append(" on ")
        .append(String.format("%9s", platform))
        .append(" OCP v")
        .append(String.format("%-7s", ocpVersion))
        .append(" ")
        .append(String.format("%28s", hostname))
        .append(" in ")
        .append(String.format("%11s", environment))
        .append(".")
        .append(cluster)
        .append(".")
        .append(type)
        .append("\n")
        ;

        return sb.toString();
    }
}
