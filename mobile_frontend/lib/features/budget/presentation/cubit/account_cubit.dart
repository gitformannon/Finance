import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/helpers/enums_helpers.dart';
import '../../domain/usecase/add_account.dart';
import '../../data/model/create_account_request.dart';

class AccountState extends Equatable {
  final String name;
  final String number;
  final int? type;
  final int balance;
  final RequestStatus status;
  final String errorMessage;

  const AccountState({
    this.name = '',
    this.number = '',
    this.type,
    this.balance = 0,
    this.status = RequestStatus.initial,
    this.errorMessage = '',
  });

  AccountState copyWith({
    String? name,
    String? number,
    int? type,
    int? balance,
    RequestStatus? status,
    String? errorMessage,
  }) => AccountState(
        name: name ?? this.name,
        number: number ?? this.number,
        type: type ?? this.type,
        balance: balance ?? this.balance,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  @override
  List<Object?> get props => [name, number, type, balance, status, errorMessage];
}

class AccountCubit extends Cubit<AccountState> {
  final AddAccount _addAccount;
  AccountCubit(this._addAccount) : super(const AccountState());

  void setName(String v) => emit(state.copyWith(name: v));
  void setNumber(String v) => emit(state.copyWith(number: v));
  void setType(int? v) => emit(state.copyWith(type: v));
  void setBalance(int v) => emit(state.copyWith(balance: v));

  Future<void> submit() async {
    emit(state.copyWith(status: RequestStatus.loading));
    final request = CreateAccountRequest(
      accountName: state.name,
      accountNumber: state.number.isEmpty ? null : state.number,
      accountType: state.type,
      initialBalance: state.balance,
    );
    final result = await _addAccount(AddAccountParams(request));
    result.fold(
      (l) => emit(state.copyWith(status: RequestStatus.error, errorMessage: l.errorMessage)),
      (_) => emit(state.copyWith(status: RequestStatus.loaded)),
    );
  }
}
