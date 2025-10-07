#!/usr/bin/env node

/**
 * Backend Framework Design Pattern Violation Checker
 * 
 * This script checks for violations of our generic framework design patterns
 * when working on backend code. It enforces Clean Architecture principles,
 * generic terminology, and multi-tenancy patterns.
 * 
 * Usage:
 *   npx ts-node scripts/backend/check-framework-violations.ts [path]
 *   npm run check:framework
 *   npm run check:framework -- apps/backend/src/modules/user
 */

import * as fs from 'fs';
import * as path from 'path';
import { execSync } from 'child_process';

// Configuration interface
interface FrameworkCheckerConfig {
  backendDir: string;
  includePatterns: string[];
  excludePatterns: string[];
  businessTerms: string[];
  genericTerms: string[];
  cleanArchitecture: {
    [key: string]: {
      path: string;
      allowedImports: string[];
      forbiddenImports: string[];
    };
  };
  multiTenancy: {
    requiredFields: string[];
    entityPatterns: string[];
    servicePatterns: string[];
  };
}

// Violation interface
interface Violation {
  type: 'VIOLATION' | 'WARNING' | 'ERROR';
  file: string;
  message: string;
  line?: number;
}

// Stats interface
interface CheckerStats {
  filesChecked: number;
  violationsFound: number;
  warnings: number;
}

// Configuration
const CONFIG: FrameworkCheckerConfig = {
  // Directories to check
  backendDir: 'apps/backend/src',
  
  // File patterns to include
  includePatterns: ['.ts', '.js'],
  
  // File patterns to exclude
  excludePatterns: ['.test.ts', '.spec.ts', '.e2e.ts', '.d.ts'],
  
  // Business-specific terms that violate generic framework
  // These should be configured per project - see project-customization-checklist.md
  businessTerms: [
    // Add your business-specific terms here when customizing the project
    // Example: 'product', 'order', 'customer', 'inventory', 'sales'
  ],
  
  // Generic terms that should be used instead
  genericTerms: [
    'entity', 'tenant', 'user', 'product', 'service', 'resource',
    'item', 'record', 'document', 'subscription', 'order', 'transaction'
  ],
  
  // Required patterns for Clean Architecture
  cleanArchitecture: {
    domain: {
      path: 'core/',
      allowedImports: ['@nestjs/common', 'typeorm'],
      forbiddenImports: ['@nestjs/typeorm', 'express', 'fastify']
    },
    application: {
      path: 'application/',
      allowedImports: ['@nestjs/common', 'typeorm', '../core'],
      forbiddenImports: ['express', 'fastify', '@nestjs/platform-fastify']
    },
    infrastructure: {
      path: 'infrastructure/',
      allowedImports: ['@nestjs/common', 'typeorm', '@nestjs/typeorm', '../core', '../application'],
      forbiddenImports: []
    },
    presentation: {
      path: 'presentation/',
      allowedImports: ['@nestjs/common', '@nestjs/platform-fastify', '../core', '../application', '../infrastructure'],
      forbiddenImports: []
    }
  },
  
  // Multi-tenancy patterns
  multiTenancy: {
    requiredFields: ['tenantId', 'tenantSlug'],
    entityPatterns: ['TenantEntity', 'BaseEntity'],
    servicePatterns: ['TenantService', 'BaseService']
  }
};

class FrameworkViolationChecker {
  private violations: Violation[] = [];
  private stats: CheckerStats = {
    filesChecked: 0,
    violationsFound: 0,
    warnings: 0
  };

  /**
   * Main entry point
   */
  async run(targetPath: string = CONFIG.backendDir): Promise<boolean> {
    const startTime = Date.now();
    const files = this.getFilesToCheck(targetPath);
    
    for (const file of files) {
      await this.checkFile(file);
    }
    
    const endTime = Date.now();
    this.printResults(endTime - startTime);
    
    return this.violations.length === 0;
  }

  /**
   * Get all files to check
   */
  private getFilesToCheck(targetPath: string): string[] {
    const files: string[] = [];
    
    const walkDir = (dir: string): void => {
      if (!fs.existsSync(dir)) return;
      
      const items = fs.readdirSync(dir);
      for (const item of items) {
        const fullPath = path.join(dir, item);
        const stat = fs.statSync(fullPath);
        
        if (stat.isDirectory()) {
          walkDir(fullPath);
        } else if (this.shouldCheckFile(fullPath)) {
          files.push(fullPath);
        }
      }
    };
    
    walkDir(targetPath);
    return files;
  }

