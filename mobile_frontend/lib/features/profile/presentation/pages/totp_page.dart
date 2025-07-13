import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../shared/presentation/widgets/appbar/w_inner_appbar.dart';
import '../../../shared/presentation/widgets/app_buttons/w_button.dart';
import '../cubit/totp_cubit.dart';

class TotpPage extends StatefulWidget {
  const TotpPage({super.key});

  @override
  State<TotpPage> createState() => _TotpPageState();
}

class _TotpPageState extends State<TotpPage> {
  final _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<TotpCubit>().loadStatus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TotpCubit, TotpState>(
      builder: (context, state) {
        Widget body;
        if (state.status.isLoading()) {
          body = const Center(child: CircularProgressIndicator());
        } else if (state.status.isError()) {
          body = Center(child: Text(state.errorMessage));
        } else if (state.isEnabled) {
          body = Column(
            children: [
              const Text('TOTP is enabled'),
              TextField(
                controller: _codeController,
                decoration: const InputDecoration(labelText: 'Code'),
              ),
              const SizedBox(height: 16),
              WButton(
                onTap: () =>
                    context.read<TotpCubit>().disable(_codeController.text),
                text: 'Disable',
              ),
            ],
          );
        } else if (state.awaitingConfirmation) {
          body = Column(
            children: [
              if (state.qr.isNotEmpty)
                Image.memory(base64Decode(state.qr)),
              const SizedBox(height: 16),
              TextField(
                controller: _codeController,
                decoration: const InputDecoration(labelText: 'Code'),
              ),
              const SizedBox(height: 16),
              WButton(
                onTap: () =>
                    context.read<TotpCubit>().confirm(_codeController.text),
                text: 'Confirm',
              ),
            ],
          );
        } else {
          body = WButton(
            onTap: () => context.read<TotpCubit>().enable(),
            text: 'Enable TOTP',
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: SubpageAppBar(
            title: 'TOTP',
            onBackTap: () => Navigator.of(context).pop(),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: body,
          ),
        );
      },
    );
  }
}
