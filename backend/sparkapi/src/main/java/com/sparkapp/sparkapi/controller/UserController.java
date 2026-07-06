package com.sparkapp.sparkapi.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.sparkapp.sparkapi.dto.RegisterUserRequest;
import com.sparkapp.sparkapi.dto.UserResponse;
import com.sparkapp.sparkapi.model.User;
import com.sparkapp.sparkapi.repository.UserRepository;
import com.sparkapp.sparkapi.service.FakeAuthService;
import com.sparkapp.sparkapi.service.FakeHashService;

import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.GetMapping;


@RestController
@RequestMapping("/users")
public class UserController {
    private final UserRepository userRepository;
    private final FakeAuthService fakeAuthService;

    public UserController(UserRepository userRepository, FakeAuthService fakeAuthService) {
        this.userRepository = userRepository;
        this.fakeAuthService = fakeAuthService;
    }



    @GetMapping("/me")
    public UserResponse getCurrentUser(@RequestHeader("X-USER-ID") String userIdHeader) {
        Long currentUserId = fakeAuthService.getCurrentUserId(userIdHeader);
        User user = userRepository.findById(currentUserId)
                .orElseThrow();
        return new UserResponse(user.getId().toString(), user.getEmail());

    }

}
