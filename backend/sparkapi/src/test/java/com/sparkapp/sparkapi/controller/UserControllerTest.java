package com.sparkapp.sparkapi.controller;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.patch;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.webmvc.test.autoconfigure.WebMvcTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

import com.sparkapp.sparkapi.dto.UpdateUserRequest;
import com.sparkapp.sparkapi.dto.UserResponse;
import com.sparkapp.sparkapi.exception.EmailAlreadyRegisteredException;
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
            .thenReturn(new UserResponse(1L, "test@example.com"));

        mockMvc.perform(get("/users/me").header("X-USER-ID", "1"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.id").value(1))
            .andExpect(jsonPath("$.email").value("test@example.com"));
    }

    @Test
    void getCurrentUserReturnsNotFoundWhenUserDoesNotExist() throws Exception {
        when(userService.getCurrentUser("1")).thenThrow(new UserNotFoundException());

        mockMvc.perform(get("/users/me").header("X-USER-ID", "1"))
            .andExpect(status().isNotFound())
            .andExpect(jsonPath("$.message").value("User not found"));
    }

    @Test
    void updateCurrentUserReturnsUpdatedUser() throws Exception {
        when(userService.updateCurrentUser(eq("1"), any(UpdateUserRequest.class)))
            .thenReturn(new UserResponse(1L, "updated@example.com"));

        mockMvc.perform(patch("/users/me")
                .header("X-USER-ID", "1")
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                    {
                      "email": "updated@example.com"
                    }
                    """))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.id").value(1))
            .andExpect(jsonPath("$.email").value("updated@example.com"));

        verify(userService).updateCurrentUser(eq("1"), any(UpdateUserRequest.class));
    }

    @Test
    void updateCurrentUserReturnsBadRequestWhenEmailIsInvalid() throws Exception {
        mockMvc.perform(patch("/users/me")
                .header("X-USER-ID", "1")
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                    {
                      "email": "not-an-email"
                    }
                    """))
            .andExpect(status().isBadRequest())
            .andExpect(jsonPath("$.message").value("Validation failed"))
            .andExpect(jsonPath("$.fieldErrors.email").value("Email must be valid"));

        verifyNoInteractions(userService);
    }

    @Test
    void updateCurrentUserReturnsBadRequestWhenEmailIsBlank() throws Exception {
        mockMvc.perform(patch("/users/me")
                .header("X-USER-ID", "1")
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                    {
                      "email": ""
                    }
                    """))
            .andExpect(status().isBadRequest())
            .andExpect(jsonPath("$.message").value("Validation failed"))
            .andExpect(jsonPath("$.fieldErrors.email").value("Email is required"));

        verifyNoInteractions(userService);
    }

    @Test
    void updateCurrentUserReturnsConflictWhenEmailIsRegistered() throws Exception {
        when(userService.updateCurrentUser(eq("1"), any(UpdateUserRequest.class)))
            .thenThrow(new EmailAlreadyRegisteredException());

        mockMvc.perform(patch("/users/me")
                .header("X-USER-ID", "1")
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                    {
                      "email": "taken@example.com"
                    }
                    """))
            .andExpect(status().isConflict())
            .andExpect(jsonPath("$.message").value("Email is already registered"))
            .andExpect(jsonPath("$.fieldErrors.email").value("Email is already registered"));
    }

    @Test
    void updateCurrentUserReturnsNotFoundWhenUserDoesNotExist() throws Exception {
        when(userService.updateCurrentUser(eq("1"), any(UpdateUserRequest.class)))
            .thenThrow(new UserNotFoundException());

        mockMvc.perform(patch("/users/me")
                .header("X-USER-ID", "1")
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                    {
                      "email": "updated@example.com"
                    }
                    """))
            .andExpect(status().isNotFound())
            .andExpect(jsonPath("$.message").value("User not found"));
    }

    @Test
    void deleteCurrentUserReturnsNoContent() throws Exception {
        mockMvc.perform(delete("/users/me").header("X-USER-ID", "1"))
            .andExpect(status().isNoContent());

        verify(userService).deleteCurrentUser("1");
    }

    @Test
    void deleteCurrentUserReturnsNotFoundWhenUserDoesNotExist() throws Exception {
        doThrow(new UserNotFoundException()).when(userService).deleteCurrentUser("1");

        mockMvc.perform(delete("/users/me").header("X-USER-ID", "1"))
            .andExpect(status().isNotFound())
            .andExpect(jsonPath("$.message").value("User not found"));
    }
}
