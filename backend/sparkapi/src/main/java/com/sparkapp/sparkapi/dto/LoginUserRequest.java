package com.sparkapp.sparkapi.dto;

import jakarta.validation.constraints.NotBlank;

public record LoginUserRequest(
    @NotBlank(message = "Email is required")
    String email, 
    
    @NotBlank(message = "Password is required")
    String password) {

}
