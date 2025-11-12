import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/helpers/enums_helpers.dart';
import '../../domain/usecase/add_account.dart';
import '../../data/model/create_account_request.dart';

class AccountState extends Equatable {
  final String name;
  final String number;
  final String institution;
  final int? type;
  final int balance;
  final String? emoji_path;
  final RequestStatus status;
  final String errorMessage;

  const AccountState({
    this.name = '',
    this.number = '',
    this.institution = '',
    this.type,
    this.balance = 0,
    this.emoji_path,
    this.status = RequestStatus.initial,
    this.errorMessage = '',
  });

  AccountState copyWith({
    String? name,
    String? number,
    String? institution,
    int? type,
    int? balance,
    String? emoji_path,
    RequestStatus? status,
    String? errorMessage,
  }) => AccountState(
        name: name ?? this.name,
        number: number ?? this.number,
        institution: institution ?? this.institution,
        type: type ?? this.type,
        balance: balance ?? this.balance,
        emoji_path: emoji_path ?? this.emoji_path,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  @override
  List<Object?> get props => [name, number, institution, type, balance, emoji_path, status, errorMessage];
}

class AccountCubit extends Cubit<AccountState> {
  final AddAccount _addAccount;
  AccountCubit(this._addAccount) : super(const AccountState());

  void setName(String v) => emit(state.copyWith(name: v));
  void setNumber(String v) => emit(state.copyWith(number: v));
  void setInstitution(String v) => emit(state.copyWith(institution: v));
  void setType(int? v) => emit(state.copyWith(type: v));
  void setBalance(int v) => emit(state.copyWith(balance: v));
  void setEmojiPath(String? v) => emit(state.copyWith(emoji_path: v));

  Future<void> submit() async {
    emit(state.copyWith(status: RequestStatus.loading));
    final request = CreateAccountRequest(
      accountName: state.name,
      accountNumber: state.number.isEmpty ? null : state.number,
      accountType: state.type,
      initialBalance: state.balance,
      institution: state.institution.isEmpty ? null : state.institution,
      emoji_path: state.emoji_path,
    );
    final result = await _addAccount(AddAccountParams(request));
    result.fold(
      (l) => emit(state.copyWith(status: RequestStatus.error, errorMessage: l.errorMessage)),
      (_) => emit(state.copyWith(status: RequestStatus.loaded)),
    );
  }
}
