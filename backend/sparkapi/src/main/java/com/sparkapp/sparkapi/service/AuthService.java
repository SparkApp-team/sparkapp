package com.sparkapp.sparkapi.service;

import java.util.Optional;

import org.springframework.stereotype.Service;

import com.sparkapp.sparkapi.dto.LoginUserRequest;
import com.sparkapp.sparkapi.dto.RegisterUserRequest;
import com.sparkapp.sparkapi.dto.UserResponse;
import com.sparkapp.sparkapi.exception.EmailAlreadyRegisteredException;
import com.sparkapp.sparkapi.exception.InvalidCredentialsException;
import com.sparkapp.sparkapi.exception.PasswordDoNotMatchException;
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
        if (!request.password().equals(request.passwordConfirmation())) {
            throw new PasswordDoNotMatchException();
        }

        Optional<User> userOptional = userRepository.findByEmail(request.email());
        if (!userOptional.isEmpty()) {
            throw new EmailAlreadyRegisteredException();
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

        Optional<User> userOptional = userRepository.findByEmail(request.email());

        if (userOptional.isEmpty()) {
            throw new InvalidCredentialsException();
        }

        User user = userOptional.get();
        String passwordHash = fakeHashService.hashPassword(request.password());

        if (!user.getPasswordHash().equals(passwordHash)) {
            throw new InvalidCredentialsException();
        }

        return new UserResponse(
                fakeAuthService.getCurrentUserToken(user.getId()),
                user.getEmail());
    }
}
