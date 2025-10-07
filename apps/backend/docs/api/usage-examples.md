# Usage Examples

This document provides practical usage examples for the backend API.

## 🚀 Quick Start Examples

### Basic Entity Operations

#### 1. Create an Entity
```bash
curl -X POST http://localhost:3000/api/v1/entities \
  -H "Authorization: Bearer your-jwt-token" \
  -H "x-tenant-slug: acme-corp" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "My First Entity",
    "description": "This is a test entity"
  }'
```

**Response:**
```json
{
  "data": {
    "id": "entity-123",
    "name": "My First Entity",
    "description": "This is a test entity",
    "tenantId": "tenant-456",
    "createdAt": "2023-01-01T00:00:00.000Z",
    "updatedAt": "2023-01-01T00:00:00.000Z"
  },
  "message": "Entity created successfully"
}
```

#### 2. Get All Entities
```bash
curl -X GET "http://localhost:3000/api/v1/entities?page=1&limit=10" \
  -H "Authorization: Bearer your-jwt-token" \
  -H "x-tenant-slug: acme-corp"
```

**Response:**
```json
{
  "data": [
    {
      "id": "entity-123",
      "name": "My First Entity",
      "description": "This is a test entity",
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

#### 3. Get Entity by ID
```bash
curl -X GET http://localhost:3000/api/v1/entities/entity-123 \
  -H "Authorization: Bearer your-jwt-token" \
  -H "x-tenant-slug: acme-corp"
```

#### 4. Update Entity
```bash
curl -X PUT http://localhost:3000/api/v1/entities/entity-123 \
  -H "Authorization: Bearer your-jwt-token" \
  -H "x-tenant-slug: acme-corp" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Updated Entity Name",
    "description": "Updated description"
  }'
```

#### 5. Delete Entity
```bash
curl -X DELETE http://localhost:3000/api/v1/entities/entity-123 \
  -H "Authorization: Bearer your-jwt-token" \
  -H "x-tenant-slug: acme-corp"
```

## 🔧 Advanced Examples

### Pagination and Filtering

#### Paginated Results
```bash
curl -X GET "http://localhost:3000/api/v1/entities?page=2&limit=5&sortBy=name&sortOrder=asc" \
  -H "Authorization: Bearer your-jwt-token" \
  -H "x-tenant-slug: acme-corp"
```

#### Search Entities
```bash
curl -X GET "http://localhost:3000/api/v1/entities?search=test&page=1&limit=10" \
  -H "Authorization: Bearer your-jwt-token" \
  -H "x-tenant-slug: acme-corp"
```

### Error Handling Examples

#### Validation Error
```bash
curl -X POST http://localhost:3000/api/v1/entities \
  -H "Authorization: Bearer your-jwt-token" \
  -H "x-tenant-slug: acme-corp" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "",
    "description": "Invalid entity"
  }'
```

**Response:**
```json
{
  "statusCode": 422,
  "message": "Validation failed",
  "error": "Unprocessable Entity",
  "details": [
    {
      "field": "name",
      "constraint": "isNotEmpty",
      "value": "",
      "message": "name should not be empty"
    }
  ],
  "timestamp": "2023-01-01T00:00:00.000Z",
  "path": "/api/v1/entities"
}
```

#### Authentication Error
```bash
curl -X GET http://localhost:3000/api/v1/entities \
  -H "x-tenant-slug: acme-corp"
```

**Response:**
```json
{
  "statusCode": 401,
  "message": "Unauthorized",
  "error": "Authentication failed",
  "details": {
    "code": "MISSING_TOKEN",
    "message": "Authorization header is required"
  }
}
```

#### Tenant Error
```bash
curl -X GET http://localhost:3000/api/v1/entities \
  -H "Authorization: Bearer your-jwt-token" \
  -H "x-tenant-slug: invalid-tenant"
