package com.mackbike.app.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.mackbike.app.service.RouteService;
import com.mackbike.app.model.RouteDTO;

@RestController
public class RouteController {
    private final RouteService routeService;

    public RouteController(RouteService routeService){
        this.routeService = routeService;
    }

    @GetMapping("/route")
    public ResponseEntity<RouteDTO> getRoute(@RequestParam String from, @RequestParam String to) {
        RouteDTO route = routeService.getRoute(from, to);
        return ResponseEntity.ok(route);
    }
}