  /**
   * Check if file should be checked
   */
  private shouldCheckFile(filePath: string): boolean {
    const ext = path.extname(filePath);
    const basename = path.basename(filePath);
    
    // Include only TypeScript/JavaScript files
    if (!CONFIG.includePatterns.includes(ext)) return false;
    
    // Exclude test files
    if (CONFIG.excludePatterns.some(pattern => basename.includes(pattern))) return false;
    
    return true;
  }

  /**
   * Check a single file for violations
   */
  private async checkFile(filePath: string): Promise<void> {
    this.stats.filesChecked++;
    
    try {
      const content = fs.readFileSync(filePath, 'utf8');
      const relativePath = path.relative(process.cwd(), filePath);
      
      // Check for business-specific terminology
      this.checkBusinessTerminology(content, relativePath);
      
      // Check Clean Architecture violations
      this.checkCleanArchitecture(content, relativePath);
      
      // Check multi-tenancy patterns
      this.checkMultiTenancy(content, relativePath);
      
      // Check generic framework patterns
      this.checkGenericFramework(content, relativePath);
      
    } catch (error) {
      this.addViolation('ERROR', filePath, `Failed to read file: ${error instanceof Error ? error.message : 'Unknown error'}`);
    }
  }

  /**
   * Check for business-specific terminology violations
   */
  private checkBusinessTerminology(content: string, filePath: string): void {
    const lines = content.split('\n');
    
    lines.forEach((line, index) => {
      CONFIG.businessTerms.forEach(term => {
        const regex = new RegExp(`\\b${term}\\b`, 'gi');
        if (regex.test(line)) {
          // Skip if it's in a comment or string literal
          if (line.trim().startsWith('//') || line.trim().startsWith('*') || line.includes(`'${term}'`) || line.includes(`"${term}"`)) {
            return;
          }
          
          // Skip if it's part of a variable name that's already generic
          if (line.includes(`${term}Id`) || line.includes(`${term}Slug`) || line.includes(`${term}Service`)) {
            return;
          }
          
          this.addViolation(
            'VIOLATION',
            filePath,
            `Business-specific term "${term}" found on line ${index + 1}. Use generic terminology instead.`,
            index + 1
          );
        }
      });
    });
  }

  /**
   * Check Clean Architecture violations
   */
  private checkCleanArchitecture(content: string, filePath: string): void {
    const lines = content.split('\n');
    const relativePath = path.relative(CONFIG.backendDir, filePath);
    
    // Determine which layer this file belongs to
    const layer = this.getArchitectureLayer(relativePath);
    if (!layer) return;
    
    const layerConfig = CONFIG.cleanArchitecture[layer];
    if (!layerConfig) return;
    
    // Check forbidden imports
    lines.forEach((line, index) => {
      if (line.trim().startsWith('import')) {
        layerConfig.forbiddenImports.forEach(forbiddenImport => {
          if (line.includes(forbiddenImport)) {
            this.addViolation(
              'VIOLATION',
              filePath,
              `Forbidden import "${forbiddenImport}" in ${layer} layer on line ${index + 1}`,
              index + 1
            );
          }
        });
      }
    });
  }

  /**
   * Check multi-tenancy patterns
   */
  private checkMultiTenancy(content: string, filePath: string): void {
    const lines = content.split('\n');
    
    // Check if entity extends TenantEntity but doesn't have tenantId
    if (content.includes('extends TenantEntity')) {
      if (!content.includes('tenantId')) {
        this.addViolation(
          'VIOLATION',
          filePath,
          'Entity extends TenantEntity but missing tenantId field'
        );
      }
    }
    
    // Check for hardcoded tenant references
    lines.forEach((line, index) => {
      if (line.includes('gymId') || line.includes('gymSlug')) {
        this.addViolation(
          'VIOLATION',
          filePath,
          `Hardcoded tenant reference found on line ${index + 1}. Use tenantId/tenantSlug instead.`,
          index + 1
        );
      }
    });
  }

