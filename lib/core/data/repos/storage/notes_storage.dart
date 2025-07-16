import 'package:hive/hive.dart';

import '../../../config/hive/hive_constants.dart';
import '../../../utils/logger.dart';
import '../../apis/models/invoice/notes_model.dart';

class NotesStorage {
  Future<Box<NotesModel>> _getBox() async {
    if (!Hive.isBoxOpen(HiveConstants.notesBox)) {
      return await Hive.openBox<NotesModel>(HiveConstants.notesBox);
    }
    return Hive.box<NotesModel>(HiveConstants.notesBox);
  }

  Future<List<NotesModel>> getAllNotes(String companyId) async {
    try {
      final box = await _getBox();
      return box.values.where((note) => note.companyId == companyId).toList();
    } catch (e) {
      return [];
    }
  }

  Future<NotesModel?> getNoteById(String id) async {
    try {
      final box = await _getBox();
      final model = box.values.firstWhere(
        (note) => note.id == id,
      );
      return model;
    } catch (e) {
      logger.d('Error getting note by id: $e');
      return null;
    }
  }

  Future<bool> createNote(NotesModel note) async {
    try {
      final box = await _getBox();
      await box.put(note.id, note);
      return true;
    } catch (e) {
      logger.d('Error creating note: $e');
      return false;
    }
  }

  Future<bool> updateNote(NotesModel updatedNote) async {
    try {
      final box = await _getBox();
      if (box.containsKey(updatedNote.id)) {
        await box.put(updatedNote.id, updatedNote);
        return true;
      }
      return false;
    } catch (e) {
      logger.d('Error updating note: $e');
      return false;
    }
  }

  Future<bool> deleteNote(String id) async {
    try {
      final box = await _getBox();
      if (box.containsKey(id)) {
        await box.delete(id);
        return true;
      }
      return false;
    } catch (e) {
      logger.d('Error deleting note: $e');
      return false;
    }
  }

  Future<void> clearAllNotes() async {
    try {
      final box = await _getBox();
      await box.clear();
    } catch (e) {
      logger.d('Error clearing Notes: $e');
    }
  }

  Future<void> close() async {
    if (Hive.isBoxOpen(HiveConstants.notesBox)) {
      await Hive.close();
    }
  }
}
