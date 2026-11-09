# Anexo C: Plantilla de Resultados - UNIreserve

## C.1 Resultados de Medición Inicial
| Elemento Medido (método, clase o módulo) | Métrica | Valor Obtenido | Umbral | Estado / Acción Propuesta |
| :--- | :--- | :--- | :--- | :--- |
| `ReservationValidator.checkOverlap()` | V(G) | 13 | <= 10 | **Moderado/Alto**: Aplicar *Extract Method* y Guard Clauses |
| `AuthService.register()` | V(G) | 3 | <= 10 | **Bajo**: Mantener implementación actual |
| `SpaceController.getSpaces()` | V(G) | 2 | <= 10 | **Bajo**: Mantener implementación actual |
| `ReservationService.create()` | LOC / ELOC | 28 / 22 | <= 50 | **Bajo**: Aceptable según estándar |
| `UserReservationsView` (Mobile) | V(G) | 4 | <= 10 | **Bajo**: Mantener arquitectura |

## C.2 Comparativa Pre y Post Refactorización
| Elemento Medido | Métrica | Valor Antes | Valor Después | Umbral | Resultado / Impacto |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `ReservationValidator.checkOverlap()` | V(G) | 13 | 4 | <= 10 | Reducción del 69.2% en la complejidad ciclomática. Preservación del 100% de pruebas unitarias. |
| `ReservationValidator.checkOverlap()` | ELOC | 42 | 16 | <= 50 | Disminución de líneas efectivas por división en métodos auxiliares. |
