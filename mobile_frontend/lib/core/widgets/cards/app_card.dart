import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';

/// Universal card component that can be used across the entire app
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.elevation,
    this.shadowColor,
    this.borderWidth,
    this.isSelected = false,
    this.showBorder = false,
  });

  final Widget child;
  final String? title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderRadius;
  final double? elevation;
  final Color? shadowColor;
  final double? borderWidth;
  final bool isSelected;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    final effectivePadding = padding ?? EdgeInsets.all(AppSizes.paddingM.w);
    final effectiveMargin = margin ?? EdgeInsets.only(bottom: AppSizes.spaceM16.h);
    final effectiveBackgroundColor = backgroundColor ?? AppColors.surface;
    final effectiveBorderRadius = borderRadius ?? AppSizes.borderSM16;
    final effectiveBorderColor = borderColor ?? 
        (isSelected ? Theme.of(context).primaryColor : AppColors.def);
    final effectiveElevation = elevation ?? (isSelected ? 4 : 2);
    final effectiveShadowColor = shadowColor ?? AppColors.textPrimary.withValues(alpha: 0.1);

    Widget cardContent = Container(
      padding: effectivePadding,
      margin: effectiveMargin,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        border: showBorder || isSelected
            ? Border.all(
                color: effectiveBorderColor,
                width: borderWidth ?? (isSelected ? 2 : 1),
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: effectiveShadowColor,
            blurRadius: effectiveElevation,
            offset: Offset(0, effectiveElevation / 2),
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null || onLongPress != null) {
      cardContent = GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: cardContent,
      );
    }

    return cardContent;
  }
}

/// Specialized list item card
class AppListItemCard extends StatelessWidget {
  const AppListItemCard({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.elevation,
    this.isSelected = false,
    this.showDivider = false,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final double? borderRadius;
  final double? elevation;
  final bool isSelected;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      onLongPress: onLongPress,
      padding: padding ?? EdgeInsets.symmetric(
        horizontal: AppSizes.paddingM.w,
        vertical: AppSizes.spaceM16.h,
      ),
      margin: margin,
      backgroundColor: backgroundColor,
      borderRadius: borderRadius,
      elevation: elevation,
      isSelected: isSelected,
      child: Column(
        children: [
          Row(
            children: [
              if (leading != null) ...[
                leading!,
                SizedBox(width: AppSizes.spaceM16.w),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: AppSizes.textSize16,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (subtitle != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          subtitle!,
                          style: const TextStyle(
                            fontSize: AppSizes.textSize14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (trailing != null) ...[
                SizedBox(width: AppSizes.spaceM16.w),
                trailing!,
              ],
            ],
          ),
          if (showDivider)
            Padding(
              padding: EdgeInsets.only(top: 12),
              child: Divider(
                color: AppColors.def,
                height: 1,
              ),
            ),
        ],
      ),
    );
  }
}

/// Specialized info card for displaying key-value pairs
class AppInfoCard extends StatelessWidget {
  const AppInfoCard({
    super.key,
    required this.items,
    this.title,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.elevation,
    this.showDividers = true,
  });

  final List<AppInfoItem> items;
  final String? title;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final double? borderRadius;
  final double? elevation;
  final bool showDividers;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: padding,
      margin: margin,
      backgroundColor: backgroundColor,
      borderRadius: borderRadius,
      elevation: elevation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: const TextStyle(
                fontSize: AppSizes.textSize18,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: AppSizes.spaceM16.h),
          ],
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isLast = index == items.length - 1;
            
            return Column(
              children: [
                _buildInfoItem(item),
                if (showDividers && !isLast)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSizes.spaceS12.h),
                    child: Divider(
                      color: AppColors.def,
                      height: 1,
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildInfoItem(AppInfoItem item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: item.labelFlex ?? 2,
          child: Text(
            item.label,
            style: const TextStyle(
              fontSize: AppSizes.textSize14,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(width: AppSizes.spaceM16.w),
        Expanded(
          flex: item.valueFlex ?? 3,
          child: item.value,
        ),
      ],
    );
  }
}

class AppInfoItem {
  final String label;
  final Widget value;
  final int? labelFlex;
  final int? valueFlex;

  const AppInfoItem({
    required this.label,
    required this.value,
    this.labelFlex,
    this.valueFlex,
  });
}

/// Specialized stat card for displaying metrics
class AppStatCard extends StatelessWidget {
  const AppStatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.color,
    this.onTap,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.elevation,
  });

  final String title;
  final String value;
  final String? subtitle;
  final Widget? icon;
  final Color? color;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final double? borderRadius;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Theme.of(context).primaryColor;
    
    return AppCard(
      onTap: onTap,
      padding: padding ?? EdgeInsets.all(AppSizes.paddingM.w),
      margin: margin,
      backgroundColor: backgroundColor,
      borderRadius: borderRadius,
      elevation: elevation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                icon!,
                SizedBox(width: AppSizes.spaceS12.w),
              ],
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: AppSizes.textSize14,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.spaceS12.h),
          Text(
            value,
            style: TextStyle(
              fontSize: AppSizes.textSize24,
              color: effectiveColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                subtitle!,
                style: const TextStyle(
                  fontSize: AppSizes.textSize12,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Specialized empty state card
class AppEmptyStateCard extends StatelessWidget {
  const AppEmptyStateCard({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.action,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
  });

  final String title;
  final String? subtitle;
  final Widget? icon;
  final Widget? action;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: padding ?? EdgeInsets.all(AppSizes.paddingL.w),
      margin: margin,
      backgroundColor: backgroundColor,
      borderRadius: borderRadius,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            icon!,
            SizedBox(height: AppSizes.spaceM16.h),
          ],
          Text(
            title,
            style: const TextStyle(
              fontSize: AppSizes.textSize18,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          if (subtitle != null) ...[
            SizedBox(height: AppSizes.spaceS12.h),
            Text(
              subtitle!,
              style: const TextStyle(
                fontSize: AppSizes.textSize14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (action != null) ...[
            SizedBox(height: AppSizes.spaceM16.h),
            action!,
          ],
        ],
      ),
    );
  }
}
