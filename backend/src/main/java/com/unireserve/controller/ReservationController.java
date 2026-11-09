package com.unireserve.controller;

import com.unireserve.dto.ReservationRequest;
import com.unireserve.model.*;
import com.unireserve.service.ReservationService;
import jakarta.validation.Valid;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/reservations")
public class ReservationController {
    private final ReservationService service;
    public ReservationController(ReservationService service){this.service=service;}

    @GetMapping("/mine")
    public List<Reservation> mine(@AuthenticationPrincipal User user){return service.mine(user);}

    @PostMapping
    public Reservation create(@AuthenticationPrincipal User user,@Valid @RequestBody ReservationRequest request){
        return service.reserve(user,request);
    }

    @DeleteMapping("/{id}")
    public void cancel(@AuthenticationPrincipal User user,@PathVariable Long id){
        service.cancel(user,id);
    }
}
