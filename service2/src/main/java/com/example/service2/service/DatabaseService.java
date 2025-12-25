package com.example.service2.service;

import com.example.service2.entity.DataEntity;
import com.example.service2.repository.DataRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class DatabaseService {

    @Autowired
    private DataRepository dataRepository;

    public DataEntity getDataById(Long id) {
        return dataRepository.findById(id).orElse(null);
    }

    public List<Map<String, Object>> getAllData() {
//        return dataRepository.findAll().stream()
//                .map(entity -> Map.of(
//                        "id", entity.getId(),
//                        "name", entity.getName(),
//                        "description", entity.getDescription(),
//                        "value", entity.getValue()
//                ))
//                .collect(Collectors.toList());

        return dataRepository.findAll().stream()
                .map(entity -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("id", entity.getId());
                    map.put("name", entity.getName());
                    map.put("description", entity.getDescription());
                    map.put("value", entity.getValue());
                    return map;
                })
                .collect(Collectors.toList());
    }
}

