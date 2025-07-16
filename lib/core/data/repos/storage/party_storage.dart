import 'package:hive/hive.dart';

import '../../../config/hive/hive_constants.dart';
import '../../../utils/logger.dart';
import '../../apis/models/party/party_model.dart';

class PartyStorage {
  Future<Box<PartyModel>> _getBox() async {
    if (!Hive.isBoxOpen(HiveConstants.partyBox)) {
      return await Hive.openBox<PartyModel>(HiveConstants.partyBox);
    }
    return Hive.box<PartyModel>(HiveConstants.partyBox);
  }

  Future<List<PartyModel>> getAllParties(String companyId) async {
    try {
      final box = await _getBox();
      return box.values.where((party) => party.companyId == companyId).toList();
    } catch (e) {
      logger.d('Error getting all parties: $e');
      return [];
    }
  }

  Future<PartyModel?> getPartyById(String id) async {
    try {
      final box = await _getBox();
      final model = box.values.firstWhere(
        (party) => party.id == id,
      );
      return model;
    } catch (e) {
      logger.d('Error getting party by id: $e');
      return null;
    }
  }

  Future<bool> createParty(PartyModel party) async {
    try {
      final box = await _getBox();
      await box.put(party.id, party);
      return true;
    } catch (e) {
      logger.d('Error creating party: $e');
      return false;
    }
  }

  Future<bool> updateParty(PartyModel updatedParty) async {
    try {
      final box = await _getBox();
      if (box.containsKey(updatedParty.id)) {
        await box.put(updatedParty.id, updatedParty);
        return true;
      }
      return false;
    } catch (e) {
      logger.d('Error updating party: $e');
      return false;
    }
  }

  Future<bool> deleteParty(String id) async {
    try {
      final box = await _getBox();
      if (box.containsKey(id)) {
        await box.delete(id);
        return true;
      }
      return false;
    } catch (e) {
      logger.d('Error deleting party: $e');
      return false;
    }
  }

  Future<void> clearAllParties() async {
    try {
      final box = await _getBox();
      await box.clear();
    } catch (e) {
      logger.d('Error clearing parties: $e');
    }
  }

  Future<void> close() async {
    if (Hive.isBoxOpen(HiveConstants.partyBox)) {
      await Hive.close();
    }
  }
}
