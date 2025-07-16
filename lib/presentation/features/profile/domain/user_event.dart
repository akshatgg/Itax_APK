import 'package:equatable/equatable.dart';

import '../../../../core/data/apis/models/shared/user_model.dart';

abstract class UserEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadUserEvent extends UserEvent {}

class UpdateUserEvent extends UserEvent {
  final UserModel user;

  UpdateUserEvent(this.user);

  @override
  List<Object?> get props => [user];
}
