package com.sparkapp.sparkapi.service;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Test;

class FakeHashServiceTest {

    private final FakeHashService fakeHashService = new FakeHashService();

    @Test
    void hashPasswordReversesPassword() {
        assertEquals("321drowssap", fakeHashService.hashPassword("password123"));
    }

    @Test
    void hashPasswordReturnsEmptyStringForEmptyPassword() {
        assertEquals("", fakeHashService.hashPassword(""));
    }
}