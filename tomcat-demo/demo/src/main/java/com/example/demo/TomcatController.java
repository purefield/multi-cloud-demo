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

    @GetMapping("/hellotomcat")
    public String hello(@RequestParam(defaultValue = "Tomcat") String who) {
        System.out.print(String.format("Hello %s World! %s", who, getEnv()));
        return String.format("Hello %s World! %s", who, getEnv());
    }
    private String getEnv() {
        String version = "2";
        String hostname = env.getProperty("HOSTNAME");
        String environment = env.getProperty("ENV");
        String cluster = env.getProperty("CLUSTER");
        String platform = env.getProperty("PLATFORM");
        String ocpVersion = env.getProperty("OCP_VERSION");

        StringBuilder sb = new StringBuilder("v");
        sb.append(version)
        .append(" ")
        .append(environment)
        .append(".")
        .append(cluster)
        .append(" on ")
        .append(platform)
        .append(" OCP v")
        .append(ocpVersion)
        .append(" ")
        .append(hostname)
        .append("\n")
        ;

        return sb.toString();
    }
}
