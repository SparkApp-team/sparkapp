package com.sparkapp.sparkapi.controller;

import org.springframework.web.bind.annotation.RestController;
import com.sparkapp.sparkapi.dto.HealthResponse;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@RestController
public class HealthController {

    @GetMapping("/health")
    public HealthResponse healthCheck() {
        return new HealthResponse("ok");
    }
}
