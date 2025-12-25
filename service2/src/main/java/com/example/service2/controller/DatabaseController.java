package com.example.service2.controller;

import com.example.service2.entity.DataEntity;
import com.example.service2.service.DatabaseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/api/db")
public class DatabaseController {

    @Autowired
    private DatabaseService databaseService;

    @GetMapping("/data/{id}")
    public ResponseEntity<Map<String, Object>> getDataById(@PathVariable Long id) {
        try {
            DataEntity entity = databaseService.getDataById(id);
            if (entity == null) {
                return ResponseEntity.notFound().build();
            }
            return ResponseEntity.ok(Map.of(
                    "id", entity.getId(),
                    "name", entity.getName(),
                    "description", entity.getDescription(),
                    "value", entity.getValue()
            ));
        } catch (Exception e) {
            return ResponseEntity.internalServerError()
                    .body(Map.of("error", e.getMessage()));
        }
    }

    @GetMapping("/data/all")
    public ResponseEntity<Map<String, Object>> getAllData() {
        try {
            var data = databaseService.getAllData();
            return ResponseEntity.ok(Map.of("data", data, "count", data.size()));
        } catch (Exception e) {
            return ResponseEntity.internalServerError()
                    .body(Map.of("error", e.getMessage()));
        }
    }

    @GetMapping("/health")
    public ResponseEntity<Map<String, String>> health() {
        return ResponseEntity.ok(Map.of("status", "UP", "service", "service2"));
    }
}

