package com.sparkapp.sparkapi.controller;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.webmvc.test.autoconfigure.WebMvcTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

import com.sparkapp.sparkapi.dto.UserResponse;
import com.sparkapp.sparkapi.exception.InvalidCredentialsException;
import com.sparkapp.sparkapi.service.AuthService;

@WebMvcTest(AuthController.class)
class AuthControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockitoBean
    private AuthService authService;

    @Test
    void registerReturnsUserResponse() throws Exception {
        when(authService.registerUser(any()))
            .thenReturn(new UserResponse("1", "test@example.com"));

        mockMvc.perform(post("/auth/register")
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                    {
                      "email": "test@example.com",
                      "password": "password123",
                      "passwordConfirmation": "password123"
                    }
                    """))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.userId").value("1"))
            .andExpect(jsonPath("$.email").value("test@example.com"));

        verify(authService).registerUser(any());
    }

    @Test
    void loginReturnsUserResponse() throws Exception {
        when(authService.loginUser(any()))
            .thenReturn(new UserResponse("1", "test@example.com"));

        mockMvc.perform(post("/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                    {
                      "email": "test@example.com",
                      "password": "password123"
                    }
                    """))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.userId").value("1"))
            .andExpect(jsonPath("$.email").value("test@example.com"));

        verify(authService).loginUser(any());
    }

    @Test
    void registerReturnsValidationErrorsForInvalidRequest() throws Exception {
        mockMvc.perform(post("/auth/register")
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                    {
                      "email": "not-an-email",
                      "password": "short",
                      "passwordConfirmation": ""
                    }
                    """))
            .andExpect(status().isBadRequest())
            .andExpect(jsonPath("$.message").value("Validation failed"))
            .andExpect(jsonPath("$.fieldErrors.email").value("Email must be valid"))
            .andExpect(jsonPath("$.fieldErrors.password")
                .value("Password must be at least 8 characters"))
            .andExpect(jsonPath("$.fieldErrors.passwordConfirmation")
                .value("Password confirmation is required"));
    }

    @Test
    void loginReturnsUnauthorizedForInvalidCredentials() throws Exception {
        when(authService.loginUser(any())).thenThrow(new InvalidCredentialsException());

        mockMvc.perform(post("/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                    {
                      "email": "test@example.com",
                      "password": "password123"
                    }
                    """))
            .andExpect(status().isUnauthorized())
            .andExpect(jsonPath("$.message").value("Invalid email or password"));
    }
}