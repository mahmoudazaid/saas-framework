# Performance Guide

## ⚡ **Overview**

This guide explains how to optimize performance in our Flutter framework. The framework provides tools and patterns to build high-performance Flutter applications.

## 🏗️ **Performance Architecture**

### **Performance Layers**
```
lib/
├── core/
│   ├── performance/
│   │   ├── performance_monitor.dart  # Performance monitoring
│   │   ├── memory_manager.dart       # Memory management
│   │   └── cache_manager.dart        # Caching strategies
│   └── utils/
│       ├── debouncer.dart           # Debouncing utilities
│       └── throttler.dart           # Throttling utilities
├── features/
│   └── [feature]/
│       ├── presentation/
│       │   ├── widgets/             # Optimized widgets
│       │   └── controllers/         # State management
│       └── data/
│           └── repositories/        # Data layer optimization
```

## 📊 **Performance Monitoring**

### **Performance Monitor**
```dart
// lib/core/performance/performance_monitor.dart
class PerformanceMonitor {
  static final _instance = PerformanceMonitor._internal();
  factory PerformanceMonitor() => _instance;
  PerformanceMonitor._internal();

  final Map<String, Stopwatch> _timers = {};
  final List<PerformanceMetric> _metrics = [];

  void startTimer(String name) {
    _timers[name] = Stopwatch()..start();
  }

  void endTimer(String name) {
    final timer = _timers.remove(name);
    if (timer != null) {
      timer.stop();
      _metrics.add(PerformanceMetric(
        name: name,
        duration: timer.elapsedMilliseconds,
        timestamp: DateTime.now(),
      ));
    }
  }

  void recordMetric(String name, int value) {
    _metrics.add(PerformanceMetric(
      name: name,
      value: value,
      timestamp: DateTime.now(),
    ));
  }

  List<PerformanceMetric> getMetrics() => List.unmodifiable(_metrics);

  void clearMetrics() {
    _metrics.clear();
  }
}

class PerformanceMetric {
  final String name;
  final int? duration;
  final int? value;
  final DateTime timestamp;

  PerformanceMetric({
    required this.name,
    this.duration,
    this.value,
    required this.timestamp,
  });
}
```

### **Widget Performance Tracking**
```dart
// lib/core/performance/widget_performance.dart
class PerformanceWidget extends StatefulWidget {
  final Widget child;
  final String name;

  const PerformanceWidget({
    super.key,
    required this.child,
    required this.name,
  });

  @override
  State<PerformanceWidget> createState() => _PerformanceWidgetState();
}

class _PerformanceWidgetState extends State<PerformanceWidget> {
  @override
  void initState() {
    super.initState();
    PerformanceMonitor().startTimer('${widget.name}_build');
  }

  @override
  void dispose() {
    PerformanceMonitor().endTimer('${widget.name}_build');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
```

## 🧠 **Memory Management**

### **Memory Manager**
```dart
// lib/core/performance/memory_manager.dart
class MemoryManager {
  static final _instance = MemoryManager._internal();
  factory MemoryManager() => _instance;
  MemoryManager._internal();

  final Map<String, dynamic> _cache = {};
  final int _maxCacheSize = 100;

  T? get<T>(String key) {
    return _cache[key] as T?;
  }

  void set<T>(String key, T value) {
    if (_cache.length >= _maxCacheSize) {
      _evictOldest();
    }
    _cache[key] = value;
  }

  void remove(String key) {
    _cache.remove(key);
  }

  void clear() {
    _cache.clear();
  }

  void _evictOldest() {
    if (_cache.isNotEmpty) {
      final oldestKey = _cache.keys.first;
      _cache.remove(oldestKey);
    }
  }

  void forceGC() {
    // Force garbage collection
    _cache.clear();
    // Additional cleanup if needed
  }
}
```

### **Disposable Pattern**
```dart
// lib/core/performance/disposable.dart
abstract class Disposable {
  void dispose();
}

class DisposableManager {
  final List<Disposable> _disposables = [];

  void add(Disposable disposable) {
    _disposables.add(disposable);
  }

  void disposeAll() {
    for (final disposable in _disposables) {
      disposable.dispose();
    }
    _disposables.clear();
  }
}
```

## 🚀 **Widget Optimization**

### **Optimized List Widgets**
```dart
// lib/core/widgets/optimized_list.dart
class OptimizedListView extends StatelessWidget {
  final List<dynamic> items;
  final Widget Function(BuildContext, int) itemBuilder;
  final ScrollController? controller;

  const OptimizedListView({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return PerformanceWidget(
          name: 'list_item_$index',
          child: itemBuilder(context, index),
        );
      },
    );
  }
}

// Lazy loading list
class LazyLoadingListView extends StatefulWidget {
  final Future<List<dynamic>> Function(int page) loadData;
  final Widget Function(BuildContext, dynamic) itemBuilder;

  const LazyLoadingListView({
    super.key,
    required this.loadData,
    required this.itemBuilder,
  });

  @override
  State<LazyLoadingListView> createState() => _LazyLoadingListViewState();
}

class _LazyLoadingListViewState extends State<LazyLoadingListView> {
  final List<dynamic> _items = [];
  final ScrollController _controller = ScrollController();
  bool _isLoading = false;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _loadData();
    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    if (_controller.position.pixels >= _controller.position.maxScrollExtent * 0.8) {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final newItems = await widget.loadData(_currentPage);
      setState(() {
        _items.addAll(newItems);
        _currentPage++;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _controller,
      itemCount: _items.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _items.length) {
          return const Center(child: CircularProgressIndicator());
        }
        return widget.itemBuilder(context, _items[index]);
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

### **Image Optimization**
```dart
// lib/core/widgets/optimized_image.dart
class OptimizedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const OptimizedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => placeholder ?? const CircularProgressIndicator(),
      errorWidget: (context, url, error) => errorWidget ?? const Icon(Icons.error),
      memCacheWidth: width?.toInt(),
      memCacheHeight: height?.toInt(),
    );
  }
}
```

## 🔄 **State Management Optimization**

### **Optimized State Notifier**
```dart
// lib/core/state/optimized_state_notifier.dart
abstract class OptimizedStateNotifier<T extends BaseState> extends StateNotifier<T> {
  OptimizedStateNotifier(T initialState) : super(initialState);

