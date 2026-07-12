package com.sparkapp.sparkapi.controller;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Test;

class HealthControllerTest {

    @Test
    void healthCheckReturnsOkStatus() {
        var response = new HealthController().healthCheck();

        assertEquals("ok", response.status());
    }
}