  /**
   * Check generic framework patterns
   */
  private checkGenericFramework(content: string, filePath: string): void {
    const lines = content.split('\n');
    
    // Check for missing JSDoc comments on public methods
    lines.forEach((line, index) => {
      if (line.includes('public ') && line.includes('(') && !line.includes('//')) {
        const prevLine = lines[index - 1]?.trim();
        if (!prevLine?.startsWith('/**') && !prevLine?.startsWith('*')) {
          this.addViolation(
            'WARNING',
            filePath,
            `Public method on line ${index + 1} should have JSDoc comments`,
            index + 1
          );
        }
      }
    });
    
    // Check for missing error handling in actual async functions (not in comments)
    const hasAsyncFunction = lines.some((line) => {
      const trimmedLine = line.trim();
      // Skip if it's in a comment or JSDoc
      if (trimmedLine.startsWith('//') || trimmedLine.startsWith('*') || trimmedLine.startsWith('/**')) {
        return false;
      }
      // Check if it's an actual async function declaration
      return trimmedLine.includes('async ') && trimmedLine.includes('(') && trimmedLine.includes('{');
    });
    
    if (hasAsyncFunction && !content.includes('try {') && !content.includes('catch')) {
      this.addViolation(
        'WARNING',
        filePath,
        'Async function should have proper error handling'
      );
    }
  }

  /**
   * Get architecture layer from file path
   */
  private getArchitectureLayer(relativePath: string): string | null {
    if (relativePath.includes('core/')) return 'domain';
    if (relativePath.includes('application/')) return 'application';
    if (relativePath.includes('infrastructure/')) return 'infrastructure';
    if (relativePath.includes('presentation/')) return 'presentation';
    return null;
  }

  /**
   * Add a violation
   */
  private addViolation(type: 'VIOLATION' | 'WARNING' | 'ERROR', filePath: string, message: string, line?: number): void {
    const violation: Violation = {
      type,
      file: filePath,
      message,
      line
    };
    
    this.violations.push(violation);
    this.stats.violationsFound++;
    
    if (type === 'WARNING') {
      this.stats.warnings++;
    }
  }

  /**
   * Print results
   */
  private printResults(duration: number): void {
    console.log('\n' + '='.repeat(80));
    console.log('📊 BACKEND FRAMEWORK VIOLATION CHECK RESULTS');
    console.log('='.repeat(80));
    
    console.log(`\n📁 Files checked: ${this.stats.filesChecked}`);
    console.log(`❌ Violations found: ${this.stats.violationsFound}`);
    console.log(`⚠️  Warnings: ${this.stats.warnings}`);
    console.log(`⏱️  Duration: ${duration}ms`);
    
    if (this.violations.length > 0) {
      console.log('\n🚨 VIOLATIONS FOUND:');
      console.log('-'.repeat(80));
      
      const violationsByType = this.groupViolationsByType();
      
      Object.entries(violationsByType).forEach(([type, violations]) => {
        console.log(`\n${type}:`);
        violations.forEach(violation => {
          const location = violation.line ? `:${violation.line}` : '';
          console.log(`  ${violation.file}${location}`);
          console.log(`    ${violation.message}`);
        });
      });
      
      console.log('\n💡 RECOMMENDATIONS:');
      console.log('- Read apps/backend/.cursorrules for detailed rules');
      console.log('- Use generic terminology (Entity, Tenant, User)');
      console.log('- Follow Clean Architecture layer separation');
      console.log('- Add proper error handling and JSDoc comments');
      console.log('- Use tenantId/tenantSlug instead of business-specific terms');
      
    } else {
      console.log('\n✅ No violations found! Framework design patterns are being followed correctly.');
    }
    
    console.log('\n' + '='.repeat(80));
  }

  /**
   * Group violations by type
   */
  private groupViolationsByType(): Record<string, Violation[]> {
    const grouped: Record<string, Violation[]> = {};
    
    this.violations.forEach(violation => {
      if (!grouped[violation.type]) {
        grouped[violation.type] = [];
      }
      grouped[violation.type].push(violation);
    });
    
    return grouped;
  }
}

// Main execution
async function main(): Promise<void> {
  let targetPath = process.argv[2];
  
  // If no target path provided, try to detect based on current directory
  if (!targetPath) {
    if (fs.existsSync('apps/backend/src')) {
      // Running from project root
      targetPath = 'apps/backend/src';
    } else if (fs.existsSync('src')) {
      // Running from apps/backend directory
      targetPath = 'src';
    } else {
      // Fallback to default
      targetPath = CONFIG.backendDir;
    }
  }
  
  // Resolve to absolute path for better reliability
  const absoluteTargetPath = path.resolve(targetPath);
  
  console.log(`🔍 Checking backend framework design pattern violations...\n`);
  console.log(`📁 Target path: ${absoluteTargetPath}`);
  
  const checker = new FrameworkViolationChecker();
  const success = await checker.run(absoluteTargetPath);
  
  process.exit(success ? 0 : 1);
}

// Run if called directly
main().catch(error => {
  console.error('❌ Error running framework violation checker:', error);
  process.exit(1);
});

export default FrameworkViolationChecker;
