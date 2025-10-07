// src/presentation/guards/tenant.guard.ts
import { Injectable, CanActivate, ExecutionContext, ForbiddenException } from '@nestjs/common';
import { Request } from 'express';

@Injectable()
export class TenantGuard implements CanActivate {
  canActivate(context: ExecutionContext): boolean {
    const request = context.switchToHttp().getRequest<Request & { tenantSlug?: string }>();
    const tenantSlug = request.tenantSlug;
    // const user = request.user; // Will be used later for user validation

    if (!tenantSlug) {
      throw new ForbiddenException('Tenant context required');
    }

    // Add tenant validation logic here
    // For now, just check if tenantSlug exists
    return Boolean(tenantSlug);
  }
}
