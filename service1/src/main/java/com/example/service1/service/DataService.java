package com.example.service1.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

import java.util.Map;

@Service
public class DataService {

    private final WebClient webClient;

    public DataService(@Value("${service2.url:http://service2:8081}") String service2Url) {
        this.webClient = WebClient.builder()
                .baseUrl(service2Url)
                .build();
    }

    public Map<String, Object> getDataFromService2(Long id) {
        return webClient.get()
                .uri("/api/db/data/{id}", id)
                .retrieve()
                .bodyToMono(Map.class)
                .block();
    }

    public Map<String, Object> getAllDataFromService2() {
        return webClient.get()
                .uri("/api/db/data/all")
                .retrieve()
                .bodyToMono(Map.class)
                .block();
    }
}

