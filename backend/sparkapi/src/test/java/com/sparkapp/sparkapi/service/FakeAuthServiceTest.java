package com.sparkapp.sparkapi.service;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Test;

class FakeAuthServiceTest {

    private final FakeAuthService fakeAuthService = new FakeAuthService();

    @Test
    void getCurrentUserIdConvertsHeaderToLong() {
        assertEquals(42L, fakeAuthService.getCurrentUserId("42"));
    }

    @Test
    void getCurrentUserTokenConvertsUserIdToString() {
        assertEquals("42", fakeAuthService.getCurrentUserToken(42L));
    }
}