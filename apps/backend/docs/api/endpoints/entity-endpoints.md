# Entity Endpoints

This document describes the entity management API endpoints.

## 🔗 Base URL

```
Development: http://localhost:3000
Production: https://api.yourdomain.com
```

## 🔐 Authentication

All endpoints require authentication via JWT token:

```http
Authorization: Bearer <jwt-token>
```

### Tenant Context
All endpoints require tenant context via one of:

```http
# Header-based
x-tenant-slug: acme-corp

# Path-based
/api/v1/tenants/acme-corp/entities

# Query-based
/api/v1/entities?tenantSlug=acme-corp
```

## 📊 Common Response Formats

### Success Response
```json
{
  "data": {
    "id": "entity-123",
    "name": "Entity Name",
    "tenantId": "tenant-456",
    "createdAt": "2023-01-01T00:00:00.000Z",
    "updatedAt": "2023-01-01T00:00:00.000Z"
  },
  "message": "Success",
  "statusCode": 200
}
```

### Error Response
```json
{
  "statusCode": 400,
  "message": "Validation failed",
  "error": "Bad Request",
  "details": {
    "field": "name",
    "constraint": "isNotEmpty"
  },
  "timestamp": "2023-01-01T00:00:00.000Z",
  "path": "/api/v1/entities"
}
```

### Paginated Response
```json
{
  "data": [
    {
      "id": "entity-1",
      "name": "Entity 1"
    },
    {
      "id": "entity-2", 
      "name": "Entity 2"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 10,
    "total": 25,
    "totalPages": 3
  },
  "statusCode": 200
}
```

## 🏢 Entity Management

### Get All Entities
```http
GET /api/v1/entities
```

**Headers:**
```http
Authorization: Bearer <token>
x-tenant-slug: acme-corp
```

**Query Parameters:**
- `page` (optional): Page number (default: 1)
- `limit` (optional): Items per page (default: 10)
- `search` (optional): Search term
- `sortBy` (optional): Sort field (default: createdAt)
- `sortOrder` (optional): Sort direction (asc/desc, default: desc)

**Response:**
```json
{
  "data": [
    {
      "id": "entity-123",
      "name": "Entity Name",
      "description": "Entity description",
      "tenantId": "tenant-456",
      "createdAt": "2023-01-01T00:00:00.000Z",
      "updatedAt": "2023-01-01T00:00:00.000Z"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 10,
    "total": 1,
    "totalPages": 1
  }
}
```

### Get Entity by ID
```http
GET /api/v1/entities/{id}
```

**Headers:**
```http
Authorization: Bearer <token>
x-tenant-slug: acme-corp
```

**Path Parameters:**
- `id`: Entity UUID

**Response:**
```json
{
  "data": {
    "id": "entity-123",
    "name": "Entity Name",
    "description": "Entity description",
    "tenantId": "tenant-456",
    "createdAt": "2023-01-01T00:00:00.000Z",
    "updatedAt": "2023-01-01T00:00:00.000Z"
  }
}
```

### Create Entity
```http
POST /api/v1/entities
```

**Headers:**
```http
Authorization: Bearer <token>
x-tenant-slug: acme-corp
Content-Type: application/json
```

**Request Body:**
```json
{
  "name": "New Entity",
  "description": "Entity description"
}
```

**Response:**
```json
{
  "data": {
    "id": "entity-123",
    "name": "New Entity",
    "description": "Entity description",
    "tenantId": "tenant-456",
    "createdAt": "2023-01-01T00:00:00.000Z",
    "updatedAt": "2023-01-01T00:00:00.000Z"
  },
  "message": "Entity created successfully"
}
```

### Update Entity
```http
PUT /api/v1/entities/{id}
```

**Headers:**
```http
Authorization: Bearer <token>
x-tenant-slug: acme-corp
Content-Type: application/json
```

**Path Parameters:**
- `id`: Entity UUID

**Request Body:**
```json
{
  "name": "Updated Entity",
  "description": "Updated description"
}
```

**Response:**
```json
{
  "data": {
    "id": "entity-123",
    "name": "Updated Entity",
    "description": "Updated description",
    "tenantId": "tenant-456",
    "createdAt": "2023-01-01T00:00:00.000Z",
    "updatedAt": "2023-01-01T12:00:00.000Z"
  },
  "message": "Entity updated successfully"
}
```

### Delete Entity
```http
DELETE /api/v1/entities/{id}
```

**Headers:**
```http
Authorization: Bearer <token>
x-tenant-slug: acme-corp
```

**Path Parameters:**
- `id`: Entity UUID

**Response:**
```json
{
  "message": "Entity deleted successfully"
}
```

## 🚨 Error Codes

### HTTP Status Codes
- `200` - OK
- `201` - Created
- `400` - Bad Request
- `401` - Unauthorized
- `403` - Forbidden
- `404` - Not Found
- `409` - Conflict
- `422` - Unprocessable Entity
- `500` - Internal Server Error

### Error Types
- `VALIDATION_ERROR` - Input validation failed
- `AUTHENTICATION_ERROR` - Authentication failed
- `AUTHORIZATION_ERROR` - Insufficient permissions
- `NOT_FOUND` - Resource not found
- `CONFLICT` - Resource conflict
- `TENANT_ERROR` - Tenant-related error
- `INTERNAL_ERROR` - Internal server error

## 📚 Related Documentation

### Backend Documentation
- [Error Handling](../error-handling.md) - Error handling details
- [Usage Examples](../usage-examples.md) - Usage examples
- [API Documentation](../) - Complete API documentation
- [Backend Setup](../../development/setup.md) - Backend setup guide
- [Testing Guide](../../testing/testing-guide.md) - Testing documentation

### Shared Documentation
- [Project Overview](../../../../README.md) - Main project documentation
- [Development Setup](../../../../docs/development/development-setup.md) - General development setup
- [Testing Strategy](../../../../docs/development/testing-strategy.md) - Project-wide testing approach
