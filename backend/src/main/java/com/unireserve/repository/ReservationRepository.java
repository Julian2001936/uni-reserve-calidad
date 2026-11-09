package com.unireserve.repository;
import com.unireserve.model.*;
import org.springframework.data.jpa.repository.*;
import org.springframework.data.repository.query.Param;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

public interface ReservationRepository extends JpaRepository<Reservation,Long> {
    List<Reservation> findByUserIdOrderByDateAscTimeAsc(Long userId);
    boolean existsBySpaceIdAndDateAndTimeAndStatus(Long spaceId, LocalDate date, LocalTime time, ReservationStatus status);

    @Query("select r.space.id from Reservation r where r.date=:date and r.time=:time and r.status=:status")
    List<Long> findOccupiedSpaceIds(@Param("date") LocalDate date, @Param("time") LocalTime time,
                                    @Param("status") ReservationStatus status);
}
