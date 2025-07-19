import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/helpers/enums_helpers.dart';
import '../../domain/usecase/add_account.dart';
import '../../data/model/create_account_request.dart';

class AccountState extends Equatable {
  final String name;
  final int balance;
  final RequestStatus status;
  final String errorMessage;

  const AccountState({
    this.name = '',
    this.balance = 0,
    this.status = RequestStatus.initial,
    this.errorMessage = '',
  });

  AccountState copyWith({
    String? name,
    int? balance,
    RequestStatus? status,
    String? errorMessage,
  }) => AccountState(
        name: name ?? this.name,
        balance: balance ?? this.balance,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  @override
  List<Object?> get props => [name, balance, status, errorMessage];
}

class AccountCubit extends Cubit<AccountState> {
  final AddAccount _addAccount;
  AccountCubit(this._addAccount) : super(const AccountState());

  void setName(String v) => emit(state.copyWith(name: v));
  void setBalance(int v) => emit(state.copyWith(balance: v));

  Future<void> submit() async {
    emit(state.copyWith(status: RequestStatus.loading));
    final request = CreateAccountRequest(
      accountName: state.name,
      initialBalance: state.balance,
    );
    final result = await _addAccount(AddAccountParams(request));
    result.fold(
      (l) => emit(state.copyWith(status: RequestStatus.error, errorMessage: l.errorMessage)),
      (_) => emit(state.copyWith(status: RequestStatus.loaded)),
    );
  }
}
