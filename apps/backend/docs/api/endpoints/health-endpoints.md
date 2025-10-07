# Health Check Endpoints

This document describes the health check API endpoints.

## 🔗 Base URL

```
Development: http://localhost:3000
Production: https://api.yourdomain.com
```

## 🏥 Health Check

### System Health
```http
GET /api/v1/health
```

**Response:**
```json
{
  "status": "ok",
  "timestamp": "2023-01-01T00:00:00.000Z",
  "uptime": 3600,
  "version": "1.0.0",
  "environment": "development",
  "services": {
    "database": "ok",
    "redis": "ok",
    "external": "ok"
  }
}
```

### Database Health
```http
GET /api/v1/health/database
```

**Response:**
```json
{
  "status": "ok",
  "database": "postgresql",
  "version": "16.0",
  "uptime": 3600,
  "connections": {
    "active": 5,
    "idle": 10,
    "total": 15
  }
}
```

### Detailed Health Check
```http
GET /api/v1/health/detailed
```

**Response:**
```json
{
  "status": "ok",
  "timestamp": "2023-01-01T00:00:00.000Z",
  "uptime": 3600,
  "version": "1.0.0",
  "environment": "development",
  "services": {
    "database": {
      "status": "ok",
      "responseTime": 15,
      "version": "16.0"
    },
    "redis": {
      "status": "ok",
      "responseTime": 5,
      "memory": "2.5MB"
    },
    "external": {
      "status": "ok",
      "responseTime": 100,
      "lastCheck": "2023-01-01T00:00:00.000Z"
    }
  },
  "metrics": {
    "memory": {
      "used": "150MB",
      "total": "512MB",
      "percentage": 29.3
    },
    "cpu": {
      "usage": 15.2
    }
  }
}
```

## 🚨 Health Status Codes

### Status Values
- `ok` - Service is healthy
- `degraded` - Service is partially functional
- `down` - Service is unavailable
- `unknown` - Status cannot be determined

### HTTP Status Codes
- `200` - All services healthy
- `503` - One or more services unhealthy
- `500` - Health check system error

## 📊 Monitoring Integration

### Prometheus Metrics
The health endpoints expose metrics compatible with Prometheus:

```http
GET /api/v1/health/metrics
```

**Response:**
```
# HELP http_requests_total Total number of HTTP requests
# TYPE http_requests_total counter
http_requests_total{method="GET",endpoint="/health",status="200"} 100

# HELP database_connections_active Active database connections
# TYPE database_connections_active gauge
database_connections_active 5

# HELP memory_usage_bytes Memory usage in bytes
# TYPE memory_usage_bytes gauge
memory_usage_bytes 157286400
```

### Health Check Configuration
Configure health checks in your monitoring system:

```yaml
# Prometheus configuration
scrape_configs:
  - job_name: 'gym-manager-health'
    static_configs:
      - targets: ['localhost:3000']
    metrics_path: '/api/v1/health/metrics'
    scrape_interval: 30s
```

## 🔧 Troubleshooting

### Common Issues

#### Database Connection Issues
```json
{
  "status": "degraded",
  "services": {
    "database": {
      "status": "down",
      "error": "Connection timeout",
      "lastCheck": "2023-01-01T00:00:00.000Z"
    }
  }
}
```

#### High Memory Usage
```json
{
  "status": "degraded",
  "services": {
    "database": "ok",
    "redis": "ok"
  },
  "metrics": {
    "memory": {
      "used": "450MB",
      "total": "512MB",
      "percentage": 87.9
    }
  }
}
```

#### External Service Issues
```json
{
  "status": "degraded",
  "services": {
    "database": "ok",
    "redis": "ok",
    "external": {
      "status": "down",
      "error": "Service unavailable",
      "lastCheck": "2023-01-01T00:00:00.000Z"
    }
  }
}
```

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
