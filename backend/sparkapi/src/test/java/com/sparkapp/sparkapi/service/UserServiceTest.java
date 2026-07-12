package com.sparkapp.sparkapi.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.Optional;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import com.sparkapp.sparkapi.exception.UserNotFoundException;
import com.sparkapp.sparkapi.model.User;
import com.sparkapp.sparkapi.repository.UserRepository;

@ExtendWith(MockitoExtension.class)
class UserServiceTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private FakeAuthService fakeAuthService;

    private UserService userService;

    @BeforeEach
    void setUp() {
        userService = new UserService(userRepository, fakeAuthService);
    }

    @Test
    void getCurrentUserReturnsMappedUserResponse() {
        User user = new User();
        user.setId(4L);
        user.setEmail("user@example.com");

        when(fakeAuthService.getCurrentUserId("4")).thenReturn(4L);
        when(userRepository.findById(4L)).thenReturn(Optional.of(user));

        var response = userService.getCurrentUser("4");

        assertEquals("4", response.userId());
        assertEquals("user@example.com", response.email());
        verify(userRepository).findById(4L);
    }

    @Test
    void getCurrentUserThrowsWhenUserDoesNotExist() {
        when(fakeAuthService.getCurrentUserId("4")).thenReturn(4L);
        when(userRepository.findById(4L)).thenReturn(Optional.empty());

        assertThrows(UserNotFoundException.class, () -> userService.getCurrentUser("4"));
        verify(userRepository).findById(4L);
    }
}