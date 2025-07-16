import 'dart:async';

import '../../../presentation/features/parties/domain/parties/parties_bloc.dart';
import '../../constants/enums/invoice_type.dart';
import '../../constants/enums/party_type.dart';
import '../../utils/get_it_instance.dart';
import '../../utils/list_extenstion.dart';
import '../apis/models/invoice/invoice_model.dart';
import '../apis/models/invoice/notes_model.dart';
import '../apis/models/invoice/receipt_model.dart';
import '../apis/models/party/party_model.dart';
import 'company_repo.dart';
import 'storage/party_storage.dart';

class PartiesRepo {
  final PartyStorage storageService;

  PartiesRepo({
    required this.storageService,
  });

  String? errorMessage;
  final _partyStreamController = StreamController<void>.broadcast();

  Stream<void> get partyStream => _partyStreamController.stream;

  void notifyPartyUpdated() {
    _partyStreamController.add(null);
    getIt.get<PartiesBloc>().add(const OnPartiesLoaded());
  }

  void dispose() {
    _partyStreamController.close();
  }

  final List<PartyModel> _parties = List.empty(growable: true);
  final Map<String, PartyModel> _idWiseParties = {};
  final List<PartyModel> _customers = List.empty(growable: true);
  final Map<String, PartyModel> _idWiseCustomers = {};
  final List<PartyModel> _suppliers = List.empty(growable: true);
  final Map<String, PartyModel> _idWiseSuppliers = {};

  List<PartyModel> get customers => _customers;

  Map<String, PartyModel> get idWiseCustomers => _idWiseCustomers;

  List<PartyModel> get suppliers => _suppliers;

  Map<String, PartyModel> get idWiseSuppliers => _idWiseSuppliers;

  List<PartyModel> get parties => _parties;

  Map<String, PartyModel> get idWiseParties => _idWiseParties;

  Future<List<PartyModel>> getAllParties({bool notify = true}) async {
    final companyRepo = getIt.get<CompanyRepo>();
    await companyRepo.getAllCompany(); // ensure currentCompany is filled
    final companyId = companyRepo.currentCompany?.id;
    final response = await storageService.getAllParties(
      companyId!,
    );
    if (response.isNotEmpty) {
      var list = response;
      if (notify) notifyPartyUpdated();
      _biffercateListData(list);
      return list;
    }
    return [];
  }

  Future<PartyModel?> getPartyById(String partyId) async {
    return await storageService.getPartyById(partyId);
  }

  Future<bool> createParty(PartyModel party) async {
    final response = await storageService.createParty(party);
    if (response) {
      await getAllParties();
    }
    return response;
  }

  Future<bool> deleteParty(String partyId) async {
    final response = await storageService.deleteParty(partyId);
    if (response) {
      await getAllParties();
      return true;
    }
    return false;
  }

  Future<bool> updateParty(PartyModel party, {bool notify = true}) async {
    final response = await storageService.updateParty(party);
    if (response) {
      await getAllParties(notify: notify);
      return true;
    }
    return false;
  }

  void _biffercateListData(List<PartyModel> parties) {
    if (parties.isEmpty) return;
    _customers.clear();
    _idWiseCustomers.clear();
    _suppliers.clear();
    _idWiseSuppliers.clear();
    _parties.clear();
    _idWiseParties.clear();
    _parties.addAll(parties);

    for (var party in parties) {
      _idWiseParties[party.id] = party;
      switch (party.type) {
        case PartyType.customer:
          _customers.add(party);
          _idWiseCustomers[party.id] = party;
          break;
        case PartyType.supplier:
          _suppliers.add(party);
          _idWiseSuppliers[party.id] = party;
          break;
      }
    }
  }

  Future<void> onCreateInvoice(InvoiceModel invoice) async {
    var party = parties.firstWhere((element) => element.id == invoice.partyId);
    if (party.type == PartyType.customer) {
      party = party.copyWith(
        totalDebit: party.totalDebit + invoice.totalAmount,
        outstandingBalance: party.outstandingBalance + invoice.totalAmount,
      );
    } else {
      party = party.copyWith(
        totalCredit: party.totalCredit + invoice.totalAmount,
        outstandingBalance: party.outstandingBalance - invoice.totalAmount,
      );
    }
    await updateParty(party, notify: true);
  }

