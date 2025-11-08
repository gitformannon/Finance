import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../cards/app_card.dart';

/// Universal list component that can be used across the entire app
class AppList extends StatelessWidget {
  const AppList({
    super.key,
    required this.items,
    this.itemBuilder,
    this.separatorBuilder,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
    this.primary,
    this.reverse = false,
    this.controller,
    this.onRefresh,
    this.isLoading = false,
    this.emptyWidget,
    this.loadingWidget,
    this.errorWidget,
    this.hasError = false,
    this.errorMessage,
  });

  final List<dynamic> items;
  final Widget Function(BuildContext context, int index, dynamic item)? itemBuilder;
  final Widget Function(BuildContext context, int index)? separatorBuilder;
  final EdgeInsets? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final bool? primary;
  final bool reverse;
  final ScrollController? controller;
  final Future<void> Function()? onRefresh;
  final bool isLoading;
  final Widget? emptyWidget;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final bool hasError;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return loadingWidget ?? const _DefaultLoadingWidget();
    }

    if (hasError) {
      return errorWidget ?? _DefaultErrorWidget(message: errorMessage);
    }

    if (items.isEmpty) {
      return emptyWidget ?? const _DefaultEmptyWidget();
    }

    Widget listView = ListView.separated(
      controller: controller,
      padding: padding ?? EdgeInsets.all(AppSizes.paddingM.w),
      physics: physics ?? const BouncingScrollPhysics(),
      shrinkWrap: shrinkWrap,
      primary: primary,
      reverse: reverse,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return itemBuilder?.call(context, index, item) ?? 
            _DefaultListItem(item: item);
      },
      separatorBuilder: separatorBuilder ?? 
          (context, index) => SizedBox(height: AppSizes.spaceM16.h),
    );

    if (onRefresh != null) {
      listView = RefreshIndicator(
        onRefresh: onRefresh!,
        child: listView,
      );
    }

    return listView;
  }
}

/// Specialized grid list component
class AppGridList extends StatelessWidget {
  const AppGridList({
    super.key,
    required this.items,
    required this.crossAxisCount,
    this.itemBuilder,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
    this.primary,
    this.reverse = false,
    this.controller,
    this.onRefresh,
    this.isLoading = false,
    this.emptyWidget,
    this.loadingWidget,
    this.errorWidget,
    this.hasError = false,
    this.errorMessage,
    this.crossAxisSpacing,
    this.mainAxisSpacing,
    this.childAspectRatio,
  });

  final List<dynamic> items;
  final int crossAxisCount;
  final Widget Function(BuildContext context, int index, dynamic item)? itemBuilder;
  final EdgeInsets? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final bool? primary;
  final bool reverse;
  final ScrollController? controller;
  final Future<void> Function()? onRefresh;
  final bool isLoading;
  final Widget? emptyWidget;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final bool hasError;
  final String? errorMessage;
  final double? crossAxisSpacing;
  final double? mainAxisSpacing;
  final double? childAspectRatio;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return loadingWidget ?? const _DefaultLoadingWidget();
    }

    if (hasError) {
      return errorWidget ?? _DefaultErrorWidget(message: errorMessage);
    }

    if (items.isEmpty) {
      return emptyWidget ?? const _DefaultEmptyWidget();
    }

    Widget gridView = GridView.builder(
      controller: controller,
      padding: padding ?? EdgeInsets.all(AppSizes.paddingM.w),
      physics: physics ?? const BouncingScrollPhysics(),
      shrinkWrap: shrinkWrap,
      primary: primary,
      reverse: reverse,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: crossAxisSpacing ?? AppSizes.spaceM16.w,
        mainAxisSpacing: mainAxisSpacing ?? AppSizes.spaceM16.h,
        childAspectRatio: childAspectRatio ?? 1.0,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return itemBuilder?.call(context, index, item) ?? 
            _DefaultGridItem(item: item);
      },
    );

    if (onRefresh != null) {
      gridView = RefreshIndicator(
        onRefresh: onRefresh!,
        child: gridView,
      );
    }

    return gridView;
  }
}

/// Specialized sectioned list component
class AppSectionedList extends StatelessWidget {
  const AppSectionedList({
    super.key,
    required this.sections,
    this.sectionHeaderBuilder,
    this.itemBuilder,
    this.separatorBuilder,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
    this.primary,
    this.reverse = false,
    this.controller,
    this.onRefresh,
    this.isLoading = false,
    this.emptyWidget,
    this.loadingWidget,
    this.errorWidget,
    this.hasError = false,
    this.errorMessage,
  });

