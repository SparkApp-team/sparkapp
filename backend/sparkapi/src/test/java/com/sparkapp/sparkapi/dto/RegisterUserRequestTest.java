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

    @Test
    void blankEmailProducesRequiredViolation() {
        var request = new RegisterUserRequest(
            " ",
            "password",
            "password"
        );

        var violations = validator.validate(request);

        assertTrue(violations.stream().anyMatch(violation ->
            violation.getPropertyPath().toString().equals("email")
            && violation.getMessage().equals("Email is required")
        ));
    }

    @Test
    void malformedEmailProducesValidEmailViolation() {
        var request = new RegisterUserRequest(
            "not-an-email",
            "password",
            "password"
        );

        var violations = validator.validate(request);

        assertTrue(violations.stream().anyMatch(violation ->
            violation.getPropertyPath().toString().equals("email")
            && violation.getMessage().equals("Email must be valid")
        ));
    }

    @Test
    void blankPasswordProducesRequiredViolation() {
        var request = new RegisterUserRequest(
            "test@example.com",
            " ",
            "password"
        );

        var violations = validator.validate(request);

        assertTrue(violations.stream().anyMatch(violation ->
            violation.getPropertyPath().toString().equals("password")
            && violation.getMessage().equals("Password is required")
        ));
    }

    @Test
    void shortPasswordProducesMinimumLengthViolation() {
        var request = new RegisterUserRequest(
            "test@example.com",
            "1234567",
            "1234567"
        );

        var violations = validator.validate(request);

        assertTrue(violations.stream().anyMatch(violation ->
            violation.getPropertyPath().toString().equals("password")
            && violation.getMessage().equals("Password must be at least 8 characters")
        ));
    }

    @Test
    void exactlyEightCharacterPasswordHasNoViolations() {
        var request = new RegisterUserRequest(
            "test@example.com",
            "12345678",
            "12345678"
        );

        var violations = validator.validate(request);

        assertTrue(violations.isEmpty());
    }

    @Test
    void blankPasswordConfirmationProducesRequiredViolation() {
        var request = new RegisterUserRequest(
            "test@example.com",
            "password",
            " "
        );

        var violations = validator.validate(request);

        assertTrue(violations.stream().anyMatch(violation ->
            violation.getPropertyPath().toString().equals("passwordConfirmation")
            && violation.getMessage().equals("Password confirmation is required")
        ));
    }

}
