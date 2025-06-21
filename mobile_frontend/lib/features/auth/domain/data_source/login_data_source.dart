import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:repo_annotation/repo_annotation.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/response_handler.dart';
import '../../../../core/network/server_error.dart';
import '../../data/model/request/login_user_request.dart';
import '../../data/model/response/login_user_response.dart';
part 'login_data_source.g.dart';

@subGen
mixin LoginDataSource {
  Future<ResponseHandler<LoginUserResponse>> loginUser(
      {required LoginUserRequest request});



}
