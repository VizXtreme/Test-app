import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/calculator/presentation/screens/calculator_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'calculator',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const CalculatorScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurveTween(curve: Curves.easeOutCubic).animate(animation),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    ),
  ],
);
