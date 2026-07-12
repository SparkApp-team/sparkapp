package com.sparkapp.sparkapi.controller;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.util.List;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.webmvc.test.autoconfigure.WebMvcTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

import com.sparkapp.sparkapi.dto.HabitResponse;
import com.sparkapp.sparkapi.service.HabitService;

@WebMvcTest(HabitController.class)
class HabitControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockitoBean
    private HabitService habitService;

    @Test
    void createHabitReturnsCreatedHabit() throws Exception {
        when(habitService.createHabit(eq("7"), any()))
            .thenReturn(new HabitResponse(1L, 7L, "Read", "daily"));

        mockMvc.perform(post("/habits")
                .header("X-USER-ID", "7")
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                    {
                      "name": "Read",
                      "frequency": "daily"
                    }
                    """))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.id").value(1))
            .andExpect(jsonPath("$.userId").value(7))
            .andExpect(jsonPath("$.name").value("Read"))
            .andExpect(jsonPath("$.frequency").value("daily"));

        verify(habitService).createHabit(eq("7"), any());
    }

    @Test
    void getHabitListReturnsCurrentUsersHabits() throws Exception {
        when(habitService.getHabitList("7")).thenReturn(List.of(
            new HabitResponse(1L, 7L, "Read", "daily"),
            new HabitResponse(2L, 7L, "Exercise", "weekly")
        ));

        mockMvc.perform(get("/habits").header("X-USER-ID", "7"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$[0].name").value("Read"))
            .andExpect(jsonPath("$[1].name").value("Exercise"));

        verify(habitService).getHabitList("7");
    }
}