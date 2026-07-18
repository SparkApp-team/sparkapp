package com.sparkapp.sparkapi.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sparkapp.sparkapi.dto.UpdateUserRequest;
import com.sparkapp.sparkapi.dto.UserResponse;
import com.sparkapp.sparkapi.exception.EmailAlreadyRegisteredException;
import com.sparkapp.sparkapi.exception.UserNotFoundException;
import com.sparkapp.sparkapi.model.User;
import com.sparkapp.sparkapi.repository.HabitRepository;
import com.sparkapp.sparkapi.repository.UserRepository;

@Service
public class UserService {

    private final HabitRepository habitRepository;
    private final UserRepository userRepository;
    private final FakeAuthService fakeAuthService;

    public UserService(UserRepository userRepository,
            FakeAuthService fakeAuthService, HabitRepository habitRepository) {
        this.userRepository = userRepository;
        this.fakeAuthService = fakeAuthService;
        this.habitRepository = habitRepository;
    }

    public UserResponse getCurrentUser(String userIdHeader) {
        Long currentUserId = fakeAuthService
                .getCurrentUserId(userIdHeader);

        User user = userRepository.findById(currentUserId)
                .orElseThrow(UserNotFoundException::new);

        return new UserResponse(user.getId(), user.getEmail());

    }

    public UserResponse updateCurrentUser(
            String userIdHeader,
            UpdateUserRequest request) {
        Long currentUserId = fakeAuthService
                .getCurrentUserId(userIdHeader);

        User user = userRepository.findById(currentUserId)
                .orElseThrow(UserNotFoundException::new);

        if (!request.email().equals(user.getEmail())) {
            if (userRepository.findByEmail(request.email()).isPresent()) {
                throw new EmailAlreadyRegisteredException();
            }

            user.setEmail(request.email());
        }

        User updatedUser = userRepository.save(user);
        return prepareUserResponse(updatedUser);
    }

    @Transactional
    public void deleteCurrentUser(String userIdHeader) {
        Long currentUserId = fakeAuthService
                .getCurrentUserId(userIdHeader);

        User user = userRepository.findById(currentUserId)
                .orElseThrow(UserNotFoundException::new);

        habitRepository.deleteAllByUserId(currentUserId);
        userRepository.delete(user);
    }

    private UserResponse prepareUserResponse(User user) {
        return new UserResponse(user.getId(), user.getEmail());
    }
}
