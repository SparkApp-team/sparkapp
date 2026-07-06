package com.sparkapp.sparkapi.service;

import org.springframework.stereotype.Service;

@Service
public class FakeAuthService {
    public String getCurrentUserId(String userIdHeader) {
        return userIdHeader;
    }
}
