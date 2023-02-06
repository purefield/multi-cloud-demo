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
    public String hello(@RequestParam(defaultValue = "Tomcat") String who) {
        System.out.print(String.format("Hello %s World! %s", who, getEnv()));
        return String.format("Hello %s World! %s", who, getEnv());
    }
    
    private String getEnv() {
        String version = "2";
        String hostname    = env.getProperty("HOSTNAME");
        String environment = env.getProperty("ENVIRONMENT");
        String cluster     = env.getProperty("CLUSTER");
        String platform    = env.getProperty("PLATFORM");
        String ocpVersion  = env.getProperty("VERSION");

        StringBuilder sb = new StringBuilder("v");
        sb.append(version)
        .append(" ")
        .append(" on ")
        .append(String.format("%[9]s", platform))
        .append(" OCP v")
        .append(String.format("%-[7]s", ocpVersion)
        .append(" ")
        .append(String.format("%[10]s", hostname)
        .append(" in ")
        .append(String.format("%[11]s", environment)
        .append(".")
        .append(String.format("%-[5]s", cluster)
        .append("\n")
        ;

        return sb.toString();
    }
}
