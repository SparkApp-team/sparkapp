package com.sparkapp.sparkapi.service;

import org.springframework.stereotype.Service;

@Service
public class FakeAuthService {
    public Long getCurrentUserId(String userIdHeader) {
        return Long.valueOf(userIdHeader);
    }
}
