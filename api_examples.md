# Ejemplos de API

## Registrar usuario

```http
POST /api/auth/register
Content-Type: application/json

{
  "fullName": "Julian Garcia",
  "email": "julian@example.com",
  "password": "123456",
  "role": "STUDENT"
}
```

## Login

```http
POST /api/auth/login
Content-Type: application/json

{
  "email": "estudiante@unireserve.com",
  "password": "123456"
}
```

## Consultar disponibilidad

```http
GET /api/spaces/available?date=2026-09-01&time=08:00:00
Authorization: Bearer TOKEN
```

## Crear reserva

```http
POST /api/reservations
Authorization: Bearer TOKEN
Content-Type: application/json

{
  "spaceId": 1,
  "date": "2026-09-01",
  "time": "08:00:00"
}
```

## Mis reservas

```http
GET /api/reservations/mine
Authorization: Bearer TOKEN
```

## Cancelar

```http
DELETE /api/reservations/1
Authorization: Bearer TOKEN
```
