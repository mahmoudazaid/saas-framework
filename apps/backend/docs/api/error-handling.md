# Error Handling

This document describes the error handling patterns and error codes used in the backend API.

## 🚨 Error Response Format

All API errors follow a consistent response format:

```json
{
  "statusCode": 400,
  "message": "Validation failed",
  "error": "Bad Request",
  "details": {
    "field": "name",
    "constraint": "isNotEmpty",
    "value": ""
  },
  "timestamp": "2023-01-01T00:00:00.000Z",
  "path": "/api/v1/entities",
  "correlationId": "req-123456"
}
```

## 📊 HTTP Status Codes

### Success Codes
- `200` - OK - Request successful
- `201` - Created - Resource created successfully
- `204` - No Content - Request successful, no content returned

### Client Error Codes
- `400` - Bad Request - Invalid request data
- `401` - Unauthorized - Authentication required
- `403` - Forbidden - Insufficient permissions
- `404` - Not Found - Resource not found
- `409` - Conflict - Resource conflict
- `422` - Unprocessable Entity - Validation failed
- `429` - Too Many Requests - Rate limit exceeded

### Server Error Codes
- `500` - Internal Server Error - Unexpected server error
- `502` - Bad Gateway - External service error
- `503` - Service Unavailable - Service temporarily unavailable
- `504` - Gateway Timeout - External service timeout

## 🔍 Error Types

### Validation Errors
Occur when request data doesn't meet validation requirements:

```json
{
  "statusCode": 422,
  "message": "Validation failed",
  "error": "Unprocessable Entity",
  "details": [
    {
      "field": "email",
      "constraint": "isEmail",
      "value": "invalid-email",
      "message": "email must be a valid email"
    },
    {
      "field": "name",
      "constraint": "isNotEmpty",
      "value": "",
      "message": "name should not be empty"
    }
  ]
}
```

### Authentication Errors
Occur when authentication fails:

```json
{
  "statusCode": 401,
  "message": "Unauthorized",
  "error": "Authentication failed",
  "details": {
    "code": "INVALID_TOKEN",
    "message": "JWT token is invalid or expired"
  }
}
```

### Authorization Errors
Occur when user lacks required permissions:

```json
{
  "statusCode": 403,
  "message": "Forbidden",
  "error": "Insufficient permissions",
  "details": {
    "code": "INSUFFICIENT_PERMISSIONS",
    "required": "admin",
    "current": "user"
  }
}
```

### Not Found Errors
Occur when requested resource doesn't exist:

```json
{
  "statusCode": 404,
  "message": "Not Found",
  "error": "Resource not found",
  "details": {
    "code": "ENTITY_NOT_FOUND",
    "resource": "Entity",
    "id": "entity-123"
  }
}
```

### Conflict Errors
Occur when resource conflicts with existing data:

```json
{
  "statusCode": 409,
  "message": "Conflict",
  "error": "Resource conflict",
  "details": {
    "code": "DUPLICATE_EMAIL",
    "field": "email",
    "value": "user@example.com"
  }
}
```

### Tenant Errors
Occur when tenant context is invalid:

```json
{
  "statusCode": 403,
  "message": "Forbidden",
  "error": "Tenant access denied",
  "details": {
    "code": "TENANT_NOT_FOUND",
    "tenantSlug": "invalid-tenant"
  }
}
```

### Rate Limit Errors
Occur when rate limits are exceeded:

```json
{
  "statusCode": 429,
  "message": "Too Many Requests",
  "error": "Rate limit exceeded",
  "details": {
    "code": "RATE_LIMIT_EXCEEDED",
    "limit": 100,
    "window": "15 minutes",
    "retryAfter": 900
  }
}
```

### Internal Server Errors
Occur when unexpected server errors happen:

```json
{
  "statusCode": 500,
  "message": "Internal Server Error",
  "error": "An unexpected error occurred",
  "details": {
    "code": "INTERNAL_ERROR",
    "correlationId": "req-123456"
  }
}
```

## 🔧 Error Handling Implementation

### Global Exception Filter
The backend uses a global exception filter to handle all errors:

