import 'package:equatable/equatable.dart';
import '../../../../core/helpers/enums_helpers.dart';
import '../../data/model/profile_response.dart';

class ProfileState extends Equatable {
  final RequestStatus status;
  final ProfileResponse? profile;
  final String errorMessage;

  const ProfileState({
    this.status = RequestStatus.initial,
    this.profile,
    this.errorMessage = '',
  });

  ProfileState copyWith({
    RequestStatus? status,
    ProfileResponse? profile,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, profile, errorMessage];
}
