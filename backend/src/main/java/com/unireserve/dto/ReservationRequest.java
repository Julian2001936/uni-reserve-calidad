package com.unireserve.dto;
import jakarta.validation.constraints.*;
import java.time.LocalDate;
import java.time.LocalTime;
public record ReservationRequest(
    @NotNull Long spaceId,
    @NotNull LocalDate date,
    @NotNull LocalTime time
) {}
