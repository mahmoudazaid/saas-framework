// test/test_config.dart

/// Test configuration and tag definitions for the Flutter framework
class TestConfig {
  // Test Categories
  static const String unit = 'unit';
  static const String integration = 'integration';
  static const String widget = 'widget';

  // Test Types
  static const String smoke = 'smoke';
  static const String regression = 'regression';
  static const String performance = 'performance';
  static const String security = 'security';
  static const String accessibility = 'accessibility';

  // Test Priority
  static const String critical = 'critical';
  static const String high = 'high';
  static const String medium = 'medium';
  static const String low = 'low';

  // Test Scope
  static const String core = 'core';
  static const String feature = 'feature';
  static const String ui = 'ui';
  static const String api = 'api';

  // Test Environment
  static const String local = 'local';
  static const String ci = 'ci';
  static const String staging = 'staging';
  static const String production = 'production';

  // Test Speed
  static const String fast = 'fast';
  static const String slow = 'slow';
  static const String verySlow = 'very-slow';

  // Test Dependencies
  static const String network = 'network';
  static const String database = 'database';
  static const String fileSystem = 'file-system';
  static const String external = 'external';
}

/// Test tag combinations for common scenarios
class TestTags {
  // Core Framework Tests
  static const List<String> coreUnit = [
    TestConfig.core,
    TestConfig.unit,
    TestConfig.fast
  ];
  static const List<String> coreIntegration = [
    TestConfig.core,
    TestConfig.integration,
    TestConfig.medium
  ];

  // Feature Tests
  static const List<String> featureUnit = [
    TestConfig.feature,
    TestConfig.unit,
    TestConfig.fast
  ];
  static const List<String> featureIntegration = [
    TestConfig.feature,
    TestConfig.integration,
    TestConfig.medium
  ];
  static const List<String> featureWidget = [
    TestConfig.feature,
    TestConfig.widget,
    TestConfig.medium
  ];

  // UI Tests
  static const List<String> uiWidget = [
    TestConfig.ui,
    TestConfig.widget,
    TestConfig.fast
  ];
  static const List<String> uiAccessibility = [
    TestConfig.ui,
    TestConfig.accessibility,
    TestConfig.medium
  ];

  // Smoke Tests
  static const List<String> smokeCritical = [
    TestConfig.smoke,
    TestConfig.critical,
    TestConfig.fast
  ];
  static const List<String> smokeRegression = [
    TestConfig.smoke,
    TestConfig.regression,
    TestConfig.medium
  ];

  // Performance Tests
  static const List<String> performanceSlow = [
    TestConfig.performance,
    TestConfig.slow
  ];
  static const List<String> performanceVerySlow = [
    TestConfig.performance,
    TestConfig.verySlow
  ];

  // Security Tests
  static const List<String> securityCritical = [
    TestConfig.security,
    TestConfig.critical,
    TestConfig.medium
  ];

  // Environment Specific
  static const List<String> ciOnly = [TestConfig.ci, TestConfig.slow];
  static const List<String> localOnly = [TestConfig.local, TestConfig.fast];
  static const List<String> stagingOnly = [
    TestConfig.staging,
    TestConfig.integration
  ];

  // Network Tests
  static const List<String> networkRequired = [
    TestConfig.network,
    TestConfig.external,
    TestConfig.slow
  ];
  static const List<String> offline = [
    TestConfig.unit,
    TestConfig.fast
  ]; // No network dependency
}
