package com.sparkapp.sparkapi.dto;

import static org.junit.jupiter.api.Assertions.assertTrue;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import jakarta.validation.Validation;
import jakarta.validation.Validator;

public class LoginUserRequestTest {
    private Validator validator;
    
    @BeforeEach
    void setUp() {
        validator = Validation
            .buildDefaultValidatorFactory()
            .getValidator();
    }

    @Test
    void validRequestHasNoViolations() {
        var request = new LoginUserRequest(
            "test@example.com",
            "password"
        );

        var violations = validator.validate(request);

        assertTrue(violations.isEmpty());
    }

    @Test
    void blankEmailProducesRequiredViolation() {
        var request = new LoginUserRequest(
            " ",
            "password"
        );

        var violations = validator.validate(request);

        assertTrue(violations.stream().anyMatch(violation ->
            violation.getPropertyPath().toString().equals("email")
            && violation.getMessage().equals("Email is required")
        ));
    }

    @Test
    void blankPasswordProducesRequiredViolation() {
        var request = new LoginUserRequest(
            "test@example.com",
            " "
        );

        var violations = validator.validate(request);

        assertTrue(violations.stream().anyMatch(violation ->
            violation.getPropertyPath().toString().equals("password")
            && violation.getMessage().equals("Password is required")
        ));
    }
}
