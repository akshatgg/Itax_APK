import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/enums/invoice_type.dart';
import '../../../../../core/constants/strings_constants.dart';
import '../../../../../core/data/apis/models/invoice/notes_model.dart';
import '../../../../../core/data/repos/company_repo.dart';
import '../../../../../core/data/repos/dashboard_data_repo.dart';
import '../../../../../core/data/repos/day_book_repo.dart';
import '../../../../../core/data/repos/invoice_repo.dart';
import '../../../../../core/data/repos/notes_repo.dart';
import '../../../../../core/data/repos/parties_repo.dart';
import '../../../../../core/utils/id_generator.dart';
import '../../../../../core/utils/list_extenstion.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NotesRepo notesRepo;
  final PartiesRepo partyRepo;
  final InvoiceRepo invoiceRepo;
  final CompanyRepo companyRepo;
  final DayBookRepo dayBookRepo;
  final DashboardDataRepo dashboardDataRepo;

  List<NotesModel> get notes => notesRepo.notes;

  Map<String, NotesModel> get idWiseNotes => notesRepo.idWiseNotes;

  Map<String, List<NotesModel>> get partyWiseNotes => notesRepo.partyWiseNotes;

  Map<InvoiceType, List<NotesModel>> get typeWiseNotes =>
      notesRepo.typeWiseNotes;

  int get lastNoteNumber => notesRepo.lastNoteNumber;

  Map<InvoiceType, double> get typeWiseAmounts => notesRepo.typeWiseAmounts;

  NotesBloc({
    required this.notesRepo,
    required this.partyRepo,
    required this.invoiceRepo,
    required this.companyRepo,
    required this.dayBookRepo,
    required this.dashboardDataRepo,
  }) : super(const NotesInitial(notes: [])) {
    on<GetAllNotes>(_onGetAllNotes);
    on<CreateNote>(_onCreateNote);
    on<UpdateNote>(_onUpdateNote);
    on<OnNotesUpdated>(_onNotesUpdated);
    on<DeleteNote>(_onDeleteNote);

    _subscription = notesRepo.notesStream.listen((_) {
      add(const OnNotesUpdated());
    });
  }

  late StreamSubscription<void> _subscription;

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }

  void _onNotesUpdated(
    OnNotesUpdated event,
    Emitter<NotesState> emit,
  ) {
    emit(NotesLoaded(notes: notesRepo.notes));
  }

  void _onGetAllNotes(GetAllNotes event, Emitter<NotesState> emit) async {
    try {
      emit(NotesLoading(notes: state.notes));
      final notes = await notesRepo.getAllNotes();
      emit(NotesLoaded(notes: notes));
    } catch (e) {
      emit(NotesError(notes: state.notes, message: e.toString()));
    }
  }

  void _onDeleteNote(DeleteNote event, Emitter<NotesState> emit) async {
    try {
      emit(NotesLoading(notes: state.notes));
      final note = state.notes.firstWhere((e) => e.id == event.noteId);
      final isDone = await notesRepo.deleteNote(note.id);
      if (!isDone) {
        emit(NotesError(
            notes: state.notes, message: AppStrings.failedToDeleteNotes));
        return;
      }
      await partyRepo.onNoteDeleted(note);
      await invoiceRepo.onNoteDeleted(note);
      await dashboardDataRepo.onNoteDeleted(note);
      emit(NotesLoaded(notes: state.notes));
    } catch (e) {
      emit(NotesError(notes: state.notes, message: e.toString()));
    }
  }

  void _onCreateNote(CreateNote event, Emitter<NotesState> emit) async {
    try {
      emit(NotesLoading(notes: state.notes));
      var invoice = invoiceRepo.idWiseInvoices[event.note.selectedInvoiceId];
      if (invoice == null) {
        emit(NotesError(
            notes: state.notes, message: AppStrings.notFoundInvoice));
        return;
      }
      var party = partyRepo.idWiseParties[event.note.partyId];
      if (party == null) {
        emit(NotesError(notes: state.notes, message: AppStrings.notFoundParty));
        return;
      }
      final note = event.note.copyWith(
        id: generateId(),
        companyId: companyRepo.currentCompany!.id,
      );
      final isDone = await notesRepo.createNote(note);
      if (!isDone) {
        emit(NotesError(
            notes: state.notes, message: AppStrings.failedToCreateNotes));
        return;
      }
      final notes = await notesRepo.getAllNotes();
      await partyRepo.onNoteCreated(note);
      await invoiceRepo.onNoteCreated(note);
      await dayBookRepo.onNoteCreated(note);
      await dashboardDataRepo.onNoteAdded(note);
      emit(NotesLoaded(notes: notes));
    } catch (e) {
      emit(NotesError(notes: state.notes, message: e.toString()));
    }
  }

  void _onUpdateNote(UpdateNote event, Emitter<NotesState> emit) async {
    try {
      emit(NotesLoading(notes: state.notes));
      final note = event.note.copyWith(
        companyId: companyRepo.currentCompany!.id,
      );
      final previous =
          notesRepo.notes.firstWhereOrNull((element) => element.id == note.id);
      if (previous == null) {
        emit(NotesError(notes: state.notes, message: AppStrings.noteNotFound));
        return;
      }
      final isDone = await notesRepo.updateNote(note);
      if (!isDone) {
        emit(NotesError(notes: state.notes, message: AppStrings.noteUpdate));
        return;
      }
      await partyRepo.onNoteUpdated(previous, note);
      await invoiceRepo.onNoteUpdated(previous, note);
      await dashboardDataRepo.onNoteUpdated(previous, note);
      final notes = await notesRepo.getAllNotes();
      emit(NotesLoaded(notes: notes));
    } catch (e) {
      emit(NotesError(notes: state.notes, message: e.toString()));
    }
  }
}
