package com.sparkapp.sparkapi.dto;

import jakarta.validation.constraints.NotBlank;

public record UpdateHabitRequest(
    @NotBlank
    String name, 
    
    @NotBlank
    String frequency) {

}
