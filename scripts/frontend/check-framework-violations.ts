#!/usr/bin/env ts-node

/**
 * Flutter Framework Compliance Checker
 * 
 * This script checks Flutter code for violations of the generic framework design patterns
 * and ensures compliance with Clean Architecture principles.
 * 
 * Usage:
 *   npm run check:framework:frontend
 *   npm run check:framework:frontend -- <path>
 *   npm run check:framework:frontend -- --watch
 */

import * as fs from 'fs';
import * as path from 'path';
import { execSync } from 'child_process';

// Configuration
const CONFIG = {
  // Directories to check
  sourceDirs: ['lib'],
  testDirs: ['test'],
  
  // File extensions to check
  extensions: ['.dart'],
  
  // Exclude patterns
  excludePatterns: [
    '**/generated/**',
    '**/*.g.dart',
    '**/*.freezed.dart',
    '**/*.mocks.dart',
    '**/l10n/app_localizations*.dart',
    '**/test/**/mocks/**',
  ],
  
  // Business-specific terms that should be avoided
  // These should be configured per project - see project-customization-checklist.md
  businessTerms: [
    // Add your business-specific terms here when customizing the project
    // Example: 'product', 'order', 'customer', 'inventory', 'sales'
  ],
  
  // Generic terms that should be used instead
  genericTerms: [
    'entity', 'tenant', 'user', 'product', 'service', 'subscription', 'order',
    'item', 'resource', 'component', 'feature', 'module', 'system', 'platform'
  ],
  
  // Required patterns
  requiredPatterns: {
    // Clean Architecture layer structure
    cleanArchitecture: {
      domain: 'lib/features/*/domain/',
      data: 'lib/features/*/data/',
      presentation: 'lib/features/*/presentation/',
    },
    
    // State management patterns
    stateManagement: {
      baseState: 'BaseState',
      baseStateNotifier: 'BaseStateNotifier',
      stateNotifier: 'StateNotifier',
    },
    
    // Error handling patterns
    errorHandling: {
      frameworkException: 'FrameworkException',
      errorBoundary: 'ErrorBoundary',
      errorHandler: 'ErrorHandler',
    },
    
    // Multi-tenancy patterns
    multiTenancy: {
      tenantId: 'tenantId',
      tenantSlug: 'tenantSlug',
      tenantEntity: 'TenantEntity',
    },
  },
  
  // Violation types
  violationTypes: {
    BUSINESS_TERM: 'business_term',
    MISSING_PATTERN: 'missing_pattern',
    WRONG_ARCHITECTURE: 'wrong_architecture',
    MISSING_ERROR_HANDLING: 'missing_error_handling',
    MISSING_MULTI_TENANCY: 'missing_multi_tenancy',
    MISSING_STATE_MANAGEMENT: 'missing_state_management',
    MISSING_LOCALIZATION: 'missing_localization',
    MISSING_ACCESSIBILITY: 'missing_accessibility',
    MISSING_RESPONSIVE: 'missing_responsive',
    MISSING_PERFORMANCE: 'missing_performance',
  }
};

interface Violation {
  type: string;
  file: string;
  line: number;
  message: string;
  severity: 'error' | 'warning' | 'info';
  suggestion?: string;
}

interface CheckResult {
  violations: Violation[];
  summary: {
    total: number;
    errors: number;
    warnings: number;
    info: number;
  };
}

class FlutterFrameworkChecker {
  private violations: Violation[] = [];
  private files: string[] = [];
  private targetPath: string;
  private isWatchMode: boolean = false;
  private startTime: number = 0;

  constructor(targetPath: string = 'apps/frontend', isWatchMode: boolean = false) {
    this.targetPath = path.resolve(targetPath);
    this.isWatchMode = isWatchMode;
  }

  /**
   * Main entry point for the checker
   */
  async check(): Promise<CheckResult> {
    this.startTime = Date.now();
    console.log('🔍 Flutter Framework Compliance Checker');
    console.log('=====================================');
    console.log(`📁 Checking: ${this.targetPath}`);
    console.log(`👀 Watch mode: ${this.isWatchMode ? 'enabled' : 'disabled'}`);
    console.log('');

    if (!fs.existsSync(this.targetPath)) {
      throw new Error(`Target path does not exist: ${this.targetPath}`);
    }

    // Reset violations
    this.violations = [];

    // Check all Dart files
    await this.checkDartFiles();

    // Generate summary
    const summary = this.generateSummary();

    // Display results
    this.displayResults();

    return {
      violations: this.violations,
      summary
    };
  }