```typescript
@Catch()
export class GlobalExceptionFilter implements ExceptionFilter {
  catch(exception: unknown, host: ArgumentsHost): void {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();
    const request = ctx.getRequest<Request>();

    let status: HttpStatus;
    let message: string | string[];
    let details: unknown = undefined;

    if (exception instanceof HttpException) {
      status = exception.getStatus();
      const exceptionResponse = exception.getResponse();
      // Handle different exception types
    } else if (exception instanceof BusinessException) {
      status = HttpStatus.BAD_REQUEST;
      message = exception.message;
      details = exception.details;
    } else if (exception instanceof Error) {
      status = HttpStatus.INTERNAL_SERVER_ERROR;
      message = 'Internal server error';
      details = {
        name: exception.name,
        message: exception.message,
      };
    }

    const errorResponse = new ErrorResponseDto(
      status,
      message,
      request.url,
      request.correlationId,
    );

    response.status(status).json(errorResponse);
  }
}
```

### Custom Business Exceptions
Create custom exceptions for business logic errors:

```typescript
export class BusinessException extends Error {
  constructor(
    public message: string,
    public details?: unknown,
  ) {
    super(message);
    this.name = 'BusinessException';
  }
}

// Usage
throw new BusinessException('Entity not found', {
  code: 'ENTITY_NOT_FOUND',
  entityId: 'entity-123'
});
```

### Validation Error Handling
Handle validation errors with detailed field information:

```typescript
@Post()
async create(@Body() dto: CreateEntityDto): Promise<Entity> {
  try {
    return await this.entityService.create(dto);
  } catch (error) {
    if (error instanceof ValidationError) {
      throw new BadRequestException('Validation failed', {
        details: error.details
      });
    }
    throw error;
  }
}
```

## 📝 Error Logging

### Structured Error Logging
All errors are logged with structured information:

```typescript
// In GlobalExceptionFilter
this.logger.error('API Error', error, {
  statusCode: status,
  path: request.url,
  method: request.method,
  correlationId: request.correlationId,
  userId: request.user?.id,
  tenantId: request.tenantId,
});
```

### Error Context
Include relevant context in error logs:

```typescript
this.logger.error('Entity creation failed', error, {
  entityType: 'Entity',
  tenantId: 'tenant-123',
  userId: 'user-456',
  action: 'create',
  input: sanitizedInput,
});
```

## 🧪 Error Testing

### Test Error Scenarios
Write tests for error conditions:

```typescript
describe('EntityController', () => {
  it('should return 404 for non-existent entity', async () => {
    const response = await request(app.getHttpServer())
      .get('/entities/non-existent-id')
      .set('x-tenant-slug', 'test-tenant')
      .expect(404);

    expect(response.body).toMatchObject({
      statusCode: 404,
      message: 'Not Found',
      error: 'Resource not found',
    });
  });

  it('should return 422 for validation errors', async () => {
    const response = await request(app.getHttpServer())
      .post('/entities')
      .send({ name: '' }) // Invalid data
      .set('x-tenant-slug', 'test-tenant')
      .expect(422);

    expect(response.body).toMatchObject({
      statusCode: 422,
      message: 'Validation failed',
      error: 'Unprocessable Entity',
    });
  });
});
```

## 🎯 Best Practices

### Error Handling
- ✅ Use appropriate HTTP status codes
- ✅ Provide clear, actionable error messages
- ✅ Include relevant error details
- ✅ Log errors with sufficient context
- ✅ Don't expose sensitive information

### Error Messages
- ✅ Use clear, user-friendly language
- ✅ Provide specific field-level errors
- ✅ Include suggestions for fixing errors
- ✅ Use consistent error message format
- ✅ Avoid technical jargon in user-facing errors

### Error Monitoring
- ✅ Monitor error rates and patterns
- ✅ Set up alerts for critical errors
- ✅ Track error correlation IDs
- ✅ Analyze error trends
- ✅ Implement error recovery strategies

## 📚 Related Documentation

### Backend Documentation
- [Entity Endpoints](endpoints/entity-endpoints.md) - Entity API endpoints
- [Health Endpoints](endpoints/health-endpoints.md) - Health check endpoints
- [Usage Examples](usage-examples.md) - Usage examples
- [API Documentation](../) - Complete API documentation
- [Backend Setup](../development/setup.md) - Backend setup guide
- [Testing Guide](../testing/testing-guide.md) - Testing documentation

### Shared Documentation
- [Project Overview](../../../README.md) - Main project documentation
- [Development Setup](../../../docs/development/development-setup.md) - General development setup
- [Testing Strategy](../../../docs/development/testing-strategy.md) - Project-wide testing approach