  final Map<String, dynamic> _cache = {};
  final Duration _cacheTimeout = const Duration(minutes: 5);

  T? getCachedState(String key) {
    final cached = _cache[key];
    if (cached is Map<String, dynamic>) {
      final timestamp = cached['timestamp'] as DateTime?;
      if (timestamp != null && 
          DateTime.now().difference(timestamp) < _cacheTimeout) {
        return cached['state'] as T?;
      }
    }
    return null;
  }

  void cacheState(String key, T state) {
    _cache[key] = {
      'state': state,
      'timestamp': DateTime.now(),
    };
  }

  void clearCache() {
    _cache.clear();
  }

  @override
  void dispose() {
    clearCache();
    super.dispose();
  }
}
```

### **Debounced Operations**
```dart
// lib/core/utils/debouncer.dart
class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({this.delay = const Duration(milliseconds: 500)});

  void call(VoidCallback callback) {
    _timer?.cancel();
    _timer = Timer(delay, callback);
  }

  void dispose() {
    _timer?.cancel();
  }
}

// Usage in widgets
class SearchWidget extends StatefulWidget {
  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController _controller = TextEditingController();
  final Debouncer _debouncer = Debouncer(delay: const Duration(milliseconds: 300));

  @override
  void dispose() {
    _controller.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: (value) {
        _debouncer.call(() {
          // Perform search
          _performSearch(value);
        });
      },
    );
  }

  void _performSearch(String query) {
    // Search implementation
  }
}
```

## 📱 **Platform-Specific Optimization**

### **Web Optimization**
```dart
// lib/core/performance/web_optimization.dart
class WebOptimization {
  static void enableWebOptimizations() {
    if (kIsWeb) {
      // Enable web-specific optimizations
      _enableWebCaching();
      _optimizeWebAssets();
    }
  }

  static void _enableWebCaching() {
    // Configure web caching
  }

  static void _optimizeWebAssets() {
    // Optimize web assets
  }
}
```

### **Mobile Optimization**
```dart
// lib/core/performance/mobile_optimization.dart
class MobileOptimization {
  static void enableMobileOptimizations() {
    if (!kIsWeb) {
      // Enable mobile-specific optimizations
      _optimizeMobileMemory();
      _enableMobileCaching();
    }
  }

  static void _optimizeMobileMemory() {
    // Optimize mobile memory usage
  }

  static void _enableMobileCaching() {
    // Enable mobile caching
  }
}
```

## 🧪 **Performance Testing**

### **Performance Tests**
```dart
// test/performance/performance_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:generic_framework_app/core/performance/performance_monitor.dart';

void main() {
  group('Performance Tests', () {
    test('should measure widget build time', () {
      final monitor = PerformanceMonitor();
      
      monitor.startTimer('widget_build');
      // Simulate widget build
      monitor.endTimer('widget_build');
      
      final metrics = monitor.getMetrics();
      expect(metrics.length, 1);
      expect(metrics.first.name, 'widget_build');
      expect(metrics.first.duration, lessThan(100)); // Should be less than 100ms
    });
    
    test('should measure memory usage', () {
      final monitor = PerformanceMonitor();
      
      // Simulate memory-intensive operation
      final largeList = List.generate(10000, (index) => index);
      
      monitor.recordMetric('memory_usage', largeList.length);
      
      final metrics = monitor.getMetrics();
      expect(metrics.length, 1);
      expect(metrics.first.name, 'memory_usage');
      expect(metrics.first.value, 10000);
    });
  });
}
```

## 📚 **Best Practices**

1. **Use const constructors** whenever possible
2. **Implement lazy loading** for large datasets
3. **Cache frequently accessed data** appropriately
4. **Optimize images** with proper sizing and caching
5. **Use ListView.builder** for large lists
6. **Implement debouncing** for user input
7. **Monitor performance** with metrics
8. **Dispose resources** properly
9. **Use efficient state management** patterns
10. **Test performance** in your test suite

## 🔧 **Performance Tools**

### **Flutter Inspector**
- Use Flutter Inspector to identify performance issues
- Check widget rebuilds and unnecessary renders
- Monitor memory usage and leaks

### **Performance Overlay**
```dart
// Enable performance overlay in debug mode
MaterialApp(
  showPerformanceOverlay: kDebugMode,
  // ... other properties
)
```

### **Memory Profiling**
```dart
// Memory profiling utilities
class MemoryProfiler {
  static void logMemoryUsage(String context) {
    if (kDebugMode) {
      print('Memory usage at $context: ${_getMemoryUsage()}');
    }
  }
  
  static String _getMemoryUsage() {
    // Get memory usage information
    return 'Memory usage info';
  }
}
```

This performance guide provides comprehensive strategies for building high-performance Flutter applications.
