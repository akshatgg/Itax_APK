part of 'notes_bloc.dart';

sealed class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object> get props => [];
}

class GetAllNotes extends NotesEvent {
  const GetAllNotes();

  @override
  List<Object> get props => [];
}

class CreateNote extends NotesEvent {
  final NotesModel note;
  const CreateNote({required this.note});

  @override
  List<Object> get props => [note];
}

class UpdateNote extends NotesEvent {
  final NotesModel note;
  const UpdateNote({required this.note});

  @override
  List<Object> get props => [note];
}

class OnNotesUpdated extends NotesEvent {
  const OnNotesUpdated();
}

class DeleteNote extends NotesEvent {
  final String noteId;
  const DeleteNote({required this.noteId});

  @override
  List<Object> get props => [noteId];
}
