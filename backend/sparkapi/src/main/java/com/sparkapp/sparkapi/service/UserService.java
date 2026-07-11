package com.sparkapp.sparkapi.service;

import org.springframework.stereotype.Service;

import com.sparkapp.sparkapi.dto.UserResponse;
import com.sparkapp.sparkapi.model.User;
import com.sparkapp.sparkapi.repository.UserRepository;

@Service
public class UserService {

    private final UserRepository userRepository;
    private final FakeAuthService fakeAuthService;

    public UserService(UserRepository userRepository, FakeAuthService fakeAuthService) {
        this.userRepository = userRepository;
        this.fakeAuthService = fakeAuthService;
    }

    public UserResponse getCurrentUser(String userIdHeader) {
        Long currentUserId = fakeAuthService.getCurrentUserId(userIdHeader);
        User user = userRepository.findById(currentUserId)
                .orElseThrow();
        return new UserResponse(user.getId().toString(), user.getEmail());

    }
}
