import 'package:go_router/go_router.dart';

/// Navigation service that doesn't create circular dependencies
class NavigationService {
  static GoRouter? _router;
  
  static void setRouter(GoRouter router) {
    _router = router;
  }
  
  static GoRouter get router {
    if (_router == null) {
      throw Exception('Router not initialized. Call setRouter first.');
    }
    return _router!;
  }

  void navigateTo(String route) {
    router.go(route);
  }

  void goToHomePage() {
    router.go('/home');
  }

  void goToProfilePage() {
    router.go('/profile');
  }

  void goBack() {
    router.pop();
  }
}
