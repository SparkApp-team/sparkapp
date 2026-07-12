package com.sparkapp.sparkapi.controller;

import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.webmvc.test.autoconfigure.WebMvcTest;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

import com.sparkapp.sparkapi.dto.UserResponse;
import com.sparkapp.sparkapi.exception.UserNotFoundException;
import com.sparkapp.sparkapi.service.UserService;

@WebMvcTest(UserController.class)
class UserControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockitoBean
    private UserService userService;

    @Test
    void getCurrentUserReturnsUser() throws Exception {
        when(userService.getCurrentUser("1"))
            .thenReturn(new UserResponse("1", "test@example.com"));

        mockMvc.perform(get("/users/me").header("X-USER-ID", "1"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.userId").value("1"))
            .andExpect(jsonPath("$.email").value("test@example.com"));
    }

    @Test
    void getCurrentUserReturnsNotFoundWhenUserDoesNotExist() throws Exception {
        when(userService.getCurrentUser("1")).thenThrow(new UserNotFoundException());

        mockMvc.perform(get("/users/me").header("X-USER-ID", "1"))
            .andExpect(status().isNotFound())
            .andExpect(jsonPath("$.message").value("User not found"));
    }
}