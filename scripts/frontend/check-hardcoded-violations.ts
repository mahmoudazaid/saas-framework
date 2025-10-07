#!/usr/bin/env node

/**
 * Flutter Hardcoded Text and Styling Violation Checker
 * 
 * This script checks for hardcoded strings, colors, and styling that should be
 * centralized for localization, theming, and maintainability.
 * 
 * Usage:
 *   npx ts-node scripts/frontend/check-hardcoded-violations.ts [path]
 *   npm run check:hardcoded:frontend
 */

import * as fs from 'fs';
import * as path from 'path';

interface Violation {
  type: 'HARDCODED_TEXT' | 'HARDCODED_STYLING' | 'HARDCODED_COLOR' | 'HARDCODED_SIZE' | 'MISSING_LOCALIZATION';
  file: string;
  line: number;
  message: string;
  severity: 'error' | 'warning' | 'info';
  suggestion: string;
  code: string;
}

interface CheckerStats {
  filesChecked: number;
  violationsFound: number;
  errors: number;
  warnings: number;
  info: number;
}

class HardcodedViolationChecker {
  private violations: Violation[] = [];
  private files: string[] = [];
  private startTime: number = 0;

  // Patterns to detect hardcoded issues
  private readonly patterns = {
    // Hardcoded text patterns
    hardcodedText: [
      // Single-line Text widgets
      /Text\s*\(\s*['"`]([^'"`]+)['"`]\s*\)/g,
      /const\s+Text\s*\(\s*['"`]([^'"`]+)['"`]\s*\)/g,
      /SnackBar\s*\(\s*content:\s*Text\s*\(\s*['"`]([^'"`]+)['"`]\s*\)/g,
      /semanticLabel:\s*['"`]([^'"`]+)['"`]/g,
      /label:\s*['"`]([^'"`]+)['"`]/g,
      /title:\s*Text\s*\(\s*['"`]([^'"`]+)['"`]\s*\)/g,
      /title:\s*['"`]([^'"`]+)['"`]/g,
      /subtitle:\s*Text\s*\(\s*['"`]([^'"`]+)['"`]\s*\)/g,
      /hintText:\s*['"`]([^'"`]+)['"`]/g,
      /placeholder:\s*['"`]([^'"`]+)['"`]/g,
      // Fallback strings in null-aware operators
      /\?\?\s*['"`]([^'"`]+)['"`]/g,
      // Multi-line Text widgets (text on separate line)
      /^\s*['"`]([^'"`]+)['"`]\s*,?\s*$/g,
    ],
    
    // Hardcoded styling patterns
    hardcodedStyling: [
      /TextStyle\s*\(\s*[^)]*fontSize:\s*(\d+)[^)]*\)/g,
      /TextStyle\s*\(\s*[^)]*fontWeight:\s*FontWeight\.(\w+)[^)]*\)/g,
      /TextStyle\s*\(\s*[^)]*color:\s*Colors\.(\w+)[^)]*\)/g,
      /TextStyle\s*\(\s*[^)]*color:\s*Color\([^)]*\)[^)]*\)/g,
    ],
    
    // Hardcoded colors
    hardcodedColors: [
      /color:\s*Colors\.(\w+)/g,
      /backgroundColor:\s*Colors\.(\w+)/g,
      /foregroundColor:\s*Colors\.(\w+)/g,
      /textColor:\s*Colors\.(\w+)/g,
    ],
    
    // Hardcoded sizes
    hardcodedSizes: [
      /fontSize:\s*(\d+)/g,
      /size:\s*(\d+)/g,
      /width:\s*(\d+)/g,
      /height:\s*(\d+)/g,
    ],
  };

  // Exclude patterns (technical strings that shouldn't be localized)
  private readonly excludePatterns = [
    /debugPrint/,
    /print\(/,
    /console\./,
    /toString\(\)/,
    /runtimeType/,
    /_instance/,
    /_tenant/,
    /default-/,
    /X-Tenant/,
    /req_/,
    /\/tenant\//,
    /\/home/,
    /tenant_id/,
    /tenant_slug/,
  ];

  // Allowed hardcoded strings (technical constants)
  private readonly allowedStrings = [
    'default-tenant-id',
    'default-tenant',
    'tenant_id',
    'tenant_slug',
    'X-Tenant-ID',
    'X-Tenant-Slug',
    '/tenant/',
    '/home',
    '/',
    'req_',
  ];

  async check(targetPath: string = 'apps/frontend'): Promise<CheckerStats> {
    this.startTime = Date.now();
    console.log('🔍 Flutter Hardcoded Violation Checker');
    console.log('=====================================');
    console.log(`📁 Checking: ${targetPath}`);
    console.log('');

    if (!fs.existsSync(targetPath)) {
      throw new Error(`Target path does not exist: ${targetPath}`);
    }

    await this.checkDartFiles(targetPath);
    this.displayResults();

    return this.generateStats();
  }

  private async checkDartFiles(targetPath: string): Promise<void> {
    this.files = this.findDartFiles(targetPath);
    
    console.log(`📄 Found ${this.files.length} Dart files to check`);
    console.log('');

    for (const file of this.files) {
      await this.checkFile(file);
    }
  }

  private findDartFiles(targetPath: string): string[] {
    const files: string[] = [];
    
    // Check if target is a single file
    const stat = fs.statSync(targetPath);
    if (stat.isFile() && targetPath.endsWith('.dart')) {
      return [targetPath];
    }
    
    const scanDirectory = (dir: string) => {
      const items = fs.readdirSync(dir);
      
      for (const item of items) {
        const fullPath = path.join(dir, item);
        const stat = fs.statSync(fullPath);
        
        if (stat.isDirectory()) {
          // Skip test directories and generated files
          if (!item.includes('test') && 
              !item.includes('.dart_tool') && 
              !item.includes('build') &&
              !item.includes('.plugin_symlinks') &&
              !item.includes('ephemeral')) {
            scanDirectory(fullPath);
          }
        } else if (item.endsWith('.dart')) {
          // Skip generated files, theme files, and main.dart (system-level configuration)
          if (!fullPath.includes('.plugin_symlinks') && 
              !fullPath.includes('ephemeral') &&
              !fullPath.includes('l10n/app_localizations.dart') &&
              !fullPath.includes('app_theme.dart') &&
              !fullPath.endsWith('main.dart')) {
            files.push(fullPath);
          }
        }
      }
    };
    
    scanDirectory(targetPath);
    return files;
  }

  private async checkFile(filePath: string): Promise<void> {
    const content = fs.readFileSync(filePath, 'utf-8');
    const lines = content.split('\n');
    const relativePath = path.relative(process.cwd(), filePath);

    // Check for hardcoded text
    this.checkHardcodedText(lines, relativePath);
    
    // Check for hardcoded styling
    this.checkHardcodedStyling(lines, relativePath);
    
    // Check for hardcoded colors
    this.checkHardcodedColors(lines, relativePath);
    
    // Check for hardcoded sizes
    this.checkHardcodedSizes(lines, relativePath);
    
    // Check for missing localization
    this.checkMissingLocalization(lines, relativePath);
  }

  private checkHardcodedText(lines: string[], relativePath: string): void {
    lines.forEach((line, index) => {
      // Skip comments and imports
      if (line.trim().startsWith('//') || line.trim().startsWith('import')) {
        return;
      }

      // Check for multi-line text patterns (more intelligent detection)
      this.checkMultiLineText(lines, index, relativePath);

      // Check single-line patterns only (avoid duplicates with multi-line detection)
      const singleLinePatterns = this.patterns.hardcodedText.filter(pattern => 
        !pattern.source.includes('^\s*[\'"`]') // Exclude multi-line pattern
      );
      
      singleLinePatterns.forEach(pattern => {
        let match;
        while ((match = pattern.exec(line)) !== null) {
          const text = match[1];
          // Skip if it's an allowed string
          if (this.allowedStrings.some(allowed => text.includes(allowed))) {
            return;
          }
          
          // Skip if it matches exclude patterns
          if (this.excludePatterns.some(exclude => exclude.test(text))) {
            return;
          }
          
          // Skip if it's already using localization
          if (line.includes('AppLocalizations.of(context)') || line.includes('l10n.')) {
            return;
          }
          
          // Skip if it's a technical string (contains variables or is very short)
          if (text.length < 3 || text.includes('$') || text.includes('{')) {
            return;
          }

          // Skip very short fallback strings (common in localization)
          const shortFallbacks = ['Loading', 'Error', 'Logo', 'Framework', 'OK', 'Yes', 'No', 'Cancel'];
          if (shortFallbacks.includes(text)) {
            return;
          }

          // Skip internal developer messages (context parameters, debug info)
          const internalPatterns = [
            /^[A-Z][a-zA-Z]*\.[a-zA-Z_]+$/,  // ClassName.methodName
            /^[A-Z][a-zA-Z]*$/,              // ClassName
            /^[a-z_]+$/,                     // snake_case identifiers
          ];
          if (internalPatterns.some(pattern => pattern.test(text))) {
            return;
          }

          this.addViolation({
            type: 'HARDCODED_TEXT',
            file: relativePath,
            line: index + 1,
            message: `Hardcoded text found: "${text}"`,
            severity: 'warning',
            suggestion: 'Move to ARB file and use AppLocalizations.of(context)',
            code: line.trim(),
          });
        }
      });
    });
  }

  private checkMultiLineText(lines: string[], currentIndex: number, relativePath: string): void {
    const currentLine = lines[currentIndex];
    
    // Check if this line contains a quoted string that looks like user-facing text
    // Pattern 1: Lines that start and end with quoted string (multi-line text)
    let stringMatch = currentLine.match(/^\s*['"`]([^'"`]+)['"`]\s*,?\s*$/);
    
    // Pattern 2: Property assignments like message: 'text', title: 'text', etc.
    if (!stringMatch) {
      stringMatch = currentLine.match(/\w+:\s*['"`]([^'"`]+)['"`]\s*,?\s*$/);
    }
    
    if (!stringMatch) return;
    
    const text = stringMatch[1];
    
    // Skip if it's an allowed string
    if (this.allowedStrings.some(allowed => text.includes(allowed))) {
      return;
    }
    
    // Skip if it matches exclude patterns
    if (this.excludePatterns.some(exclude => exclude.test(text))) {
      return;
    }
    
    // Skip if it's a technical string (contains variables or is very short)
    if (text.length < 3) {
      return;
    }
    
    // Skip if it's a pure variable reference (no user-facing text)
    if (text.match(/^\$\{[^}]+\}$/)) {
      return;
    }

    // Skip very short fallback strings (common in localization)
    const shortFallbacks = ['Loading', 'Error', 'Logo', 'Framework', 'OK', 'Yes', 'No', 'Cancel'];
    if (shortFallbacks.includes(text)) {
      return;
    }

    // Skip internal developer messages (context parameters, debug info)
    const internalPatterns = [
      /^[A-Z][a-zA-Z]*\.[a-zA-Z_]+$/,  // ClassName.methodName
      /^[A-Z][a-zA-Z]*$/,              // ClassName
      /^[a-z_]+$/,                     // snake_case identifiers
    ];
    if (internalPatterns.some(pattern => pattern.test(text))) {
      return;
    }

    // Check if this string is part of a Text widget or similar UI component
    const isInTextWidget = this.isStringInTextWidget(lines, currentIndex);
    if (!isInTextWidget) return;

    this.addViolation({
      type: 'HARDCODED_TEXT',
      file: relativePath,
      line: currentIndex + 1,
      message: `Hardcoded text found: "${text}"`,
      severity: 'warning',
      suggestion: 'Move to ARB file and use AppLocalizations.of(context)',
      code: currentLine.trim(),
    });
  }

  private isStringInTextWidget(lines: string[], currentIndex: number): boolean {
    // Look backwards for Text( or similar widget patterns
    for (let i = currentIndex - 1; i >= Math.max(0, currentIndex - 5); i--) {
      const line = lines[i];
      if (line.includes('Text(') || 
          line.includes('title:') || 
          line.includes('subtitle:') || 
          line.includes('content:') ||
          line.includes('label:') ||
          line.includes('hintText:') ||
          line.includes('placeholder:') ||
          line.includes('message:')) {
        return true;
      }
    }
    return false;
  }

  private checkHardcodedStyling(lines: string[], relativePath: string): void {
    lines.forEach((line, index) => {
      if (line.trim().startsWith('//') || line.trim().startsWith('import')) {
        return;
      }

      this.patterns.hardcodedStyling.forEach(pattern => {
        let match;
        while ((match = pattern.exec(line)) !== null) {
          this.addViolation({
            type: 'HARDCODED_STYLING',
            file: relativePath,
            line: index + 1,
            message: `Hardcoded styling found: ${match[0]}`,
            severity: 'warning',
            suggestion: 'Use theme-based styling or create reusable style classes',
            code: line.trim(),
          });
        }
      });
    });
  }

  private checkHardcodedColors(lines: string[], relativePath: string): void {
    lines.forEach((line, index) => {
      if (line.trim().startsWith('//') || line.trim().startsWith('import')) {
        return;
      }

      this.patterns.hardcodedColors.forEach(pattern => {
        let match;
        while ((match = pattern.exec(line)) !== null) {
          // Skip if it's using theme colors
          if (line.includes('Theme.of(context)') || line.includes('theme.')) {
            return;
          }

          this.addViolation({
            type: 'HARDCODED_COLOR',
            file: relativePath,
            line: index + 1,
            message: `Hardcoded color found: ${match[0]}`,
            severity: 'warning',
            suggestion: 'Use theme colors: Theme.of(context).colorScheme.primary',
            code: line.trim(),
          });
        }
      });
    });
  }

  private checkHardcodedSizes(lines: string[], relativePath: string): void {
    lines.forEach((line, index) => {
      if (line.trim().startsWith('//') || line.trim().startsWith('import')) {
        return;
      }

      this.patterns.hardcodedSizes.forEach(pattern => {
        let match;
        while ((match = pattern.exec(line)) !== null) {
          // Skip if it's using AppStyles or theme-based sizing
          if (line.includes('AppStyles') || line.includes('Theme.of(context)') || line.includes('theme.')) {
            return;
          }

          // Skip if it's in a const context with common spacing values
          if (this.isConstContextWithCommonSpacing(line, lines, index)) {
            return;
          }

          this.addViolation({
            type: 'HARDCODED_SIZE',
            file: relativePath,
            line: index + 1,
            message: `Hardcoded size found: ${match[0]}`,
            severity: 'info',
            suggestion: 'Use AppStyles constants or theme-based sizing',
            code: line.trim(),
          });
        }
      });
    });
  }

  private isConstContextWithCommonSpacing(line: string, lines: string[], index: number): boolean {
    // Check if we're in a const context
    const isConstContext = line.includes('const ') || 
                          (index > 0 && lines[index - 1].includes('const ')) ||
                          (index > 1 && lines[index - 2].includes('const '));
    
    if (!isConstContext) return false;

    // Common spacing values that are acceptable in const contexts
    const commonSpacingValues = [4, 8, 12, 16, 20, 24, 32, 48, 64];
    const sizeMatch = line.match(/(\d+)/);
    
    if (sizeMatch) {
      const value = parseInt(sizeMatch[1]);
      return commonSpacingValues.includes(value);
    }

    return false;
  }

  private checkMissingLocalization(lines: string[], relativePath: string): void {
    const content = lines.join('\n');
    
    // Check if file has user-facing text but no localization imports
    let hasUserFacingText = false;
    
    // Check each pattern and filter out allowed strings
    for (const pattern of this.patterns.hardcodedText) {
      let match;
      while ((match = pattern.exec(content)) !== null) {
        const text = match[1];
        // Only consider it user-facing if it's not an allowed string
        if (!this.allowedStrings.some(allowed => text.includes(allowed))) {
          hasUserFacingText = true;
          break;
        }
      }
      if (hasUserFacingText) break;
    }
    
    const hasLocalizationImport = content.includes('app_localizations.dart') || content.includes('l10n/');
    
    // Skip controller files - they don't need localization imports
    const isControllerFile = relativePath.includes('/controllers/') || relativePath.includes('/controller/');
    
    if (hasUserFacingText && !hasLocalizationImport && !relativePath.includes('test/') && !isControllerFile) {
      this.addViolation({
        type: 'MISSING_LOCALIZATION',
        file: relativePath,
        line: 1,
        message: 'File contains user-facing text but no localization imports',
        severity: 'info',
        suggestion: 'Import AppLocalizations and use localized strings',
        code: '// Missing: import \'../../../../l10n/app_localizations.dart\';',
      });
    }
  }

  private addViolation(violation: Violation): void {
    // Check for duplicates based on file, line, and message
    const isDuplicate = this.violations.some(existing => 
      existing.file === violation.file && 
      existing.line === violation.line && 
      existing.message === violation.message
    );
    
    if (!isDuplicate) {
      this.violations.push(violation);
    }
  }

  private displayResults(): void {
    const summary = this.generateSummary();
    
    console.log('📊 FRONTEND HARDCODED VIOLATION CHECK RESULTS');
    console.log('================================================================================');
    console.log(`📁 Files checked: ${this.files.length}`);
    console.log(`❌ Violations found: ${summary.total}`);
    console.log(`⚠️  Warnings: ${summary.warnings}`);
    console.log(`⏱️  Duration: ${Date.now() - this.startTime}ms`);
    console.log('');
    
    if (this.violations.length === 0) {
      console.log('✅ No hardcoded violations found! All text and styling is properly centralized.');
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
    Object.entries(violationsByFile).forEach(([file, violations]) => {
      console.log(`📄 ${file}`);
      console.log('─'.repeat(80));
      
      violations.forEach(violation => {
        const icon = violation.severity === 'error' ? '❌' : 
                    violation.severity === 'warning' ? '⚠️' : 'ℹ️';
        
        console.log(`${icon} Line ${violation.line}: ${violation.message}`);
        console.log(`   💡 ${violation.suggestion}`);
        console.log(`   📝 ${violation.code}`);
        console.log('');
      });
    });
    
    console.log('🔧 Recommendations');
    console.log('==================');
    console.log('1. Move all hardcoded text to ARB files');
    console.log('2. Use AppLocalizations.of(context) for user-facing text');
    console.log('3. Create reusable style classes for common styling');
    console.log('4. Use theme colors instead of hardcoded Colors.*');
    console.log('5. Use AppStyles constants for consistent sizing');
    console.log('6. Implement proper theming for dark/light mode support');
  }

  private generateSummary() {
    return {
      total: this.violations.length,
      errors: this.violations.filter(v => v.severity === 'error').length,
      warnings: this.violations.filter(v => v.severity === 'warning').length,
      info: this.violations.filter(v => v.severity === 'info').length,
    };
  }

  private generateStats(): CheckerStats {
    return {
      filesChecked: this.files.length,
      violationsFound: this.violations.length,
      errors: this.violations.filter(v => v.severity === 'error').length,
      warnings: this.violations.filter(v => v.severity === 'warning').length,
      info: this.violations.filter(v => v.severity === 'info').length,
    };
  }
}

// Main execution
async function main() {
  try {
    const targetPath = process.argv[2] || 'apps/frontend';
    const absoluteTargetPath = path.resolve(targetPath);
    
    console.log(`🔍 Checking Flutter hardcoded violations...\n`);
    console.log(`📁 Target path: ${absoluteTargetPath}`);
    
    const checker = new HardcodedViolationChecker();
    const stats = await checker.check(absoluteTargetPath);
    
    if (stats.violationsFound > 0) {
      process.exit(1);
    }
  } catch (error) {
    console.error('❌ Error running hardcoded violation checker:', error);
    process.exit(1);
  }
}

// Run if called directly
if (require.main === module) {
  main();
}

export { HardcodedViolationChecker, Violation };
