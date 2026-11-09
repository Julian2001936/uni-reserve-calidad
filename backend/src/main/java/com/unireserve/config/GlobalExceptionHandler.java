package com.unireserve.config;

import org.springframework.http.*;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.*;
import java.util.Map;

@RestControllerAdvice
public class GlobalExceptionHandler {
    @ExceptionHandler(IllegalArgumentException.class)
    ResponseEntity<Map<String,String>> illegal(IllegalArgumentException e){
        return ResponseEntity.badRequest().body(Map.of("message",e.getMessage()));
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    ResponseEntity<Map<String,String>> validation(MethodArgumentNotValidException e){
        return ResponseEntity.badRequest().body(Map.of("message","Datos de entrada inválidos."));
    }
}
