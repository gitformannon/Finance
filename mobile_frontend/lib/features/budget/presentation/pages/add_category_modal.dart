import 'package:Finance/core/constants/app_colors.dart';
import 'package:Finance/core/constants/app_sizes.dart';
import 'package:Finance/core/di/get_it.dart';
import 'package:Finance/core/themes/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../cubit/category_cubit.dart';
import '../../../../core/helpers/enums_helpers.dart';
import '../../../shared/presentation/widgets/app_buttons/w_button.dart';

class AddCategoryModal extends StatefulWidget {
  final CategoryType? type;
  const AddCategoryModal({
    this.type,
    super.key
  });

  @override
  State<AddCategoryModal> createState() => _AddCategoryModalState();
}

class _AddCategoryModalState extends State<AddCategoryModal> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = getItInstance<CategoryCubit>();
        if (widget.type != null) cubit.setType(widget.type!);
        return cubit;
      },
      child: BlocConsumer<CategoryCubit, CategoryState>(
        listener: (context, state) {
          if (state.status.isLoaded()) {
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          final cubit = context.read<CategoryCubit>();
          return Scaffold(
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
                    SingleChildScrollView(
                      padding: EdgeInsets.all(AppSizes.paddingM.h),
                      child: Column(
                        children: [
                          if (widget.type == null) ...[
                            Row(
                              children: [
                                _typeButton(context, cubit, CategoryType.income, 'Income'),
                                SizedBox(width: AppSizes.spaceXS8.w),
                                _typeButton(context, cubit, CategoryType.purchase, 'Purchase'),
                              ],
                            ),
                            SizedBox(height: AppSizes.spaceM16.h),
                          ],
                          TextField(
                            controller: _nameController,
                            decoration: const InputDecoration(labelText: 'Name'),
                            onChanged: cubit.setName,
                          ),
                        ],
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
          );
        },
      ),
    );
  }

  Widget _typeButton(BuildContext context, CategoryCubit cubit, CategoryType type, String label) {
    final selected = cubit.state.type == type;
    return GestureDetector(
      onTap: () => cubit.setType(type),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingS, horizontal: AppSizes.paddingM),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.secondary,
          border: const Border(
            bottom: BorderSide(color: AppColors.def, width: 0.5),
          ),
          borderRadius: BorderRadius.circular(AppSizes.borderMedium),
          boxShadow: [
            BoxShadow(
              color: !selected ? AppColors.transparent : AppColors.primary,
              blurRadius: !selected ? 0 : 5,
              spreadRadius: !selected ? 0.1 : 0,
              blurStyle: BlurStyle.outer,
              offset: const Offset(0, 0),
            )
          ],
        ),
        alignment: Alignment.center,
        child: Text(label, style: AppTextStyles.bodyRegular),
      ),
    );
  }
}
