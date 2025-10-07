// src/core/services/domain.service.ts
// Base domain service interface
export abstract class DomainService {
  // Add common domain service methods here
}

// Example of a specific domain service
export abstract class TenantService extends DomainService {
  abstract validateTenantAccess(userId: string, tenantId: string): Promise<boolean>;
  abstract getTenantContext(tenantId: string): Promise<unknown>;
}
