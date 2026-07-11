package com.sparkapp.sparkapi.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.sparkapp.sparkapi.dto.UserResponse;
import com.sparkapp.sparkapi.service.UserService;

import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.GetMapping;


@RestController
@RequestMapping("/users")
public class UserController {

    private final UserService userService;

    public UserController(UserService userService){
        this.userService = userService;
    }



    @GetMapping("/me")
    public UserResponse getCurrentUser(@RequestHeader("X-USER-ID") String userIdHeader) {
        return userService.getCurrentUser(userIdHeader);

    }

}