  Future<void> onUpdateInvoice(InvoiceModel invoice) async {
    var party = parties.firstWhere((element) => element.id == invoice.partyId);
    if (party.type == PartyType.customer) {
      party = party.copyWith(
        totalDebit: party.totalDebit + invoice.totalAmount,
        outstandingBalance: party.outstandingBalance + invoice.totalAmount,
      );
    } else {
      party = party.copyWith(
        totalCredit: party.totalCredit + invoice.totalAmount,
        outstandingBalance: party.outstandingBalance - invoice.totalAmount,
      );
    }
    await updateParty(party, notify: true);
  }

  Future<void> onInvoiceDeleted(InvoiceModel invoice) async {
    var party = parties.firstWhere((element) => element.id == invoice.partyId);
    if (party.type == PartyType.customer) {
      party = party.copyWith(
        totalDebit: party.totalDebit - invoice.totalAmount,
        outstandingBalance: party.outstandingBalance - invoice.totalAmount,
      );
    } else {
      party = party.copyWith(
        totalCredit: party.totalCredit - invoice.totalAmount,
        outstandingBalance: party.outstandingBalance + invoice.totalAmount,
      );
    }
    await updateParty(party, notify: true);
  }

  Future<void> onNoteCreated(NotesModel note) async {
    var party = parties.firstWhere((element) => element.id == note.partyId);
    if (note.totalAmount >= 0) {
      party = party.copyWith(
        outstandingBalance: party.outstandingBalance - note.totalAmount,
      );
    } else {
      party = party.copyWith(
        outstandingBalance: party.outstandingBalance + note.totalAmount,
      );
    }
    await updateParty(party, notify: true);
  }

  Future<void> onNoteUpdated(
    NotesModel previous,
    NotesModel current,
  ) async {
    final party =
        parties.firstWhereOrNull((element) => previous.partyId == element.id);
    if (party != null) {
      await updateParty(
        party.copyWith(
          outstandingBalance: previous.totalAmount > 0
              ? party.outstandingBalance + previous.totalAmount
              : party.outstandingBalance - previous.totalAmount,
        ),
        notify: true,
      );
    }
    onNoteCreated(current);
  }

  Future<void> onNoteDeleted(NotesModel note) async {
    final party =
        parties.firstWhereOrNull((element) => note.partyId == element.id);
    if (party != null) {
      await updateParty(
        party.copyWith(
          outstandingBalance: note.totalAmount > 0
              ? party.outstandingBalance + note.totalAmount
              : party.outstandingBalance - note.totalAmount,
        ),
        notify: true,
      );
    }
  }

  Future<void> onReceiptCreated(ReceiptModel receipt) async {
    final party =
        parties.firstWhereOrNull((element) => receipt.partyId == element.id);
    if (party != null) {
      await updateParty(
        party.copyWith(
          outstandingBalance: receipt.type == InvoiceType.receipt
              ? party.outstandingBalance - receipt.totalAmount
              : party.outstandingBalance + receipt.totalAmount,
        ),
        notify: true,
      );
    }
  }

  Future<void> onReceiptUpdated(
    ReceiptModel previous,
    ReceiptModel current,
  ) async {
    final party =
        parties.firstWhereOrNull((element) => previous.partyId == element.id);
    if (party != null) {
      await updateParty(
        party.copyWith(
          outstandingBalance: previous.type == InvoiceType.receipt
              ? party.outstandingBalance + previous.totalAmount
              : party.outstandingBalance - previous.totalAmount,
        ),
        notify: true,
      );
    }
    onReceiptCreated(current);
  }

  Future<void> onReceiptDeleted(ReceiptModel receipt) async {
    final party =
        parties.firstWhereOrNull((element) => receipt.partyId == element.id);
    if (party != null) {
      await updateParty(
        party.copyWith(
          outstandingBalance: receipt.type == InvoiceType.receipt
              ? party.outstandingBalance + receipt.totalAmount
              : party.outstandingBalance - receipt.totalAmount,
        ),
        notify: true,
      );
    }
  }
}
