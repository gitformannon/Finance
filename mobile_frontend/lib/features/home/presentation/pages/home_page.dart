import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Home'),
      ),
      body: const Center(
        child: Text('Home Page'),
      ),
    );
  }
}
