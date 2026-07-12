package com.sparkapp.sparkapi.dto;

import static org.junit.jupiter.api.Assertions.assertTrue;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import jakarta.validation.Validation;
import jakarta.validation.Validator;

public class RegisterUserRequestTest {
    private Validator validator;
    
    @BeforeEach
    void setUp() {
        validator = Validation
            .buildDefaultValidatorFactory()
            .getValidator();
    }

    @Test
    void validRequestHasNoViolations() {
        var request = new RegisterUserRequest(
            "test@example.com",
            "password",
            "password"
        );

        var violations = validator.validate(request);

        assertTrue(violations.isEmpty());
    }
}
