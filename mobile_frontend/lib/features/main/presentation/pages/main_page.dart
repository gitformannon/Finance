import 'package:Finance/features/main/cubits/main/main_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../profile/presentation/cubit/profile_cubit.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../budget/presentation/pages/budget_page.dart';
import '../../../goals/presentation/pages/goals_page.dart';
import '../../../goals/presentation/cubit/goals_cubit.dart';
import '../../../budget/presentation/pages/accounts_page.dart';
import '../../../budget/presentation/cubit/accounts_list_cubit.dart';
import '../../../budget/domain/usecase/get_accounts.dart';
import '../../../../core/di/get_it.dart';
import '../../../budget/presentation/cubit/budget_cubit.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../shared/presentation/widgets/navbar/curved_bottom_navbar.dart';


class MainPage extends StatefulWidget {
  final int initialPage;

  const MainPage({super.key, this.initialPage = 0});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateState(widget.initialPage);
    });
  }

  _updateState(int index) {
    context.read<MainCubit>().onTabChange(index);
  }

  void setPageIndex(int index) {
    _updateState(index);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, MainState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.transparent,
          extendBody: true,
          body: IndexedStack(
            index: state.currentIndex,
            children: [
              BlocProvider.value(
                value: context.read<ProfileCubit>(),
                child: const HomePage(),
              ),
              BlocProvider(
                create: (_) => getItInstance<BudgetCubit>()..load(DateTime.now()),
                child: const BudgetPage(),
              ),
              BlocProvider(
                create: (_) => getItInstance<GoalsCubit>()..load(),
                child: const GoalsPage(),
              ),
              BlocProvider(
                create: (_) => AccountsListCubit(getItInstance<GetAccounts>())..load(),
                child: const AccountsPage(),
              ),
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
              BottomNavigationBarItem(
                icon: Icon(Icons.task_outlined),
                activeIcon: Icon(Icons.task),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.space_dashboard_outlined),
                activeIcon: Icon(Icons.space_dashboard),
                label: '',
              ),
            ],
          ),
        );
      },
    );
  }
}
