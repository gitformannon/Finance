import 'package:bloc/bloc.dart';
import '../../data/model/account.dart' as model;
import '../../domain/usecase/get_accounts.dart';
import '../../../../core/network/no_params.dart';

class AccountsListState {
  final List<model.Account> accounts;
  final bool loading;
  final String? error;
  const AccountsListState({this.accounts = const [], this.loading = false, this.error});

  AccountsListState copyWith({List<model.Account>? accounts, bool? loading, String? error}) =>
      AccountsListState(accounts: accounts ?? this.accounts, loading: loading ?? this.loading, error: error);
}

class AccountsListCubit extends Cubit<AccountsListState> {
  final GetAccounts _getAccounts;
  AccountsListCubit(this._getAccounts) : super(const AccountsListState());

  Future<void> load() async {
    emit(state.copyWith(loading: true, error: null));
    final res = await _getAccounts(const NoParams());
    res.fold(
      (l) => emit(state.copyWith(loading: false, error: l.errorMessage)),
      (r) => emit(AccountsListState(accounts: r, loading: false)),
    );
  }
}