  /**
   * Check all Dart files in the target directory
   */
  private async checkDartFiles(): Promise<void> {
    this.files = this.findDartFiles();
    
    console.log(`📄 Found ${this.files.length} Dart files to check`);
    console.log('');

    for (const file of this.files) {
      await this.checkFile(file);
    }
  }

  /**
   * Find all Dart files in the target directory
   */
  private findDartFiles(): string[] {
    const files: string[] = [];
    
    const searchDirs = [
      ...CONFIG.sourceDirs.map(dir => path.join(this.targetPath, dir)),
      ...CONFIG.testDirs.map(dir => path.join(this.targetPath, dir))
    ];

    for (const searchDir of searchDirs) {
      if (fs.existsSync(searchDir)) {
        this.findFilesRecursively(searchDir, files);
      }
    }

    return files;
  }

  /**
   * Recursively find Dart files
   */
  private findFilesRecursively(dir: string, files: string[]): void {
    const items = fs.readdirSync(dir);
    
    for (const item of items) {
      const fullPath = path.join(dir, item);
      const stat = fs.statSync(fullPath);
      
      if (stat.isDirectory()) {
        // Skip excluded directories
        const relativePath = path.relative(this.targetPath, fullPath);
        const shouldExclude = CONFIG.excludePatterns.some(pattern => 
          this.matchesPattern(relativePath, pattern)
        );
        
        if (!shouldExclude) {
          this.findFilesRecursively(fullPath, files);
        }
      } else if (stat.isFile() && CONFIG.extensions.includes(path.extname(item))) {
        files.push(fullPath);
      }
    }
  }

  /**
   * Check if a path matches a glob pattern
   */
  private matchesPattern(path: string, pattern: string): boolean {
    const regex = new RegExp(pattern.replace(/\*\*/g, '.*').replace(/\*/g, '[^/]*'));
    return regex.test(path);
  }

  /**
   * Check a single Dart file for violations
   */
  private async checkFile(filePath: string): Promise<void> {
    const content = fs.readFileSync(filePath, 'utf-8');
    const lines = content.split('\n');
    const relativePath = path.relative(this.targetPath, filePath);

    // Check for business-specific terms
    this.checkBusinessTerms(filePath, lines, relativePath);
    
    // Check Clean Architecture patterns
    this.checkCleanArchitecture(filePath, lines, relativePath);
    
    // Check state management patterns
    this.checkStateManagement(filePath, lines, relativePath);
    
    // Check error handling patterns
    this.checkErrorHandling(filePath, lines, relativePath);
    
    // Check multi-tenancy patterns
    this.checkMultiTenancy(filePath, lines, relativePath);
    
    // Check localization patterns
    this.checkLocalization(filePath, lines, relativePath);
    
    // Check accessibility patterns
    this.checkAccessibility(filePath, lines, relativePath);
    
    // Check responsive design patterns
    this.checkResponsiveDesign(filePath, lines, relativePath);
    
    // Check performance patterns
    this.checkPerformance(filePath, lines, relativePath);
  }

  /**
   * Check for business-specific terms
   */
  private checkBusinessTerms(filePath: string, lines: string[], relativePath: string): void {
    for (let i = 0; i < lines.length; i++) {
      const line = lines[i];
      const lineNumber = i + 1;
      
      // Skip comments and strings
      if (this.isInCommentOrString(line, i, lines)) {
        continue;
      }
      
      for (const term of CONFIG.businessTerms) {
        const regex = new RegExp(`\\b${term}\\b`, 'gi');
        if (regex.test(line)) {
          // Skip if it's part of a technical term or context
          if (this.isTechnicalContext(line, term)) {
            continue;
          }
          
          this.addViolation({
            type: CONFIG.violationTypes.BUSINESS_TERM,
            file: relativePath,
            line: lineNumber,
            message: `Business-specific term '${term}' found. Use generic terminology instead.`,
            severity: 'warning',
            suggestion: `Consider using a generic term like 'entity', 'tenant', or 'user' instead of '${term}'.`
          });
        }
      }
    }
  }

