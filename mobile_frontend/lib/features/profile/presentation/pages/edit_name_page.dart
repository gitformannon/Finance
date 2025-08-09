import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../shared/presentation/widgets/app_buttons/w_button.dart';
import '../../../shared/presentation/widgets/appbar/w_inner_appbar.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';

class EditNamePage extends StatefulWidget {
  const EditNamePage({super.key});

  @override
  State<EditNamePage> createState() => _EditNamePageState();
}

class _EditNamePageState extends State<EditNamePage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state.profile != null) {
          _firstNameController.text = state.profile!.firstName;
          _lastNameController.text = state.profile!.lastName;
        }
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: SubpageAppBar(
            title: 'Edit name',
            onBackTap: () => Navigator.of(context).pop(),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(labelText: 'First Name'),
                ),
                TextField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(labelText: 'Last Name'),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16),
            child: SafeArea(
              top: false,
              child: WButton(
                onTap: () {
                  context.read<ProfileCubit>().updateName(
                        _firstNameController.text,
                        _lastNameController.text,
                      );
                  Navigator.of(context).pop();
                },
                text: 'Save',
              ),
            ),
          ),
        );
      },
    );
  }
}
