package com.unireserve.controller;

import com.unireserve.model.Space;
import com.unireserve.service.ReservationService;
import com.unireserve.repository.SpaceRepository;
import org.springframework.web.bind.annotation.*;
import java.time.*;
import java.util.*;

@RestController
@RequestMapping("/api/spaces")
public class SpaceController {
    private final SpaceRepository spaces;
    private final ReservationService reservations;

    public SpaceController(SpaceRepository spaces, ReservationService reservations){
        this.spaces=spaces; this.reservations=reservations;
    }

    @GetMapping
    public List<Space> all(){return spaces.findByActiveTrueOrderByNameAsc();}

    @GetMapping("/available")
    public List<Space> available(@RequestParam LocalDate date,@RequestParam LocalTime time){
        return reservations.available(date,time);
    }

    @GetMapping("/{id}")
    public Space one(@PathVariable Long id){
        return spaces.findById(id).orElseThrow(()->new IllegalArgumentException("Espacio no encontrado."));
    }
}
