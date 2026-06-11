import 'package:flutter/material.dart';
import 'api_client.dart';
import 'session.dart';

/// Inherited widget that exposes [Session] and [ApiClient] to the widget tree.
class AppScope extends InheritedWidget {
  final Session session;
  final ApiClient api;

  const AppScope({
    super.key,
    required this.session,
    required this.api,
    required super.child,
  });

  /// Role of the current logged-in user ('influencer' or 'brand')
  String get role => session.role ?? 'influencer';

  static AppScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope not found in widget tree');
    return scope!;
  }

  @override
  bool updateShouldNotify(AppScope oldWidget) =>
      session != oldWidget.session || api != oldWidget.api;
}
