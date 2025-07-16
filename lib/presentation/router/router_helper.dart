import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'router.dart';
import 'routes.dart';

class RouterHelper {
  static void push(BuildContext context, String location, {Object? extra}) {
    context.pushNamed(location, extra: extra);
  }

  static void go(BuildContext context, String location, {Object? extra}) {
    context.goNamed(location, extra: extra);
  }

  static void pushReplace(BuildContext context, String location,
      {Object? extra}) {
    context.pushReplacementNamed(location, extra: extra);
  }

  static void pop<T>(BuildContext context, {T? data}) {
    return context.pop(data);
  }

  static Future<T?> pushData<T>(BuildContext context, String location,
      {Object? extra}) async {
    return await context.pushNamed<T>(location, extra: extra);
  }

  static void restart(BuildContext context) {
    AppRouter.router.refresh();
    pushReplace(context, AppRoutes.splash.path);
  }
}
