import 'package:Finance/core/constants/locale_keys.dart';
import 'package:Finance/core/constants/time_delay.dart';
import 'package:Finance/features/main/cubits/main/main_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../profile/presentation/cubit/profile_cubit.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../../core/di/get_it.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

class MainPage extends StatefulWidget {
  final int initialPage;

  const MainPage({super.key, this.initialPage = 0});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late final PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.initialPage);
  }

  _animateToPage(int index) {
    pageController.animateToPage(
      index,
      duration: TimeDelays.medium,
      curve: Curves.fastEaseInToSlowEaseOut,
    );
  }

  _updateState(int index) {
    context.read<MainCubit>().onTabChange(index);
  }

  void setPageIndex(int index) {
    _updateState(index);
    _animateToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, MainState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: PopScope(
            canPop: false,
            onPopInvoked: (value) {
              // cubit.doYouWannaExitApp();
            },
            child: PageView(
              controller: pageController,
              children: [
                const HomePage(),
                Container(),
                BlocProvider(
                  create: (context) => getItInstance<ProfileCubit>(),
                  child: const ProfilePage(),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingS, vertical: AppSizes.paddingS),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(AppSizes.borderPageBottom), top: Radius.circular(AppSizes.borderMedium)),
              child: Theme(
                data: Theme.of(context).copyWith(
                  splashColor: AppColors.primary.withOpacity(0.2),
                  highlightColor: AppColors.primary.withOpacity(0.1),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    height: 72,
                    child: BottomNavigationBar(
                      backgroundColor: AppColors.textSecondary,
                      items: const <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                          icon: Align(
                            alignment: Alignment.bottomCenter,
                            child: Icon(Icons.home)
                          ),
                          label: ''
                        ),
                        BottomNavigationBarItem(
                          icon: Align(
                            alignment: Alignment.bottomCenter,
                            child: Icon(Icons.person)
                          ),
                          label: ''
                        ),
                      ],
                      currentIndex: state.currentIndex,
                      selectedItemColor: AppColors.primary,
                      unselectedItemColor: AppColors.def,
                      showSelectedLabels: false,
                      showUnselectedLabels: false,
                      onTap: setPageIndex,
                      type: BottomNavigationBarType.fixed,
                      iconSize: AppSizes.navbarIcon,
                      enableFeedback: false,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
