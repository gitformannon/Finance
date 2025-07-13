import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../shared/presentation/widgets/app_buttons/w_button.dart';
import '../../../shared/presentation/widgets/appbar/w_inner_appbar.dart';
import '../../../shared/presentation/cubits/navigate/navigate_cubit.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
        if (state.status.isLoading()) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.status.isError()) {
          return Center(child: Text(state.errorMessage));
        }
        final p = state.profile;
        if (p != null) {
          _firstNameController.text = p.firstName;
          _lastNameController.text = p.lastName;
        }
        return Scaffold(
          appBar: SubpageAppBar(
            title: 'Profile',
            onBackTap: () =>
                context.read<NavigateCubit>().goToMainPage(),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (p != null) ...[
                  Text('ID: ${p.id}'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(labelText: 'First Name'),
                  ),
                  TextField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(labelText: 'Last Name'),
                  ),
                ],
                const Spacer(),
                WButton(
                  onTap: () => context.read<ProfileCubit>().logout(),
                  text: 'Logout',
                ),
                const SizedBox(height: 8),
                WButton(
                  onTap: () => context
                      .read<ProfileCubit>()
                      .updateName(_firstNameController.text, _lastNameController.text),
                  text: 'Save',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