  /**
   * Check if a term is used in a technical context (not business-specific)
   */
  private isTechnicalContext(line: string, term: string): boolean {
    // Special handling for specific terms
    if (term === 'class') {
      // Skip if it's the Dart class keyword
      return line.trim().startsWith('class ') || 
             line.includes('abstract class') ||
             line.includes('extends class') ||
             line.includes('implements class') ||
             line.includes('class extends') ||
             line.includes('class implements') ||
             line.includes('class {') ||
             line.includes('class(') ||
             line.includes('class.') ||
             line.includes('class:') ||
             line.includes('class;') ||
             line.includes('class,') ||
             line.includes('class)') ||
             line.includes('class]') ||
             line.includes('class}') ||
             line.includes('class>') ||
             line.includes('class<') ||
             line.includes('class?') ||
             line.includes('class!') ||
             line.includes('class=') ||
             line.includes('class+') ||
             line.includes('class-') ||
             line.includes('class*') ||
             line.includes('class/') ||
             line.includes('class%') ||
             line.includes('class&') ||
             line.includes('class|') ||
             line.includes('class^') ||
             line.includes('class~');
    }
    
    if (term === 'progress') {
      // Skip if it's UI progress indicators or technical progress
      // Check for common UI progress patterns
      const progressPatterns = [
        'progress:', 'progress,', 'progress)', 'progress]', 'progress}',
        'progress>', 'progress<', 'progress?', 'progress!', 'progress=',
        'progress+', 'progress-', 'progress*', 'progress/', 'progress%',
        'progress&', 'progress|', 'progress^', 'progress~', 'progress ',
        'progress.', 'progress(', 'progress[', 'progress{', 'progress;'
      ];
      
      return progressPatterns.some(pattern => line.includes(pattern));
    }
    
    return false;
  }

  /**
   * Check Clean Architecture patterns
   */
  private checkCleanArchitecture(filePath: string, lines: string[], relativePath: string): void {
    const content = lines.join('\n');
    
    // Check if file is in correct layer
    if (relativePath.includes('lib/features/')) {
      const isDomain = relativePath.includes('/domain/');
      const isData = relativePath.includes('/data/');
      const isPresentation = relativePath.includes('/presentation/');
      
      if (!isDomain && !isData && !isPresentation) {
        this.addViolation({
          type: CONFIG.violationTypes.WRONG_ARCHITECTURE,
          file: relativePath,
          line: 1,
          message: 'Feature files must be organized in Clean Architecture layers (domain, data, presentation).',
          severity: 'error',
          suggestion: 'Move file to appropriate layer: domain/ for entities and business logic, data/ for repositories and data sources, presentation/ for UI components.'
        });
      }
    }
    
    // Check for proper imports between layers
    if (relativePath.includes('/domain/') && content.includes('import \'package:flutter/')) {
      this.addViolation({
        type: CONFIG.violationTypes.WRONG_ARCHITECTURE,
        file: relativePath,
        line: 1,
        message: 'Domain layer should not import Flutter framework dependencies.',
        severity: 'error',
        suggestion: 'Remove Flutter imports from domain layer. Domain should be framework-agnostic.'
      });
    }
  }

  /**
   * Check state management patterns
   */
  private checkStateManagement(filePath: string, lines: string[], relativePath: string): void {
    const content = lines.join('\n');
    
    // Check for StateNotifier usage
    if (content.includes('StateNotifier') && !content.includes('BaseStateNotifier')) {
      this.addViolation({
        type: CONFIG.violationTypes.MISSING_STATE_MANAGEMENT,
        file: relativePath,
        line: 1,
        message: 'StateNotifier should extend BaseStateNotifier for consistent error handling.',
        severity: 'warning',
        suggestion: 'Extend BaseStateNotifier instead of StateNotifier directly.'
      });
    }
    
    // Check for proper state classes
    if (content.includes('class') && content.includes('State') && !content.includes('BaseState')) {
      const hasStateNotifier = content.includes('StateNotifier');
      if (hasStateNotifier) {
        this.addViolation({
          type: CONFIG.violationTypes.MISSING_STATE_MANAGEMENT,
          file: relativePath,
          line: 1,
          message: 'State classes should extend BaseState for consistent patterns.',
          severity: 'warning',
          suggestion: 'Extend BaseState for consistent state management patterns.'
        });
      }
    }
  }