  final List<AppListSection> sections;
  final Widget Function(BuildContext context, int sectionIndex, AppListSection section)? sectionHeaderBuilder;
  final Widget Function(BuildContext context, int sectionIndex, int itemIndex, dynamic item)? itemBuilder;
  final Widget Function(BuildContext context, int sectionIndex, int itemIndex)? separatorBuilder;
  final EdgeInsets? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final bool? primary;
  final bool reverse;
  final ScrollController? controller;
  final Future<void> Function()? onRefresh;
  final bool isLoading;
  final Widget? emptyWidget;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final bool hasError;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return loadingWidget ?? const _DefaultLoadingWidget();
    }

    if (hasError) {
      return errorWidget ?? _DefaultErrorWidget(message: errorMessage);
    }

    if (sections.isEmpty || sections.every((section) => section.items.isEmpty)) {
      return emptyWidget ?? const _DefaultEmptyWidget();
    }

    Widget listView = ListView.builder(
      controller: controller,
      padding: padding ?? EdgeInsets.all(AppSizes.paddingM.w),
      physics: physics ?? const BouncingScrollPhysics(),
      shrinkWrap: shrinkWrap,
      primary: primary,
      reverse: reverse,
      itemCount: _getTotalItemCount(),
      itemBuilder: (context, index) {
        final sectionIndex = _getSectionIndex(index);
        final itemIndex = _getItemIndex(index, sectionIndex);
        
        if (itemIndex == -1) {
          // This is a section header
          final section = sections[sectionIndex];
          return sectionHeaderBuilder?.call(context, sectionIndex, section) ?? 
              _DefaultSectionHeader(section: section);
        } else {
          // This is a list item
          final section = sections[sectionIndex];
          final item = section.items[itemIndex];
          return itemBuilder?.call(context, sectionIndex, itemIndex, item) ?? 
              _DefaultListItem(item: item);
        }
      },
    );

    if (onRefresh != null) {
      listView = RefreshIndicator(
        onRefresh: onRefresh!,
        child: listView,
      );
    }

    return listView;
  }

  int _getTotalItemCount() {
    int count = 0;
    for (final section in sections) {
      count += 1; // Section header
      count += section.items.length; // Items
    }
    return count;
  }

  int _getSectionIndex(int index) {
    int currentIndex = 0;
    for (int i = 0; i < sections.length; i++) {
      if (currentIndex == index) return i;
      currentIndex++; // Section header
      currentIndex += sections[i].items.length; // Items
      if (currentIndex > index) return i;
    }
    return sections.length - 1;
  }

  int _getItemIndex(int index, int sectionIndex) {
    int currentIndex = 0;
    for (int i = 0; i < sectionIndex; i++) {
      currentIndex++; // Section header
      currentIndex += sections[i].items.length; // Items
    }
    
    if (currentIndex == index) return -1; // This is a section header
    
    currentIndex++; // Skip section header
    final itemIndex = index - currentIndex;
    return itemIndex >= 0 && itemIndex < sections[sectionIndex].items.length 
        ? itemIndex 
        : -1;
  }
}

class AppListSection {
  final String title;
  final List<dynamic> items;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;

  const AppListSection({
    required this.title,
    required this.items,
    this.subtitle,
    this.leading,
    this.trailing,
  });
}

// Default widgets for different states
class _DefaultLoadingWidget extends StatelessWidget {
  const _DefaultLoadingWidget();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _DefaultErrorWidget extends StatelessWidget {
  const _DefaultErrorWidget({this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return AppEmptyStateCard(
      title: 'Something went wrong',
      subtitle: message ?? 'Please try again later',
      icon: const Icon(
        Icons.error_outline,
        size: 48,
        color: AppColors.error,
      ),
    );
  }
}

class _DefaultEmptyWidget extends StatelessWidget {
  const _DefaultEmptyWidget();

  @override
  Widget build(BuildContext context) {
    return AppEmptyStateCard(
      title: 'No items found',
      subtitle: 'There are no items to display at the moment',
      icon: const Icon(
        Icons.inbox_outlined,
        size: 48,
        color: AppColors.textSecondary,
      ),
    );
  }
}

class _DefaultListItem extends StatelessWidget {
  const _DefaultListItem({required this.item});

  final dynamic item;

  @override
  Widget build(BuildContext context) {
    return AppListItemCard(
      title: item.toString(),
      onTap: () {
        // Default tap behavior
      },
    );
  }
}

class _DefaultGridItem extends StatelessWidget {
  const _DefaultGridItem({required this.item});

  final dynamic item;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Center(
        child: Text(
          item.toString(),
          style: const TextStyle(
            fontSize: AppSizes.textSize16,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _DefaultSectionHeader extends StatelessWidget {
  const _DefaultSectionHeader({required this.section});

  final AppListSection section;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingM.w,
        vertical: AppSizes.spaceS12.h,
      ),
      child: Row(
        children: [
          if (section.leading != null) ...[
            section.leading!,
            SizedBox(width: AppSizes.spaceS12.w),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section.title,
                  style: const TextStyle(
                    fontSize: AppSizes.textSize18,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (section.subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      section.subtitle!,
                      style: const TextStyle(
                        fontSize: AppSizes.textSize14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (section.trailing != null) section.trailing!,
        ],
      ),
    );
  }
}
