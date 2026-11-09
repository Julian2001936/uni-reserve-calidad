package com.unireserve.service;

import com.unireserve.dto.ReservationRequest;
import com.unireserve.model.*;
import com.unireserve.repository.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.*;
import java.util.*;

@Service
public class ReservationService {
    private final ReservationRepository reservations;
    private final SpaceRepository spaces;

    public ReservationService(ReservationRepository reservations, SpaceRepository spaces){
        this.reservations=reservations; this.spaces=spaces;
    }

    public List<Space> available(LocalDate date, LocalTime time){
        Set<Long> occupied=new HashSet<>(reservations.findOccupiedSpaceIds(date,time,ReservationStatus.ACTIVE));
        return spaces.findByActiveTrueOrderByNameAsc().stream()
                .filter(s->!occupied.contains(s.getId())).toList();
    }

    @Transactional
    public Reservation reserve(User user, ReservationRequest r){
        Space space=spaces.findById(r.spaceId())
                .orElseThrow(()->new IllegalArgumentException("El espacio no existe."));
        if(!space.getActive()) throw new IllegalArgumentException("El espacio no está activo.");
        if(r.date().isBefore(LocalDate.now()))
            throw new IllegalArgumentException("La fecha no puede ser anterior a hoy.");
        if(reservations.existsBySpaceIdAndDateAndTimeAndStatus(
                space.getId(),r.date(),r.time(),ReservationStatus.ACTIVE))
            throw new IllegalArgumentException("El espacio ya está ocupado en ese horario.");
        return reservations.save(new Reservation(user,space,r.date(),r.time()));
    }

    public List<Reservation> mine(User user){
        return reservations.findByUserIdOrderByDateAscTimeAsc(user.getId());
    }

    @Transactional
    public void cancel(User user, Long id){
        Reservation r=reservations.findById(id)
                .orElseThrow(()->new IllegalArgumentException("La reserva no existe."));
        if(!r.getUser().getId().equals(user.getId()))
            throw new IllegalArgumentException("No puedes cancelar una reserva de otro usuario.");
        if(r.getStatus()==ReservationStatus.CANCELLED)
            throw new IllegalArgumentException("La reserva ya está cancelada.");
        r.setStatus(ReservationStatus.CANCELLED);
        reservations.save(r);
    }
}