  /**
   * Check error handling patterns
   */
  private checkErrorHandling(filePath: string, lines: string[], relativePath: string): void {
    const content = lines.join('\n');
    
    // Check for proper exception handling
    if (content.includes('catch') && !content.includes('FrameworkException')) {
      this.addViolation({
        type: CONFIG.violationTypes.MISSING_ERROR_HANDLING,
        file: relativePath,
        line: 1,
        message: 'Use FrameworkException for consistent error handling.',
        severity: 'warning',
        suggestion: 'Import and use FrameworkException instead of generic Exception.'
      });
    }
    
    // Check for async functions without error handling
    const asyncFunctions = this.findAsyncFunctions(lines);
    for (const func of asyncFunctions) {
      // Skip if function uses handleOperation (which provides error handling)
      if (this.usesHandleOperation(lines, func.startLine, func.endLine)) {
        continue;
      }
      
      if (!this.hasErrorHandling(lines, func.startLine, func.endLine)) {
        this.addViolation({
          type: CONFIG.violationTypes.MISSING_ERROR_HANDLING,
          file: relativePath,
          line: func.startLine,
          message: `Async function '${func.name}' should have proper error handling.`,
          severity: 'warning',
          suggestion: 'Add try-catch block with FrameworkException handling.'
        });
      }
    }
  }

  /**
   * Check multi-tenancy patterns
   */
  private checkMultiTenancy(filePath: string, lines: string[], relativePath: string): void {
    const content = lines.join('\n');
    
    // Skip generated files and exceptions
    if (relativePath.includes('app_localizations') || 
        relativePath.includes('framework_exception') ||
        relativePath.includes('test/')) {
      return;
    }
    
    // Check for tenantId and tenantSlug usage
    if (content.includes('class') && content.includes('Entity') && !content.includes('TenantEntity')) {
      // Skip if it's a controller or screen (not an entity)
      if (relativePath.includes('controller') || relativePath.includes('screen')) {
        return;
      }
      
      this.addViolation({
        type: CONFIG.violationTypes.MISSING_MULTI_TENANCY,
        file: relativePath,
        line: 1,
        message: 'Entities should extend TenantEntity for multi-tenancy support.',
        severity: 'warning',
        suggestion: 'Extend TenantEntity instead of creating custom entity classes.'
      });
    }
    
    // Check for hardcoded tenant references
    if (content.includes('tenant') && !content.includes('tenantId') && !content.includes('tenantSlug')) {
      this.addViolation({
        type: CONFIG.violationTypes.MISSING_MULTI_TENANCY,
        file: relativePath,
        line: 1,
        message: 'Use tenantId and tenantSlug for proper multi-tenancy implementation.',
        severity: 'info',
        suggestion: 'Use tenantId for database queries and tenantSlug for URL routing.'
      });
    }
  }

  /**
   * Check localization patterns
   */
  private checkLocalization(filePath: string, lines: string[], relativePath: string): void {
    const content = lines.join('\n');
    
    // Check for hardcoded strings in UI components
    if (relativePath.includes('/presentation/') && content.includes('Text(') && content.includes('\'')) {
      const hasLocalization = content.includes('AppLocalizations') || content.includes('l10n');
      if (!hasLocalization) {
        this.addViolation({
          type: CONFIG.violationTypes.MISSING_LOCALIZATION,
          file: relativePath,
          line: 1,
          message: 'UI components should use localization instead of hardcoded strings.',
          severity: 'warning',
          suggestion: 'Use AppLocalizations.of(context) for all user-facing text.'
        });
      }
    }
  }

