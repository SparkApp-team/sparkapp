package com.sparkapp.sparkapi.service;

import org.springframework.stereotype.Service;

@Service
public class FakeHashService {
    public String hashPassword(String password) {
        return new StringBuilder(password).reverse().toString();
    }

    
}
