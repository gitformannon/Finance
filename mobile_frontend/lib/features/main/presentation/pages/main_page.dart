import 'package:Finance/core/constants/locale_keys.dart';
import 'package:Finance/core/constants/time_delay.dart';
import 'package:Finance/features/main/cubits/main/main_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../profile/presentation/cubit/profile_cubit.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../budget/presentation/pages/budget_page.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../shared/presentation/widgets/navbar/curved_bottom_navbar.dart';


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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateState(widget.initialPage);
    });
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
          body: IndexedStack(
            index: state.currentIndex,
            children: [
              BlocProvider.value(
                value: context.read<ProfileCubit>(),
                child: const HomePage(),
              ),
              const BudgetPage(),
            ],
          ),
          bottomNavigationBar: CurvedBottomNavbar(
            currentIndex: state.currentIndex,
            onTap: setPageIndex,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_wallet_outlined),
                activeIcon: Icon(Icons.account_balance_wallet),
                label: '',
              ),
            ],
          ),
        );
      },
    );
  }
}
