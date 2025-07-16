import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/data/repos/user_repo.dart';
import '../../../../core/utils/logger.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepo userRepo;

  UserBloc(this.userRepo) : super(UserInitialState()) {
    on<LoadUserEvent>(_onGetUser);
    on<UpdateUserEvent>(_onUpdateUser);
  }

  Future<void> _onGetUser(
    UserEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoadingState());
    try {
      final user = await userRepo.getUser();
      logger.d('=============${user?.businessName}');
      if (user != null) {
        emit(UserLoadedState(user));
      } else {
        emit(UserErrorState('No user found'));
      }
    } catch (e) {
      emit(UserErrorState('Error loading user'));
    }
  }

  Future<void> _onUpdateUser(
    UpdateUserEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserUpdatingState());
    try {
      final isUpdated = await userRepo.updateUser(event.user);
      if (isUpdated != null) {
        emit(UserLoadedState(isUpdated));
      } else {
        emit(UserErrorState('Failed to update user'));
      }
    } catch (e) {
      emit(UserErrorState('Error updating user: $e'));
    }
  }
}
