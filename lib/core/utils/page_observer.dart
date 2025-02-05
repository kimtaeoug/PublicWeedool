import 'package:flutter/cupertino.dart';
import 'package:weedool/utils/logger.dart';

class PageObserver extends RouteObserver<PageRoute<dynamic>> {
  static final PageObserver instance = PageObserver._();
  factory PageObserver() => instance;
  PageObserver._();
  final ValueNotifier<String> _currentPage = ValueNotifier('');
  final ValueNotifier<String> _previousPage = ValueNotifier('');

  void _setCurrentPage(String input) {
    _currentPage.value = input;
  }

  void _setPreviousPage(String input) {
    _previousPage.value = input;
  }

  void _setPage({Route? oldPage, Route? newPage}) {
    _setPreviousPage(_checkPageRoute(oldPage) ?? '');
    _setCurrentPage(_checkPageRoute(newPage) ?? '');
  }

  String get currentPage => _currentPage.value;

  String get previousPage => _previousPage.value;

  String? _checkPageRoute(Route<dynamic>? route) => route?.settings.name;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _setPage(oldPage: previousRoute, newPage: route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _setPage(oldPage: oldRoute, newPage: newRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _setPage(oldPage: previousRoute, newPage: route);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _setPage(oldPage: previousRoute, newPage: route);
  }
}
