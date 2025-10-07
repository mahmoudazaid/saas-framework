# Navigation Guide

## 🧭 **Overview**

This guide explains how to use the navigation system in our Flutter framework. The framework uses GoRouter for declarative routing and provides a clean, type-safe way to handle navigation.

## 🏗️ **Architecture**

### **Navigation Structure**
```
lib/
├── core/
│   └── routing/
│       ├── app_router.dart          # Main router configuration
│       ├── route_paths.dart         # Route path constants
│       └── route_guards.dart        # Route guards and middleware
├── features/
│   └── [feature]/
│       └── presentation/
│           └── screens/             # Feature screens
└── main.dart                        # Router initialization
```

## ⚙️ **Configuration**

### **App Router Setup**
```dart
// lib/core/routing/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/entity/:id',
        name: 'entity-details',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return EntityDetailsScreen(entityId: id);
        },
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
        routes: [
          GoRoute(
            path: 'profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: 'notifications',
            name: 'notifications',
            builder: (context, state) => const NotificationsScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
}
```

### **Route Paths Constants**
```dart
// lib/core/routing/route_paths.dart
class RoutePaths {
  // Main routes
  static const String splash = '/';
  static const String home = '/home';
  static const String settings = '/settings';
  
  // Entity routes
  static const String entities = '/entities';
  static String entity(String id) => '/entity/$id';
  static String entityEdit(String id) => '/entity/$id/edit';
  static String entityCreate = '/entity/create';
  
  // Settings sub-routes
  static const String profile = '/settings/profile';
  static const String notifications = '/settings/notifications';
  static const String about = '/settings/about';
  
  // Auth routes
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
}
```

## 🚀 **Basic Navigation**

### **Using GoRouter**
```dart
// Navigation examples
class NavigationExamples extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Navigate to a route
        ElevatedButton(
          onPressed: () => context.go('/home'),
          child: const Text('Go to Home'),
        ),
        
        // Navigate with parameters
        ElevatedButton(
          onPressed: () => context.go('/entity/123'),
          child: const Text('View Entity'),
        ),
        
        // Navigate with query parameters
        ElevatedButton(
          onPressed: () => context.go('/search?query=flutter&category=tech'),
          child: const Text('Search'),
        ),
        
        // Push a new route
        ElevatedButton(
          onPressed: () => context.push('/entity/create'),
          child: const Text('Create Entity'),
        ),
        
        // Pop current route
        ElevatedButton(
          onPressed: () => context.pop(),
          child: const Text('Go Back'),
        ),
        
        // Pop with result
        ElevatedButton(
          onPressed: () => context.pop('result'),
          child: const Text('Return Result'),
        ),
      ],
    );
  }
}
```

### **Navigation with Parameters**
```dart
// Passing parameters
class EntityDetailsScreen extends StatelessWidget {
  final String entityId;
  
  const EntityDetailsScreen({
    super.key,
    required this.entityId,
  });
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Entity $entityId'),
      ),
      body: Column(
        children: [
          Text('Entity ID: $entityId'),
          ElevatedButton(
            onPressed: () => context.go('/entity/$entityId/edit'),
            child: const Text('Edit Entity'),
          ),
        ],
      ),
    );
  }
}

// Using the screen
class EntityListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: entities.length,
      itemBuilder: (context, index) {
        final entity = entities[index];
        return ListTile(
          title: Text(entity.name),
          onTap: () => context.go('/entity/${entity.id}'),
        );
      },
    );
  }
}
```

## 🔐 **Route Guards**

### **Authentication Guard**
```dart
// lib/core/routing/route_guards.dart
class AuthGuard {
  static bool canAccess(String location) {
    // Check if user is authenticated
    final isAuthenticated = AuthService.isAuthenticated();
    
    // Define protected routes
    const protectedRoutes = [
      '/home',
      '/settings',
      '/entity',
    ];
    
    // Check if route is protected
    final isProtected = protectedRoutes.any(
      (route) => location.startsWith(route),
    );
    
    if (isProtected && !isAuthenticated) {
      return false;
    }
    
    return true;
  }
  
  static String? redirect(String location) {
    if (!canAccess(location)) {
      return '/login';
    }
    return null;
  }
}
```

### **Using Guards in Router**
```dart
// lib/core/routing/app_router.dart
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      return AuthGuard.redirect(state.location);
    },
    routes: [
      // Public routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      
      // Protected routes
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      // ... other routes
    ],
  );
}
```

