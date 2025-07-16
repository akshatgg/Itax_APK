import 'package:equatable/equatable.dart';

import '../../../../core/data/apis/models/shared/user_model.dart';

abstract class UserState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserInitialState extends UserState {}

class UserLoadingState extends UserState {}

class UserLoadedState extends UserState {
  final UserModel user;

  UserLoadedState(this.user);

  @override
  List<Object?> get props => [user];
}

class UserErrorState extends UserState {
  final String message;

  UserErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class UserUpdatingState extends UserState {}

class UserUpdatedState extends UserState {
  final UserModel user;

  UserUpdatedState(this.user);

  @override
  List<Object?> get props => [user];
}
