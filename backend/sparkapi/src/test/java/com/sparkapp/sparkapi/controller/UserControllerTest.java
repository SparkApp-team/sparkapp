package com.sparkapp.sparkapi.controller;

import static org.hamcrest.Matchers.matchesPattern;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.util.Optional;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.webmvc.test.autoconfigure.WebMvcTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

import com.sparkapp.sparkapi.repository.UserRepository;
import com.sparkapp.sparkapi.service.FakeAuthService;
import com.sparkapp.sparkapi.service.FakeHashService;
import com.sparkapp.sparkapi.model.User;

@WebMvcTest(UserController.class)
public class UserControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockitoBean
    private UserRepository userRepository;

    @MockitoBean
    private FakeAuthService fakeAuthService;

    @MockitoBean 
    private FakeHashService fakeHashService;

    @Test
    void createUserReturnsMockedUserWithId() throws Exception {

        when(fakeAuthService.getCurrentUserId("123")).thenReturn(123L);

        when(userRepository.save(any(User.class))).thenAnswer(invocation -> {
            User user = invocation.getArgument(0);
            user.setId(1L);
            return user;
        });
        mockMvc.perform(post("/users")
                .header("X-USER-ID", "123")
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                        {
                            "email": "test@example.com",
                            "password": "password"
                        }
                        """))
                .andExpect(status().isOk())
                .andExpect(content().contentTypeCompatibleWith(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.id", matchesPattern("\\d+")))
                .andExpect(jsonPath("$.email").value("test@example.com"));
        verify(fakeAuthService).getCurrentUserId("123");
        verify(fakeHashService).hashPassword("password");

    }

    @Test
    void getCurrentUserReturnsUser() throws Exception {
        User user = new User();
        user.setId(1L);
        user.setEmail("test@example.com");
        user.setPasswordHash("TODO");

        when(fakeAuthService.getCurrentUserId("1")).thenReturn(1L);
        when(userRepository.findById(1L)).thenReturn(Optional.of(user));

        mockMvc.perform(get("/users/me")
                .header("X-USER-ID", "1"))
                .andExpect(status().isOk())
                .andExpect(content().contentTypeCompatibleWith(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.id").value("1"))
                .andExpect(jsonPath("$.email").value("test@example.com"));

        verify(fakeAuthService).getCurrentUserId("1");
    }
}
