import 'package:flutter/material.dart';

import '../../../shared/presentation/widgets/appbar/w_main_appbar.dart';
import '../../../../core/constants/app_images.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        title: 'Home',
        subtitle: 'Welcome back',
        profileImage: const AssetImage(AppImages.logo),
        onProfileTap: () {},
        onNotificationTap: () {},
      ),
      body: const Center(
        child: Text('Home Page'),
      ),
    );
  }
}
