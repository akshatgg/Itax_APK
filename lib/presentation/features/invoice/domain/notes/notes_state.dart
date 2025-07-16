part of 'notes_bloc.dart';

sealed class NotesState extends Equatable {
  const NotesState({required this.notes});
  final List<NotesModel> notes;

  @override
  List<Object> get props => [];
}

final class NotesInitial extends NotesState {
  const NotesInitial({required super.notes});
}

final class NotesLoading extends NotesState {
  const NotesLoading({required super.notes});
}

final class NotesLoaded extends NotesState {
  const NotesLoaded({required super.notes});
}

final class NotesError extends NotesState {
  final String message;
  const NotesError({required super.notes, required this.message});
}
