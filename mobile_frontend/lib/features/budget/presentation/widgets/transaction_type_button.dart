import 'package:flutter/material.dart';

class TransactionTypeButton extends StatelessWidget {
  final String title;
  final Color titleColor;
  final Color selectedTitleColor;
  final Color boxColor;
  final Color? selectedBoxColor;
  final Color? boxBorderColor;
  final Color? selectedBoxBorderColor;
  final bool selected;
  final VoidCallbackAction onTap;

  const TransactionTypeButton({
    required this.title,
    required this.titleColor,
    required this.selectedTitleColor,
    required this.boxColor,
    this.selectedBoxColor,
    this.boxBorderColor,
    this.selectedBoxBorderColor,
    required this.selected,
    required this.onTap,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(

      ),
    );
  }
}


// Widget _typeButton(
//     BuildContext context,
//     TransactionCubit cubit,
//     TransactionType type,
//     String label,
//     ) {
//   final selected = cubit.state.type == type;
//   return Container(
//     child: GestureDetector(
//       onTap: () {
//         cubit.setType(type);
//         if (type == TransactionType.transfer) {
//           cubit.loadAccounts();
//         } else {
//           cubit.loadCategories();
//         }
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(
//           vertical: AppSizes.paddingS,
//           horizontal: AppSizes.paddingM,
//         ),
//         decoration: BoxDecoration(
//           color: selected ? AppColors.accent : AppColors.def.withOpacity(0.2),
//           borderRadius: BorderRadius.circular(AppSizes.borderMedium),
//           border: Border.all(
//             color: selected ? AppColors.accent : AppColors.def,
//             width: 0.5,
//           ),
//         ),
//         alignment: Alignment.center,
//         child: Text(
//           label,
//           style: AppTextStyles.bodyRegular.copyWith(
//             color: selected ? AppColors.surface : AppColors.textSecondary,
//           ),
//         ),
//       ),
//     ),
//   );
// }
