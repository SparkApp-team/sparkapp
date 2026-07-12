package com.sparkapp.sparkapi.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

import java.util.Optional;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import com.sparkapp.sparkapi.dto.LoginUserRequest;
import com.sparkapp.sparkapi.dto.RegisterUserRequest;
import com.sparkapp.sparkapi.exception.EmailAlreadyRegisteredException;
import com.sparkapp.sparkapi.exception.InvalidCredentialsException;
import com.sparkapp.sparkapi.exception.PasswordDoNotMatchException;
import com.sparkapp.sparkapi.model.User;
import com.sparkapp.sparkapi.repository.UserRepository;

class AuthServiceTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private FakeHashService fakeHashService;

    @Mock
    private FakeAuthService fakeAuthService;

    private AuthService authService;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
        authService = new AuthService(fakeHashService, userRepository,  fakeAuthService);
    }

    @Test
    void registerUserThrowsWhenPasswordsDoNotMatch() {
        var request = new RegisterUserRequest(
            "test@example.com",
            "password123",
            "different-password"
        );



        assertThrows(
            PasswordDoNotMatchException.class,
            () -> authService.registerUser(request)
        );

        verifyNoInteractions(userRepository, fakeHashService);
    }

    @Test
    void registerUserThrowsWhenEmailAlreadyRegistered() {
        var request = new RegisterUserRequest(
            "test@example.com",
            "password123",
            "password123"
        );

        when(userRepository.findByEmail("test@example.com"))
            .thenReturn(Optional.of(new User()));

        assertThrows(
            EmailAlreadyRegisteredException.class,
            () -> authService.registerUser(request)
        );

        verify(userRepository).findByEmail("test@example.com");
        verifyNoInteractions(fakeHashService);
        verify(userRepository, never()).save(any(User.class));
    }

    @Test
    void registerUserHashesPasswordSavesUserAndReturnsResponse() {
        var request = new RegisterUserRequest(
            "test@example.com",
            "password123",
            "password123"
        );

        when(userRepository.findByEmail("test@example.com"))
            .thenReturn(Optional.empty());
        when(fakeHashService.hashPassword("password123"))
            .thenReturn("hashed-password");

        when(fakeAuthService.getCurrentUserToken(1L))
            .thenReturn("1");

        when(userRepository.save(any(User.class))).thenAnswer(invocation -> {
            User user = invocation.getArgument(0);
            user.setId(1L);
            return user;
        });

        var response = authService.registerUser(request);

        assertEquals("1", response.userId());
        assertEquals("test@example.com", response.email());

        ArgumentCaptor<User> userCaptor = ArgumentCaptor.forClass(User.class);
        verify(userRepository).save(userCaptor.capture());

        User savedUser = userCaptor.getValue();
        assertEquals("test@example.com", savedUser.getEmail());
        assertEquals("hashed-password", savedUser.getPasswordHash());

        verify(fakeHashService).hashPassword("password123");
    }
}