  /**
   * Check accessibility patterns
   */
  private checkAccessibility(filePath: string, lines: string[], relativePath: string): void {
    const content = lines.join('\n');
    
    // Check for missing semantic labels
    if (relativePath.includes('/presentation/') && content.includes('Icon(') && !content.includes('semanticLabel')) {
      this.addViolation({
        type: CONFIG.violationTypes.MISSING_ACCESSIBILITY,
        file: relativePath,
        line: 1,
        message: 'Icons should have semantic labels for accessibility.',
        severity: 'info',
        suggestion: 'Add semanticLabel parameter to Icon widgets.'
      });
    }
    
    // Check for missing accessibility hints
    if (relativePath.includes('/presentation/') && content.includes('GestureDetector') && !content.includes('excludeSemantics')) {
      this.addViolation({
        type: CONFIG.violationTypes.MISSING_ACCESSIBILITY,
        file: relativePath,
        line: 1,
        message: 'Interactive widgets should have proper accessibility support.',
        severity: 'info',
        suggestion: 'Add proper accessibility labels and hints to interactive widgets.'
      });
    }
  }

  /**
   * Check responsive design patterns
   */
  private checkResponsiveDesign(filePath: string, lines: string[], relativePath: string): void {
    const content = lines.join('\n');
    
    // Check for hardcoded dimensions
    if (relativePath.includes('/presentation/') && content.includes('width:') && content.includes('height:')) {
      this.addViolation({
        type: CONFIG.violationTypes.MISSING_RESPONSIVE,
        file: relativePath,
        line: 1,
        message: 'Use responsive design patterns instead of hardcoded dimensions.',
        severity: 'info',
        suggestion: 'Use MediaQuery, LayoutBuilder, or responsive design utilities for flexible layouts.'
      });
    }
  }

  /**
   * Check performance patterns
   */
  private checkPerformance(filePath: string, lines: string[], relativePath: string): void {
    const content = lines.join('\n');
    
    // Check for const constructors
    if (relativePath.includes('/presentation/') && content.includes('Widget') && !content.includes('const ')) {
      this.addViolation({
        type: CONFIG.violationTypes.MISSING_PERFORMANCE,
        file: relativePath,
        line: 1,
        message: 'Widget constructors should be const when possible for better performance.',
        severity: 'info',
        suggestion: 'Add const keyword to widget constructors when all parameters are const.'
      });
    }
    
    // Check for ListView.builder usage
    if (content.includes('ListView(') && !content.includes('ListView.builder')) {
      this.addViolation({
        type: CONFIG.violationTypes.MISSING_PERFORMANCE,
        file: relativePath,
        line: 1,
        message: 'Use ListView.builder for better performance with large lists.',
        severity: 'info',
        suggestion: 'Replace ListView with ListView.builder for dynamic lists.'
      });
    }
  }

  /**
   * Check if line is in comment or string
   */
  private isInCommentOrString(line: string, lineIndex: number, allLines: string[]): boolean {
    // Simple check for single-line comments
    if (line.trim().startsWith('//')) {
      return true;
    }
    
    // Check for multi-line comments
    let inMultiLineComment = false;
    for (let i = 0; i < lineIndex; i++) {
      const currentLine = allLines[i];
      if (currentLine.includes('/*') && !currentLine.includes('*/')) {
        inMultiLineComment = true;
      }
      if (currentLine.includes('*/')) {
        inMultiLineComment = false;
      }
    }
    
    return inMultiLineComment;
  }

  /**
   * Find async functions in the file
   */
  private findAsyncFunctions(lines: string[]): Array<{name: string, startLine: number, endLine: number}> {
    const functions: Array<{name: string, startLine: number, endLine: number}> = [];
    
    for (let i = 0; i < lines.length; i++) {
      const line = lines[i];
      const asyncMatch = line.match(/(\w+)\s*\([^)]*\)\s*async/);
      if (asyncMatch) {
        const functionName = asyncMatch[1];
        const startLine = i + 1;
        
        // Find the end of the function (simplified)
        let endLine = startLine;
        let braceCount = 0;
        let foundOpeningBrace = false;
        
        for (let j = i; j < lines.length; j++) {
          const currentLine = lines[j];
          if (currentLine.includes('{')) {
            braceCount++;
            foundOpeningBrace = true;
          }
          if (currentLine.includes('}')) {
            braceCount--;
          }
          if (foundOpeningBrace && braceCount === 0) {
            endLine = j + 1;
            break;
          }
        }
        
        functions.push({
          name: functionName,
          startLine,
          endLine
        });
      }
    }
    
