import 'package:Finance/core/constants/app_colors.dart';
import 'package:Finance/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  final _numberController = TextEditingController();
  final _institutionController = TextEditingController();
  final _balanceController = TextEditingController();

  final Map<int, String> _types = const {
    1: 'Debit card',
    2: 'Credit card',
    3: 'Savings',
    4: 'Investment',
    5: 'Cash',
    6: 'Other',
  };

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    _institutionController.dispose();
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
          return Container(
            height: MediaQuery.of(context).size.height,
            child: SafeArea(
              top: true,
              bottom: false,
              child: Scaffold(
                backgroundColor: AppColors.transparent,
                body: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppSizes.borderSM16),
                    topRight: Radius.circular(AppSizes.borderSM16),
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [AppColors.box, AppColors.box],
                      ),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.all(AppSizes.paddingM.h),
                            child: Column(
                              children: [
                                TextField(
                                  controller: _nameController,
                                  decoration: const InputDecoration(labelText: 'Name'),
                                  onChanged: cubit.setName,
                                ),
                                SizedBox(height: AppSizes.spaceM16.h),
                                TextField(
                                  controller: _numberController,
                                  decoration: const InputDecoration(labelText: 'Account number'),
                                  onChanged: cubit.setNumber,
                                ),
                                SizedBox(height: AppSizes.spaceM16.h),
                                TextField(
                                  controller: _institutionController,
                                  decoration: const InputDecoration(labelText: 'Institution (Bank)'),
                                  onChanged: cubit.setInstitution,
                                ),
                                SizedBox(height: AppSizes.spaceM16.h),
                                DropdownButton<int>(
                                  value: state.type,
                                  hint: const Text('Account type'),
                                  onChanged: cubit.setType,
                                  items: _types.entries
                                      .map(
                                        (e) => DropdownMenuItem(
                                          value: e.key,
                                          child: Text(e.value),
                                        ),
                                      )
                                      .toList(),
                                ),
                                SizedBox(height: AppSizes.spaceM16.h),
                                TextField(
                                  controller: _balanceController,
                                  decoration: const InputDecoration(labelText: 'Initial balance'),
                                  keyboardType: TextInputType.number,
                                  onChanged: (v) => cubit.setBalance(int.tryParse(v) ?? 0),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(AppSizes.paddingM.h),
                          child: SafeArea(
                            top: false,
                            child: WButton(
                              onTap: cubit.submit,
                              text: 'Save',
                              isDisabled: state.name.isEmpty || state.status.isLoading(),
                              isLoading: state.status.isLoading(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