## 🎨 **Advanced Navigation**

### **Nested Navigation**
```dart
// Nested routes with ShellRoute
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/home',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return MainLayout(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/search',
            name: 'search',
            builder: (context, state) => const SearchScreen(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
}

class MainLayout extends StatelessWidget {
  final Widget child;
  
  const MainLayout({super.key, required this.child});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _getCurrentIndex(context),
        onTap: (index) => _onTabTapped(context, index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
  
  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).location;
    switch (location) {
      case '/home':
        return 0;
      case '/search':
        return 1;
      case '/profile':
        return 2;
      default:
        return 0;
    }
  }
  
  void _onTabTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/search');
        break;
      case 2:
        context.go('/profile');
        break;
    }
  }
}
```

### **Navigation with State Management**
```dart
// Using Riverpod for navigation state
final navigationProvider = StateNotifierProvider<NavigationNotifier, NavigationState>((ref) {
  return NavigationNotifier();
});

class NavigationNotifier extends StateNotifier<NavigationState> {
  NavigationNotifier() : super(NavigationState.initial());
  
  void navigateTo(String route) {
    state = state.copyWith(currentRoute: route);
  }
  
  void navigateBack() {
    state = state.copyWith(previousRoute: state.currentRoute);
  }
}

class NavigationState {
  final String currentRoute;
  final String? previousRoute;
  final Map<String, dynamic> parameters;
  
  const NavigationState({
    required this.currentRoute,
    this.previousRoute,
    this.parameters = const {},
  });
  
  NavigationState copyWith({
    String? currentRoute,
    String? previousRoute,
    Map<String, dynamic>? parameters,
  }) {
    return NavigationState(
      currentRoute: currentRoute ?? this.currentRoute,
      previousRoute: previousRoute ?? this.previousRoute,
      parameters: parameters ?? this.parameters,
    );
  }
  
  static NavigationState initial() => const NavigationState(currentRoute: '/');
}
```

## 🧪 **Testing Navigation**

### **Navigation Tests**
```dart
// test/navigation/navigation_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:generic_framework_app/core/routing/app_router.dart';

void main() {
  group('Navigation Tests', () {
    testWidgets('should navigate to home screen', (tester) async {
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: AppRouter.router,
        ),
      );
      
      // Navigate to home
      context.go('/home');
      await tester.pumpAndSettle();
      
      expect(find.byType(HomeScreen), findsOneWidget);
    });
    
    testWidgets('should navigate with parameters', (tester) async {
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: AppRouter.router,
        ),
      );
      
      // Navigate to entity details
      context.go('/entity/123');
      await tester.pumpAndSettle();
      
      expect(find.text('Entity 123'), findsOneWidget);
    });
    
    testWidgets('should handle back navigation', (tester) async {
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: AppRouter.router,
        ),
      );
      
      // Navigate to home then back
      context.go('/home');
      await tester.pumpAndSettle();
      
      context.pop();
      await tester.pumpAndSettle();
      
      expect(find.byType(SplashScreen), findsOneWidget);
    });
  });
}
```

## 📚 **Best Practices**

1. **Use declarative routing** with GoRouter
2. **Define route paths as constants** for type safety
3. **Implement route guards** for authentication and authorization
4. **Use nested routes** for complex navigation structures
5. **Handle navigation state** with state management
6. **Test navigation flows** in your test suite
7. **Use meaningful route names** for debugging
8. **Handle deep linking** appropriately
9. **Implement proper back navigation** behavior
10. **Use route parameters** for dynamic content

## 🔧 **Common Patterns**

### **Modal Navigation**
```dart
// Show modal
showModalBottomSheet(
  context: context,
  builder: (context) => const CreateEntityModal(),
);

// Show dialog
showDialog(
  context: context,
  builder: (context) => const ConfirmDialog(),
);
```

### **Deep Linking**
```dart
// Handle deep links
class DeepLinkHandler {
  static void handleDeepLink(String link) {
    final uri = Uri.parse(link);
    
    switch (uri.path) {
      case '/entity':
        final id = uri.queryParameters['id'];
        if (id != null) {
          context.go('/entity/$id');
        }
        break;
      case '/search':
        final query = uri.queryParameters['q'];
        if (query != null) {
          context.go('/search?query=$query');
        }
        break;
    }
  }
}
```

This navigation guide provides everything you need to implement robust, type-safe navigation in your Flutter applications.
