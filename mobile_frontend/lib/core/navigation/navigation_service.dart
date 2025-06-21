import 'package:go_router/go_router.dart';

class NavigationService {
  final GoRouter _router;
  NavigationService(this._router);


  void navigateTo(
    String routeName, {
    Map<String, String>? params,
    Object? extra,
  }) {
    _router.go(routeName, extra: extra);
  }

  Future<dynamic> pushTo(String routeName, {Object? extra}) {
    return _router.push(routeName, extra: extra);
  }

  Future<dynamic> replace(String routeName, {Object? extra}) {
    return _router.replace(routeName, extra: extra);
  }

  Future<dynamic> pushReplacement(String routeName, {Object? extra}) {
    return _router.pushReplacement(routeName, extra: extra);
  }
  void goBack([dynamic args]) {
    _router.pop(args);
  }

  get context => _router.configuration.navigatorKey.currentContext;
}
