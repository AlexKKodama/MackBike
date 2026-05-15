package com.mackbike.app.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;
import com.mackbike.app.model.RouteDTO;

@Service
public class RouteService {

    private final RestTemplate restTemplate;
    private final String apiKey;
    private final String baseUrl = "https://graphhopper.com/api/1/route";

    public RouteService(RestTemplateBuilder restTemplateBuilder, @Value("${external.api.key}") String apiKey) {
        this.restTemplate = restTemplateBuilder.build();
        this.apiKey = apiKey;
    }

    public RouteDTO getRoute(String from, String to) {
        String url = UriComponentsBuilder.fromUriString(baseUrl)
                .queryParam("point", from)
                .queryParam("point", to)
                .queryParam("profile", "bike")
                .queryParam("locale", "pt_BR")
                .queryParam("points_encoded", "false")
                .queryParam("key", apiKey)
                .toUriString();

        return restTemplate.getForObject(url, RouteDTO.class);
    }
}
