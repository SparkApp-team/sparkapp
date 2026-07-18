package com.sparkapp.sparkapi.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.inOrder;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;

import java.util.Optional;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InOrder;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import com.sparkapp.sparkapi.dto.UpdateUserRequest;
import com.sparkapp.sparkapi.exception.EmailAlreadyRegisteredException;
import com.sparkapp.sparkapi.exception.UserNotFoundException;
import com.sparkapp.sparkapi.model.User;
import com.sparkapp.sparkapi.repository.HabitRepository;
import com.sparkapp.sparkapi.repository.UserRepository;

@ExtendWith(MockitoExtension.class)
class UserServiceTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private FakeAuthService fakeAuthService;

    @Mock
    private HabitRepository habitRepository;

    private UserService userService;

    @BeforeEach
    void setUp() {
        userService = new UserService(userRepository, fakeAuthService, habitRepository);
    }

    @Test
    void getCurrentUserReturnsMappedUserResponse() {
        User user = new User();
        user.setId(4L);
        user.setEmail("user@example.com");

        when(fakeAuthService.getCurrentUserId("4")).thenReturn(4L);
        when(userRepository.findById(4L)).thenReturn(Optional.of(user));

        var response = userService.getCurrentUser("4");

        assertEquals(4L, response.id());
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

    @Test
    void updateCurrentUserUpdatesEmailAndReturnsMappedResponse() {
        User user = user(4L, "old@example.com");
        when(fakeAuthService.getCurrentUserId("4")).thenReturn(4L);
        when(userRepository.findById(4L)).thenReturn(Optional.of(user));
        when(userRepository.findByEmail("new@example.com")).thenReturn(Optional.empty());
        when(userRepository.save(user)).thenReturn(user);

        var response = userService.updateCurrentUser(
            "4",
            new UpdateUserRequest("new@example.com")
        );

        assertEquals(4L, response.id());
        assertEquals("new@example.com", response.email());
        assertEquals("new@example.com", user.getEmail());
        verify(userRepository).findByEmail("new@example.com");
        verify(userRepository).save(user);
    }

    @Test
    void updateCurrentUserAllowsKeepingExistingEmail() {
        User user = user(4L, "same@example.com");
        when(fakeAuthService.getCurrentUserId("4")).thenReturn(4L);
        when(userRepository.findById(4L)).thenReturn(Optional.of(user));
        when(userRepository.save(user)).thenReturn(user);

        var response = userService.updateCurrentUser(
            "4",
            new UpdateUserRequest("same@example.com")
        );

        assertEquals("same@example.com", response.email());
        verify(userRepository, never()).findByEmail(anyString());
        verify(userRepository).save(user);
    }

    @Test
    void updateCurrentUserThrowsWhenEmailBelongsToAnotherUser() {
        User user = user(4L, "old@example.com");
        User otherUser = user(5L, "taken@example.com");
        when(fakeAuthService.getCurrentUserId("4")).thenReturn(4L);
        when(userRepository.findById(4L)).thenReturn(Optional.of(user));
        when(userRepository.findByEmail("taken@example.com")).thenReturn(Optional.of(otherUser));

        assertThrows(
            EmailAlreadyRegisteredException.class,
            () -> userService.updateCurrentUser(
                "4",
                new UpdateUserRequest("taken@example.com")
            )
        );

        assertEquals("old@example.com", user.getEmail());
        verify(userRepository, never()).save(any(User.class));
    }

    @Test
    void updateCurrentUserThrowsWhenUserDoesNotExist() {
        when(fakeAuthService.getCurrentUserId("4")).thenReturn(4L);
        when(userRepository.findById(4L)).thenReturn(Optional.empty());

        assertThrows(
            UserNotFoundException.class,
            () -> userService.updateCurrentUser(
                "4",
                new UpdateUserRequest("new@example.com")
            )
        );

        verify(userRepository, never()).save(any(User.class));
    }

    @Test
    void deleteCurrentUserDeletesOwnedHabitsBeforeUser() {
        User user = user(4L, "user@example.com");
        when(fakeAuthService.getCurrentUserId("4")).thenReturn(4L);
        when(userRepository.findById(4L)).thenReturn(Optional.of(user));

        userService.deleteCurrentUser("4");

        InOrder deletionOrder = inOrder(habitRepository, userRepository);
        deletionOrder.verify(habitRepository).deleteAllByUserId(4L);
        deletionOrder.verify(userRepository).delete(user);
    }

    @Test
    void deleteCurrentUserThrowsWithoutDeletingWhenUserDoesNotExist() {
        when(fakeAuthService.getCurrentUserId("4")).thenReturn(4L);
        when(userRepository.findById(4L)).thenReturn(Optional.empty());

        assertThrows(UserNotFoundException.class, () -> userService.deleteCurrentUser("4"));

        verifyNoInteractions(habitRepository);
        verify(userRepository, never()).delete(any(User.class));
    }

    private User user(Long id, String email) {
        User user = new User();
        user.setId(id);
        user.setEmail(email);
        return user;
    }
}
