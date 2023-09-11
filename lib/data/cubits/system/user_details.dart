// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:zestyrentals/data/model/user_model.dart';
import 'package:zestyrentals/utils/hive_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserDetailsCubit extends Cubit<UserDetailsState> {
  UserDetailsCubit()
      : super(UserDetailsState(user: HiveUtils.getUserDetails()));

  fill(UserModel model) {
    emit(UserDetailsState(user: model));
  }

  copy(UserModel model) {
    emit(state.copyWith(user: model));
  }

  // change() {}
}

class UserDetailsState {
  final UserModel user;
  UserDetailsState({
    required this.user,
  });

  UserDetailsState copyWith({
    UserModel? user,
  }) {
    return UserDetailsState(
      user: user ?? this.user,
    );
  }
}
