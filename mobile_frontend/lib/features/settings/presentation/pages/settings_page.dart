import 'package:flutter/material.dart';

import '../../../shared/presentation/widgets/appbar/w_inner_appbar.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SubpageAppBar(
        title: 'Settings',
        onBackTap: () => Navigator.of(context).pop(),
      ),
      body: const Center(
        child: Text('Settings page'),
      ),
    );
  }
}
