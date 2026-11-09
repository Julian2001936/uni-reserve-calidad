package com.unireserve.model;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalTime;

@Entity
@Table(name="reservations",
       uniqueConstraints=@UniqueConstraint(columnNames={"space_id","date","time","status"}))
public class Reservation {
    @Id @GeneratedValue(strategy=GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(optional=false) @JoinColumn(name="user_id")
    private User user;

    @ManyToOne(optional=false) @JoinColumn(name="space_id")
    private Space space;

    @Column(nullable=false) private LocalDate date;
    @Column(nullable=false) private LocalTime time;

    @Enumerated(EnumType.STRING)
    @Column(nullable=false) private ReservationStatus status = ReservationStatus.ACTIVE;

    public Reservation(){}
    public Reservation(User user, Space space, LocalDate date, LocalTime time){
        this.user=user; this.space=space; this.date=date; this.time=time;
    }
    public Long getId(){return id;}
    public User getUser(){return user;}
    public Space getSpace(){return space;}
    public LocalDate getDate(){return date;}
    public LocalTime getTime(){return time;}
    public ReservationStatus getStatus(){return status;}
    public void setStatus(ReservationStatus status){this.status=status;}
}
