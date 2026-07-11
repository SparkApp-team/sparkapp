package com.sparkapp.sparkapi.service;

import java.util.Optional;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import com.sparkapp.sparkapi.dto.LoginUserRequest;
import com.sparkapp.sparkapi.dto.RegisterUserRequest;
import com.sparkapp.sparkapi.dto.UserResponse;
import com.sparkapp.sparkapi.repository.UserRepository;
import com.sparkapp.sparkapi.model.User;

@Service
public class AuthService {
    private final FakeHashService fakeHashService;
    private final UserRepository userRepository;
    private final FakeAuthService fakeAuthService;
    public AuthService(FakeHashService fakeHashService, UserRepository userRepository, FakeAuthService fakeAuthService){
        this.fakeHashService = fakeHashService;
        this.userRepository = userRepository;
        this.fakeAuthService = fakeAuthService;
    }

    public UserResponse registerUser(RegisterUserRequest request) {
        if (request.email() == null || request.email().isBlank()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Email is required");
        }

        if (request.password() == null || request.password().isBlank()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Password is required");
        }

        if (request.password().length() < 8) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Password must be at least 8 characters");
        }

        Optional<User> userOptional = userRepository.findByEmail(request.email());
        if (!userOptional.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Email is already registered");
        }

        User user = new User();
        user.setEmail(request.email());
        user.setPasswordHash(fakeHashService.hashPassword(request.password()));

        User savedUser = userRepository.save(user);

        return new UserResponse(
                fakeAuthService.getCurrentUserToken(savedUser.getId()),
                savedUser.getEmail());
    }


    public UserResponse loginUser(LoginUserRequest request){
        if (request.email() == null || request.email().isBlank()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Email is required");
        }

        if (request.password() == null || request.password().isBlank()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Password is required");
        }

        Optional<User> userOptional = userRepository.findByEmail(request.email());

        if (userOptional.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid email or password");
        }

        User user = userOptional.get();
        String passwordHash = fakeHashService.hashPassword(request.password());

        if (!user.getPasswordHash().equals(passwordHash)) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid email or password");
        }

        return new UserResponse(
                fakeAuthService.getCurrentUserToken(user.getId()),
                user.getEmail());
    }
}