```

**Response:**
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

## 📱 Frontend Integration Examples

### JavaScript/TypeScript

#### Using Fetch API
```typescript
class EntityAPI {
  private baseURL = 'http://localhost:3000/api/v1';
  private token: string;
  private tenantSlug: string;

  constructor(token: string, tenantSlug: string) {
    this.token = token;
    this.tenantSlug = tenantSlug;
  }

  private async request(endpoint: string, options: RequestInit = {}) {
    const response = await fetch(`${this.baseURL}${endpoint}`, {
      ...options,
      headers: {
        'Authorization': `Bearer ${this.token}`,
        'x-tenant-slug': this.tenantSlug,
        'Content-Type': 'application/json',
        ...options.headers,
      },
    });

    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.message || 'API request failed');
    }

    return response.json();
  }

  async getEntities(page = 1, limit = 10) {
    return this.request(`/entities?page=${page}&limit=${limit}`);
  }

  async getEntity(id: string) {
    return this.request(`/entities/${id}`);
  }

  async createEntity(data: { name: string; description?: string }) {
    return this.request('/entities', {
      method: 'POST',
      body: JSON.stringify(data),
    });
  }

  async updateEntity(id: string, data: { name: string; description?: string }) {
    return this.request(`/entities/${id}`, {
      method: 'PUT',
      body: JSON.stringify(data),
    });
  }

  async deleteEntity(id: string) {
    return this.request(`/entities/${id}`, {
      method: 'DELETE',
    });
  }
}

// Usage
const api = new EntityAPI('your-jwt-token', 'acme-corp');

// Get entities
const entities = await api.getEntities(1, 10);
console.log(entities);

// Create entity
const newEntity = await api.createEntity({
  name: 'New Entity',
  description: 'Created via API'
});
console.log(newEntity);
```

#### Using Axios
```typescript
import axios from 'axios';

const api = axios.create({
  baseURL: 'http://localhost:3000/api/v1',
  headers: {
    'Authorization': `Bearer ${token}`,
    'x-tenant-slug': 'acme-corp',
    'Content-Type': 'application/json',
  },
});

// Request interceptor for error handling
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      // Handle authentication error
      console.error('Authentication failed');
    }
    return Promise.reject(error);
  }
);

// Get entities
const getEntities = async (page = 1, limit = 10) => {
  try {
    const response = await api.get(`/entities?page=${page}&limit=${limit}`);
    return response.data;
  } catch (error) {
    console.error('Failed to fetch entities:', error.response?.data?.message);
    throw error;
  }
};

// Create entity
const createEntity = async (data: { name: string; description?: string }) => {
  try {
    const response = await api.post('/entities', data);
    return response.data;
  } catch (error) {
    console.error('Failed to create entity:', error.response?.data?.message);
    throw error;
  }
};
```

### Python

#### Using Requests
```python
import requests
import json

class EntityAPI:
    def __init__(self, base_url, token, tenant_slug):
        self.base_url = base_url
        self.headers = {
            'Authorization': f'Bearer {token}',
            'x-tenant-slug': tenant_slug,
            'Content-Type': 'application/json'
        }
    
    def get_entities(self, page=1, limit=10):
        response = requests.get(
            f'{self.base_url}/entities',
            params={'page': page, 'limit': limit},
            headers=self.headers
        )
        response.raise_for_status()
        return response.json()
    
    def get_entity(self, entity_id):
        response = requests.get(
            f'{self.base_url}/entities/{entity_id}',
            headers=self.headers
        )
        response.raise_for_status()
        return response.json()
    
    def create_entity(self, data):
        response = requests.post(
            f'{self.base_url}/entities',
            json=data,
            headers=self.headers
        )
        response.raise_for_status()
        return response.json()
    
    def update_entity(self, entity_id, data):
        response = requests.put(
            f'{self.base_url}/entities/{entity_id}',
            json=data,
            headers=self.headers
        )
        response.raise_for_status()
        return response.json()
    
    def delete_entity(self, entity_id):
        response = requests.delete(
            f'{self.base_url}/entities/{entity_id}',
            headers=self.headers
        )
        response.raise_for_status()
        return response.json()

