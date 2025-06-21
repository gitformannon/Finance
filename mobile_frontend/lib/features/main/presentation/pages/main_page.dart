import 'package:Finance/core/constants/time_delay.dart';
import 'package:Finance/features/main/cubits/main/main_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';

class MainPage extends StatefulWidget {
  final int initialPage;

  const MainPage({super.key, this.initialPage = 0});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  PageController pageController = PageController(initialPage: 0);

  _animateToPage(int index) {
    pageController.animateToPage(
      index,
      duration: TimeDelays.short,
      curve: Curves.easeInOut,
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
          body: PopScope(
            canPop: false,
            onPopInvoked: (value) {
              // cubit.doYouWannaExitApp();
            },
            child: PageView(
              controller: pageController,
              children: [Container(), Container()],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: AppColors.surface,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.add),
                label: "Mijozlar",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add),
                label: "Mijozlar",
              ),
            ],
            currentIndex: state.currentIndex,
            selectedItemColor: Colors.purple,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            onTap: setPageIndex,
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 12,
            unselectedFontSize: 12,
          ),
        );
      },
    );
  }
}
