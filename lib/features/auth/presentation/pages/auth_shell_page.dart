import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Auth 入口：直接重定向到登录页，由路由处理
class AuthShellPage extends StatelessWidget {
  const AuthShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.go('/auth/login');
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
