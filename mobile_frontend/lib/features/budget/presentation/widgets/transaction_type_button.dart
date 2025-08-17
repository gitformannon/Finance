import 'package:Finance/core/constants/app_sizes.dart';
import 'package:Finance/core/themes/app_text_styles.dart';
import 'package:flutter/material.dart';

class TransactionTypeButton extends StatelessWidget {
  final String title;
  final Color titleColor;
  final Color selectedTitleColor;
  final Color boxColor;
  final Color selectedBoxColor;
  final Color boxBorderColor;
  final Color selectedBoxBorderColor;
  final bool selected;
  final VoidCallback onTap;

  const TransactionTypeButton({
    required this.title,
    required this.titleColor,
    required this.selectedTitleColor,
    required this.boxColor,
    required this.selectedBoxColor,
    required this.boxBorderColor,
    required this.selectedBoxBorderColor,
    required this.selected,
    required this.onTap,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
        vertical: AppSizes.paddingS,
        horizontal: AppSizes.paddingM,
        ),
        decoration: BoxDecoration(
          color: selected ? selectedBoxColor : boxColor,
          borderRadius: BorderRadius.circular(AppSizes.borderMedium),
          border: Border.all(
            color: selected ? selectedBoxBorderColor : boxBorderColor,
            width: 0.5
          )
        ),
        child: Text(
          title,
          style: AppTextStyles.bodyRegular.copyWith(
            color: selected ? selectedTitleColor : titleColor,
          ),
        ),

      ),
    );
  }
}




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
