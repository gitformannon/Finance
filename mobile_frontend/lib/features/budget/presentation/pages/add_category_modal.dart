import 'package:Finance/core/constants/app_colors.dart';
import 'package:Finance/core/constants/app_sizes.dart';
import 'package:Finance/core/di/get_it.dart';
import 'package:Finance/core/themes/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../cubit/category_cubit.dart';
import '../widgets/budget_input_field.dart';
import '../../../../core/helpers/enums_helpers.dart';
import '../../../shared/presentation/widgets/app_buttons/save_button.dart';
import '../../../shared/presentation/widgets/bottom_sheet_models/w_bottom_widget.dart';

class AddCategoryModal extends StatefulWidget {
  final CategoryType? type;
  const AddCategoryModal({this.type, super.key});

  static Future<T?> show<T>(
    BuildContext context, {
    CategoryType? type,
  }) {
    return _AddCategoryModalSheet(type).show<T>(context);
  }

  @override
  State<AddCategoryModal> createState() => _AddCategoryModalState();
}

class _AddCategoryModalSheet with BaseBottomSheet {
  _AddCategoryModalSheet(this._type);

  final CategoryType? _type;

  Future<T?> show<T>(BuildContext context) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: AppColors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      enableDrag: true,
      isDismissible: true,
      builder: (context) => BlocProvider(
        create: (_) {
          final cubit = getItInstance<CategoryCubit>();
          if (_type != null) cubit.setType(_type);
          return cubit;
        },
        child: AddCategoryModal(type: _type),
      ),
    );
  }
}

class _AddCategoryModalState extends State<AddCategoryModal> {
  final _nameController = TextEditingController();
  final _budgetController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoryCubit, CategoryState>(
      listener: (context, state) {
        if (state.status.isLoaded()) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        final cubit = context.read<CategoryCubit>();
        final media = MediaQuery.of(context);
        final viewInsets = media.viewInsets.bottom;
        final bottomPadding =
            viewInsets > 0 ? AppSizes.spaceM16 : media.padding.bottom;

        return Container(
          decoration: const BoxDecoration(
            color: AppColors.box,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppSizes.spaceM16),
              topRight: Radius.circular(AppSizes.spaceM16),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Divider
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: AppSizes.spaceS12),
                decoration: BoxDecoration(
                  color: AppColors.def.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              AnimatedPadding(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                padding: EdgeInsets.only(bottom: viewInsets),
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppColors.box, AppColors.box],
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: media.size.height * 0.8,
                        ),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSizes.paddingM.w,
                            vertical: AppSizes.spaceS12.h,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.type == null) ...[
                                Row(
                                  children: [
                                    _typeButton(
                                      context,
                                      cubit,
                                      CategoryType.income,
                                      'Income',
                                    ),
                                    SizedBox(width: AppSizes.spaceXS8.w),
                                    _typeButton(
                                      context,
                                      cubit,
                                      CategoryType.purchase,
                                      'Purchase',
                                    ),
                                  ],
                                ),
                                SizedBox(height: AppSizes.spaceM16.h),
                              ],
                              BudgetInputField(
                                label: 'Name',
                                controller: _nameController,
                                onChanged: cubit.setName,
                              ),
                              SizedBox(height: AppSizes.spaceM16.h),
                              if ((widget.type ?? cubit.state.type) ==
                                  CategoryType.purchase)
                                BudgetInputField(
                                  label: 'Monthly budget (UZS)',
                                  controller: _budgetController,
                                  keyboardType: TextInputType.number,
                                  onChanged: (v) => cubit.setBudget(int.tryParse(v)),
                                ),
                              SizedBox(height: AppSizes.spaceM16.h),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: AppSizes.paddingM.w,
                          right: AppSizes.paddingM.w,
                          bottom: bottomPadding,
                          top: AppSizes.spaceS12.h,
                        ),
                        child: SaveButton(
                          onPressed: cubit.submit,
                          isDisabled:
                              state.name.isEmpty || state.status.isLoading(),
                          isLoading: state.status.isLoading(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _typeButton(
    BuildContext context,
    CategoryCubit cubit,
    CategoryType type,
    String label,
  ) {
    final selected = cubit.state.type == type;
    return GestureDetector(
      onTap: () => cubit.setType(type),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSizes.paddingS,
          horizontal: AppSizes.paddingM,
        ),
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
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(label, style: AppTextStyles.bodyRegular),
      ),
    );
  }
}