# Usage
api = EntityAPI('http://localhost:3000/api/v1', 'your-jwt-token', 'acme-corp')

# Get entities
entities = api.get_entities(1, 10)
print(entities)

# Create entity
new_entity = api.create_entity({
    'name': 'New Entity',
    'description': 'Created via Python API'
})
print(new_entity)
```

## 🔄 Workflow Examples

### Complete CRUD Workflow
```typescript
async function completeEntityWorkflow() {
  try {
    // 1. Create entity
    const created = await api.createEntity({
      name: 'Workflow Entity',
      description: 'Created in workflow'
    });
    console.log('Created:', created);

    // 2. Get entity
    const retrieved = await api.getEntity(created.data.id);
    console.log('Retrieved:', retrieved);

    // 3. Update entity
    const updated = await api.updateEntity(created.data.id, {
      name: 'Updated Workflow Entity',
      description: 'Updated in workflow'
    });
    console.log('Updated:', updated);

    // 4. List all entities
    const allEntities = await api.getEntities();
    console.log('All entities:', allEntities);

    // 5. Delete entity
    await api.deleteEntity(created.data.id);
    console.log('Entity deleted');

  } catch (error) {
    console.error('Workflow failed:', error.message);
  }
}
```

### Batch Operations
```typescript
async function batchEntityOperations() {
  const entities = [
    { name: 'Entity 1', description: 'First entity' },
    { name: 'Entity 2', description: 'Second entity' },
    { name: 'Entity 3', description: 'Third entity' }
  ];

  try {
    // Create multiple entities
    const createdEntities = await Promise.all(
      entities.map(entity => api.createEntity(entity))
    );
    console.log('Created entities:', createdEntities);

    // Update all entities
    const updatePromises = createdEntities.map((entity, index) =>
      api.updateEntity(entity.data.id, {
        name: `Updated Entity ${index + 1}`,
        description: `Updated description ${index + 1}`
      })
    );
    const updatedEntities = await Promise.all(updatePromises);
    console.log('Updated entities:', updatedEntities);

    // Delete all entities
    const deletePromises = createdEntities.map(entity =>
      api.deleteEntity(entity.data.id)
    );
    await Promise.all(deletePromises);
    console.log('All entities deleted');

  } catch (error) {
    console.error('Batch operations failed:', error.message);
  }
}
```

## 📊 Health Check Examples

### Basic Health Check
```bash
curl -X GET http://localhost:3000/api/v1/health
```

### Database Health Check
```bash
curl -X GET http://localhost:3000/api/v1/health/database
```

### Detailed Health Check
```bash
curl -X GET http://localhost:3000/api/v1/health/detailed
```

## 🎯 Best Practices

### Error Handling
- Always handle API errors gracefully
- Check response status codes
- Provide meaningful error messages to users
- Log errors for debugging

### Performance
- Use pagination for large datasets
- Implement caching where appropriate
- Use appropriate HTTP methods
- Minimize request payload size

### Security
- Always include authentication headers
- Validate input data
- Use HTTPS in production
- Implement rate limiting

## 📚 Related Documentation

### Backend Documentation
- [Entity Endpoints](endpoints/entity-endpoints.md) - Entity API endpoints
- [Health Endpoints](endpoints/health-endpoints.md) - Health check endpoints
- [Error Handling](error-handling.md) - Error handling details
- [API Documentation](../) - Complete API documentation
- [Backend Setup](../development/setup.md) - Backend setup guide
- [Testing Guide](../testing/testing-guide.md) - Testing documentation

### Shared Documentation
- [Project Overview](../../../README.md) - Main project documentation
- [Development Setup](../../../docs/development/development-setup.md) - General development setup
- [Testing Strategy](../../../docs/development/testing-strategy.md) - Project-wide testing approach
