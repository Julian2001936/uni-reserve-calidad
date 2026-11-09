# Anexo A: Plantilla de Requisitos - UNIreserve

## A.1 Requisitos Funcionales
| ID | Descripción | Criterio de Aceptación | Componente |
| :--- | :--- | :--- | :--- |
| **RF-01** | Registro de usuarios. | Registro en BD con contraseña cifrada. | AuthService / UserController |
| **RF-02** | Autenticación JWT. | Token JWT válido por 8 horas. | AuthMiddleware / LoginScreen |
| **RF-03** | Catálogo de espacios. | Lista laboratorios filtrados por capacidad. | SpaceService / CatalogView |
| **RF-04** | Solicitud de reserva. | Registra reserva con usuario, fecha y hora. | ReservationService |
| **RF-05** | Validación de solapamiento. | Rechaza solicitudes en horarios ocupados. | ReservationValidator |
| **RF-06** | Cancelación de reserva. | Cambia estado a cancelado y libera cupo. | ReservationService |
| **RF-07** | Historial de reservas. | Consulta reservas pasadas y activas. | UserReservationsView |
| **RF-08** | Control de roles y permisos. | Admins gestionan; usuarios reservan. | RoleGuard / AuthMiddleware |
| **RF-09** | Persistencia local y caché. | Guarda estado en caché ante fallos. | LocalStorageProvider |
| **RF-10** | Reporte de uso de espacios. | Métricas de ocupación y horas pico. | ReportController |

## A.2 Requisitos No Funcionales
| ID | Categoría | Descripción Medible | Forma de Verificación |
| :--- | :--- | :--- | :--- |
| **RNF-01** | Rendimiento | Consultas responden en <= 500 ms (95% casos). | Prueba Postman / Newman |
| **RNF-02** | Seguridad | Bcrypt para claves y JWT en endpoints. | Inspección de código / HTTP 401 |
| **RNF-03** | Mantenibilidad | Ningún método supera V(G) > 10. | metricas/analyzer.js |
