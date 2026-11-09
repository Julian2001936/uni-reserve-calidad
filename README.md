# UNIreserve - Sistema de Gestión y Reserva de Espacios Académicos

## 1. Descripción del Proyecto
UNIreserve es una solución de software orientada a la gestión eficiente y prevención de conflictos en la reserva de laboratorios y espacios académicos.

## 2. Integrantes y Roles
- **Julian Garcia** (`@Julian2001936`) - Desarrollador Principal y Líder de Calidad.

## 3. Requisitos Funcionales y No Funcionales
Consulta la matriz detallada en [docs/requisitos.md](docs/requisitos.md).

## 4. Arquitectura y Tecnologías
- Arquitectura por capas (Frontend Mobile / Backend REST API / BD).
- Node.js, Express, Flutter/Dart, SQLite, Docker.

## 5. Instrucciones de Pruebas y Métricas
- Medición de Métricas: `node metricas/analyzer.js`

## 6. Métricas Aplicadas y Refactorización
- **LOC / ELOC / CLOC** y **Complejidad Ciclomática V(G)**.
- Refactorización en `ReservationValidator.checkOverlap()`: V(G) reducido de 13 a 4.

## 7. Licencia y Estado
Licencia MIT. Versión de entrega `v1.0.0`.
