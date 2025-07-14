import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class BudgetPage extends StatelessWidget {
  const BudgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Text('Budget Page'),
      ),
    );
  }
}
