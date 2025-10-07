// src/presentation/middleware/tenant.middleware.ts
import { Injectable, NestMiddleware } from '@nestjs/common';
import { Request, Response, NextFunction } from 'express';

@Injectable()
export class TenantMiddleware implements NestMiddleware {
  use(req: Request, _res: Response, next: NextFunction): void {
    // Extract tenant information from request
    const tenantSlug = (req.headers['x-tenant-slug'] as string) ?? 
                      (req.params['tenantSlug'] as string) ?? 
                      (req.query['tenantSlug'] as string);

    if (tenantSlug) {
      (req as Request & { tenantSlug?: string }).tenantSlug = tenantSlug;
    }

    next();
  }
}
