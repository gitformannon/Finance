import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Finance/core/di/get_it.dart';
import '../cubit/account_cubit.dart';
import '../../../shared/presentation/widgets/app_buttons/w_button.dart';

class AddAccountModal extends StatefulWidget {
  const AddAccountModal({super.key});

  @override
  State<AddAccountModal> createState() => _AddAccountModalState();
}

class _AddAccountModalState extends State<AddAccountModal> {
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getItInstance<AccountCubit>(),
      child: BlocBuilder<AccountCubit, AccountState>(
        builder: (context, state) {
          final cubit = context.read<AccountCubit>();
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  onChanged: cubit.setName,
                ),
                TextField(
                  controller: _balanceController,
                  decoration: const InputDecoration(labelText: 'Initial balance'),
                  keyboardType: TextInputType.number,
                  onChanged: (v) => cubit.setBalance(int.tryParse(v) ?? 0),
                ),
                WButton(
                  onTap: cubit.submit,
                  text: 'Save',
                  isDisabled: state.name.isEmpty || state.status.isLoading(),
                  isLoading: state.status.isLoading(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