    return functions;
  }

  /**
   * Check if function has error handling
   */
  private hasErrorHandling(lines: string[], startLine: number, endLine: number): boolean {
    const functionLines = lines.slice(startLine - 1, endLine);
    const functionContent = functionLines.join('\n');
    
    return functionContent.includes('try') && functionContent.includes('catch');
  }

  /**
   * Check if function uses handleOperation (which provides error handling)
   */
  private usesHandleOperation(lines: string[], startLine: number, endLine: number): boolean {
    const functionLines = lines.slice(startLine - 1, endLine);
    const functionContent = functionLines.join('\n');
    
    return functionContent.includes('handleOperation') || 
           functionContent.includes('loadEntities') ||
           functionContent.includes('createEntity') ||
           functionContent.includes('updateEntity') ||
           functionContent.includes('deleteEntity');
  }

  /**
   * Add a violation to the list
   */
  private addViolation(violation: Violation): void {
    this.violations.push(violation);
  }

  /**
   * Generate summary statistics
   */
  private generateSummary() {
    const errors = this.violations.filter(v => v.severity === 'error').length;
    const warnings = this.violations.filter(v => v.severity === 'warning').length;
    const info = this.violations.filter(v => v.severity === 'info').length;
    
    return {
      total: this.violations.length,
      errors,
      warnings,
      info
    };
  }

  /**
   * Display the results
   */
  private displayResults(): void {
    const summary = this.generateSummary();
    
    console.log('📊 FRONTEND FRAMEWORK VIOLATION CHECK RESULTS');
    console.log('================================================================================');
    console.log(`📁 Files checked: ${this.files.length}`);
    console.log(`❌ Violations found: ${summary.total}`);
    console.log(`⚠️  Warnings: ${summary.warnings}`);
    console.log(`⏱️  Duration: ${Date.now() - this.startTime}ms`);
    console.log('');
    
    if (this.violations.length === 0) {
      console.log('✅ No violations found! Frontend framework design patterns are being followed correctly.');
      return;
    }
    
    // Group violations by file
    const violationsByFile = this.violations.reduce((acc, violation) => {
      if (!acc[violation.file]) {
        acc[violation.file] = [];
      }
      acc[violation.file].push(violation);
      return acc;
    }, {} as Record<string, Violation[]>);
    
    // Display violations by file
    for (const [file, violations] of Object.entries(violationsByFile)) {
      console.log(`📄 ${file}`);
      console.log('─'.repeat(file.length + 3));
      
      for (const violation of violations) {
        const icon = violation.severity === 'error' ? '❌' : 
                    violation.severity === 'warning' ? '⚠️' : 'ℹ️';
        
        console.log(`${icon} Line ${violation.line}: ${violation.message}`);
        if (violation.suggestion) {
          console.log(`   💡 ${violation.suggestion}`);
        }
      }
      
      console.log('');
    }
    
    // Display recommendations
    if (summary.errors > 0 || summary.warnings > 0) {
      console.log('🔧 Recommendations');
      console.log('==================');
      console.log('1. Fix all errors first (they break the framework patterns)');
      console.log('2. Address warnings to maintain code quality');
      console.log('3. Consider info suggestions for better practices');
      console.log('4. Use generic terminology instead of business-specific terms');
      console.log('5. Follow Clean Architecture principles');
      console.log('6. Implement proper error handling with FrameworkException');
      console.log('7. Use BaseStateNotifier for state management');
      console.log('8. Extend TenantEntity for multi-tenancy support');
      console.log('9. Use AppLocalizations for all user-facing text');
      console.log('10. Follow accessibility and responsive design patterns');
    }
  }
}

// CLI interface
async function main() {
  const args = process.argv.slice(2);
  const targetPath = args.find(arg => !arg.startsWith('--')) || 'apps/frontend';
  const isWatchMode = args.includes('--watch');
  
  try {
    const checker = new FlutterFrameworkChecker(targetPath, isWatchMode);
    const result = await checker.check();
    
    // Exit with error code if there are errors
    if (result.summary.errors > 0) {
      process.exit(1);
    }
  } catch (error) {
    console.error('❌ Error running Flutter framework checker:', error);
    process.exit(1);
  }
}

// Run if called directly
if (require.main === module) {
  main();
}

export { FlutterFrameworkChecker, CheckResult, Violation };
