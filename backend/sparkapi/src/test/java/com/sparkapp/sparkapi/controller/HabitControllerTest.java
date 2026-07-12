package com.sparkapp.sparkapi.controller;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
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
import com.sparkapp.sparkapi.exception.HabitNotFoundException;
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
            .andExpect(status().isCreated())
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

    @Test
    void getHabitByIdReturnsCurrentUsersHabit() throws Exception {
        when(habitService.getHabitById("7", 1L))
            .thenReturn(new HabitResponse(1L, 7L, "Read", "daily"));

        mockMvc.perform(get("/habits/1").header("X-USER-ID", "7"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.id").value(1))
            .andExpect(jsonPath("$.userId").value(7))
            .andExpect(jsonPath("$.name").value("Read"))
            .andExpect(jsonPath("$.frequency").value("daily"));

        verify(habitService).getHabitById("7", 1L);
    }

    @Test
    void getHabitByIdReturnsNotFoundWhenHabitIsUnavailableToUser() throws Exception {
        when(habitService.getHabitById("7", 1L))
            .thenThrow(new HabitNotFoundException());

        mockMvc.perform(get("/habits/1").header("X-USER-ID", "7"))
            .andExpect(status().isNotFound())
            .andExpect(jsonPath("$.message").value("Habit not found"))
            .andExpect(jsonPath("$.path").value("/habits/1"));
    }

    @Test
    void updateHabitReturnsUpdatedHabit() throws Exception {
        when(habitService.updateHabit(eq("7"), eq(1L), any()))
            .thenReturn(new HabitResponse(1L, 7L, "Exercise", "weekly"));

        mockMvc.perform(put("/habits/1")
                .header("X-USER-ID", "7")
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                    {
                      "name": "Exercise",
                      "frequency": "weekly"
                    }
                    """))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.id").value(1))
            .andExpect(jsonPath("$.userId").value(7))
            .andExpect(jsonPath("$.name").value("Exercise"))
            .andExpect(jsonPath("$.frequency").value("weekly"));

        verify(habitService).updateHabit(eq("7"), eq(1L), any());
    }

    @Test
    void deleteHabitReturnsNoContent() throws Exception {
        mockMvc.perform(delete("/habits/1").header("X-USER-ID", "7"))
            .andExpect(status().isNoContent());

        verify(habitService).deleteHabit("7", 1L);
    }
}
