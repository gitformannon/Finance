import 'package:bloc/bloc.dart';
import 'package:Finance/core/network/no_params.dart';
import 'dart:io';

import '../../../../core/helpers/enums_helpers.dart';
import '../../../shared/presentation/cubits/navigate/navigate_cubit.dart';
import '../../domain/usecase/get_profile.dart';
import '../../domain/usecase/logout_user.dart';
import '../../domain/usecase/update_profile.dart';
import '../../domain/usecase/upload_profile_image.dart';
import '../../data/model/profile_response.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfile _getProfile;
  final LogoutUser _logoutUser;
  final UpdateProfile _updateProfile;
  final NavigateCubit _navigateCubit;
  final UploadProfileImage _uploadImage;

  ProfileCubit(this._getProfile, this._logoutUser, this._updateProfile, this._uploadImage, this._navigateCubit)
      : super(const ProfileState());

  Future<void> loadProfile() async {
    emit(state.copyWith(status: RequestStatus.loading));
    final result = await _getProfile(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(status: RequestStatus.error, errorMessage: failure.errorMessage),
      ),
      (profile) => emit(state.copyWith(status: RequestStatus.loaded, profile: profile)),
    );
  }

  Future<void> logout() async {
    await _logoutUser(const NoParams());
    _navigateCubit.goToLoginPage();
  }

  Future<void> updateName(String firstName, String lastName) async {
    emit(state.copyWith(status: RequestStatus.loading));
    final result = await _updateProfile(UpdateProfileParams(firstName: firstName, lastName: lastName));
    result.fold(
      (failure) => emit(state.copyWith(status: RequestStatus.error, errorMessage: failure.errorMessage)),
      (profile) => emit(state.copyWith(status: RequestStatus.loaded, profile: profile)),
    );
  }

  Future<void> uploadProfile(File file) async {
    emit(state.copyWith(status: RequestStatus.loading));
    final result = await _uploadImage(UploadProfileImageParams(file));
    result.fold(
      (failure) => emit(state.copyWith(status: RequestStatus.error, errorMessage: failure.errorMessage)),
      (profile) => emit(state.copyWith(status: RequestStatus.loaded, profile: profile)),
    );
  }
}
