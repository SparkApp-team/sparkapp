package com.sparkapp.sparkapi.controller;

import java.util.List;
import java.util.Optional;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import com.sparkapp.sparkapi.dto.LoginUserRequest;
import com.sparkapp.sparkapi.dto.RegisterUserRequest;
import com.sparkapp.sparkapi.dto.UserResponse;
import com.sparkapp.sparkapi.model.User;
import com.sparkapp.sparkapi.repository.UserRepository;
import com.sparkapp.sparkapi.service.FakeAuthService;
import com.sparkapp.sparkapi.service.FakeHashService;

@RestController
@RequestMapping("/auth")
public class AuthController {
    private final UserRepository userRepository;
    private final FakeAuthService fakeAuthService;
    private final FakeHashService fakeHashService;

    public AuthController(UserRepository userRepository, FakeAuthService fakeAuthService, FakeHashService fakeHashService) {
        this.userRepository = userRepository;
        this.fakeAuthService = fakeAuthService;
        this.fakeHashService = fakeHashService;
    }

    @PostMapping("/register")
    public UserResponse register(@RequestBody RegisterUserRequest registerUserRequest) {
        if (registerUserRequest.email() == null || registerUserRequest.email().isBlank()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Email is required");
        }

        if (registerUserRequest.password() == null || registerUserRequest.password().isBlank()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Password is required");
        }

        if (registerUserRequest.password().length() < 8) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Password must be at least 8 characters");
        }

        Optional<User> userOptional = userRepository.findByEmail(registerUserRequest.email());
        if (!userOptional.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Email is already registered");
        }

        User user = new User();
        user.setEmail(registerUserRequest.email());
        user.setPasswordHash(fakeHashService.hashPassword(registerUserRequest.password()));

        User savedUser = userRepository.save(user);

        return new UserResponse(
                fakeAuthService.getCurrentUserToken(savedUser.getId()),
                savedUser.getEmail());
    }
    @PostMapping("/login")
    public UserResponse login(@RequestBody LoginUserRequest loginUserRequest) {
        if (loginUserRequest.email() == null || loginUserRequest.email().isBlank()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Email is required");
        }

        if (loginUserRequest.password() == null || loginUserRequest.password().isBlank()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Password is required");
        }

        Optional<User> userOptional = userRepository.findByEmail(loginUserRequest.email());

        if (userOptional.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid email or password");
        }

        User user = userOptional.get();
        String passwordHash = fakeHashService.hashPassword(loginUserRequest.password());

        if (!user.getPasswordHash().equals(passwordHash)) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid email or password");
        }

        return new UserResponse(
                fakeAuthService.getCurrentUserToken(user.getId()),
                user.getEmail());
    }
    
}
