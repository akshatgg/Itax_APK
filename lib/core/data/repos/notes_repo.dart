import 'dart:async';

import '../../constants/enums/invoice_type.dart';
import '../../utils/get_it_instance.dart';
import '../apis/models/invoice/notes_model.dart';
import 'company_repo.dart';
import 'storage/notes_storage.dart';

class NotesRepo {
  final NotesStorage storageService;

  NotesRepo({
    required this.storageService,
  });

  final _notesStreamController = StreamController<void>.broadcast();

  Stream<void> get notesStream => _notesStreamController.stream;

  void notifyNotesUpdated() {
    _notesStreamController.add(null);
  }

  void dispose() {
    _notesStreamController.close();
  }

  String? errorMessage;
  final List<NotesModel> _notes = List.empty(growable: true);
  final Map<String, NotesModel> _idWiseNotes = {};
  final Map<String, List<NotesModel>> _partyWiseNotes = {};
  final Map<InvoiceType, List<NotesModel>> _typeWiseNotes = {};
  int _lastNoteNumber = 0;
  final Map<InvoiceType, double> _typeWiseAmounts = {};

  List<NotesModel> get notes => _notes;

  Map<String, NotesModel> get idWiseNotes => _idWiseNotes;

  Map<String, List<NotesModel>> get partyWiseNotes => _partyWiseNotes;

  Map<InvoiceType, List<NotesModel>> get typeWiseNotes => _typeWiseNotes;

  int get lastNoteNumber => _lastNoteNumber;

  Map<InvoiceType, double> get typeWiseAmounts => _typeWiseAmounts;

  Future<List<NotesModel>> getAllNotes({bool notify = false}) async {
    try {
      final notes = await storageService.getAllNotes(
        getIt.get<CompanyRepo>().currentCompany!.id,
      );
      _biffercateNotes(notes);
      if (notify) notifyNotesUpdated();
      return notes;
    } catch (e) {
      errorMessage = e.toString();
      return [];
    }
  }

  void _biffercateNotes(List<NotesModel> notes) {
    _notes.clear();
    _idWiseNotes.clear();
    _partyWiseNotes.clear();
    _typeWiseNotes.clear();
    _lastNoteNumber = 0;
    _typeWiseAmounts.clear();
    int max = 0;

    for (final note in notes) {
      if (note.invoiceNumber > max) {
        max = note.invoiceNumber;
      }
      _notes.add(note);
      _idWiseNotes[note.id] = note;
      _partyWiseNotes.putIfAbsent(note.partyId, () => []).add(note);
      _typeWiseNotes.putIfAbsent(note.type, () => []).add(note);
      _typeWiseAmounts[note.type] =
          _typeWiseAmounts[note.type] ?? 0 + note.totalAmount;
    }
    _lastNoteNumber = max;
  }

  Future<bool> createNote(NotesModel note) async {
    try {
      await storageService.createNote(note);
      await getAllNotes();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> updateNote(NotesModel note) async {
    try {
      await storageService.updateNote(note);
      await getAllNotes();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> deleteNote(String noteId) async {
    try {
      await storageService.deleteNote(noteId);
      await getAllNotes();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> clearAllNotes() async {
    try {
      await storageService.clearAllNotes();
      await getAllNotes();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }
}
