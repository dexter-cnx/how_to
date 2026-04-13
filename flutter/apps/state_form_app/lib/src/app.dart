import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'form/presentation/login_page.dart';
import 'form/presentation/success_page.dart';

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/success',
      builder: (context, state) => const SuccessPage(),
    ),
  ],
);

class StateFormApp extends StatelessWidget {
  const StateFormApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepPurple),
    );
  }
}
