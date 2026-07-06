package com.sparkapp.sparkapi.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.sparkapp.sparkapi.dto.CreateUserRequest;
import com.sparkapp.sparkapi.dto.UserResponse;
import com.sparkapp.sparkapi.model.User;
import com.sparkapp.sparkapi.repository.UserRepository;
import com.sparkapp.sparkapi.service.FakeAuthService;
import com.sparkapp.sparkapi.service.FakeHashService;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@RestController
@RequestMapping("/users")
public class UserController {

    private final UserRepository userRepository;
    private final FakeAuthService fakeAuthService;
    private final FakeHashService fakeHashService;

    public UserController(UserRepository userRepository, FakeAuthService fakeAuthService, FakeHashService fakeHashService) {
        this.userRepository = userRepository;
        this.fakeAuthService = fakeAuthService;
        this.fakeHashService = fakeHashService;
    }

    @PostMapping()
    public UserResponse createUser(@RequestHeader("X-USER-ID") String userIdHeader,
                                    @RequestBody CreateUserRequest createUserRequest) {
        User user = new User();
        user.setEmail(createUserRequest.email());
        user.setPasswordHash(fakeHashService.hashPassword(createUserRequest.password()));
        User savedUser = userRepository.save(user);



        Long currentUserId = fakeAuthService.getCurrentUserId(userIdHeader);
        
        return new UserResponse(savedUser.getId(), savedUser.getEmail());
    }

    @GetMapping("/me")
    public UserResponse getCurrentUser(@RequestHeader("X-USER-ID") String userIdHeader) {
        Long currentUserId = fakeAuthService.getCurrentUserId(userIdHeader);

        User user = userRepository.findById(currentUserId)
                .orElseThrow();

        return new UserResponse(user.getId(), user.getEmail());

    }

}
