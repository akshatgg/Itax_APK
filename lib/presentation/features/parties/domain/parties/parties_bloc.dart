import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/config/api/api_task.dart';
import '../../../../../core/data/apis/models/common/gst_response.dart';
import '../../../../../core/data/apis/models/party/party_model.dart';
import '../../../../../core/data/repos/company_repo.dart';
import '../../../../../core/data/repos/parties_repo.dart';
import '../../../../../core/data/repos/services/gst_validation_service.dart';
import '../../../../../core/utils/id_generator.dart';
import '../../../../../core/utils/logger.dart';

part 'parties_event.dart';
part 'parties_state.dart';

class PartiesBloc extends Bloc<PartiesEvent, PartiesState> {
  final PartiesRepo repo;
  final CompanyRepo companyRepo;
  final GSTValidationService gstValidationService;

  List<PartyModel> get customers => repo.customers;

  List<PartyModel> get suppliers => repo.suppliers;

  List<PartyModel> get parties => repo.parties;
  late StreamSubscription<void> _subscription;

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }

  PartiesBloc(
    this.repo,
    this.companyRepo,
    this.gstValidationService,
  ) : super(PartiesInitial()) {
    on<OnGetParties>(_onGetParties);
    on<OnAddParty>(_onAddParty);
    on<OnUpdateParty>(_onUpdateParty);
    on<OnDeleteParty>(_onDeleteParty);
    on<OnPartiesLoaded>(_onDataUpdate);
    on<OnValidateGSTNumber>(_onValidateGSTNumber);
    _subscription = repo.partyStream.listen((_) {
      add(const OnPartiesLoaded());
    });
  }

  Future<void> _onValidateGSTNumber(
    OnValidateGSTNumber event,
    Emitter<PartiesState> emit,
  ) async {
    final gstinPattern = RegExp(
      r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{2}$',
    );
    if (!gstinPattern.hasMatch(event.gstin)) {
      emit(const GSTValidationFailed(reason: 'Invalid GST Number'));
      return;
    }
    final gstResponse =
        await gstValidationService.validateGSTNumber(event.gstin);
    if (gstResponse.status == ApiStatus.success) {
      final gstResponseData = gstResponse.data;
      if (gstResponseData == null || gstResponseData.flag == false) {
        emit(const GSTValidationFailed(reason: 'Invalid GST Number'));
      } else {
        emit(GSTValidationSuccess(data: gstResponseData));
      }
    }
  }

  Future<void> _onGetParties(
    OnGetParties event,
    Emitter<PartiesState> emit,
  ) async {
    emit(ProcessLoading());
    try {
     /* if (companyRepo.currentCompany == null) {
        emit(const PartyOperationFailed(reason: 'Company not found'));
        return;
      }*/
      final response = await repo.getAllParties();
      if (response.isNotEmpty) {
        emit(PartiesList(customers: repo.customers, suppliers: repo.suppliers));
      } else {
        emit(PartyOperationFailed(reason: repo.errorMessage ?? 'Failed'));
      }
    } catch (e) {
      logger.e('OnGetParties $e');
      emit(const PartyOperationFailed(reason: 'Failed to fetch parties'));
    }
  }

  Future<void> _onAddParty(
    OnAddParty event,
    Emitter<PartiesState> emit,
  ) async {
    emit(ProcessLoading());
    try {
      if (event.partyModel.gstin != null &&
          event.partyModel.gstin!.isNotEmpty) {
        final gstResponse = await gstValidationService
            .validateGSTNumber(event.partyModel.gstin!);
        if (gstResponse.status == ApiStatus.success) {
          final gstResponseData = gstResponse.data;
          if (gstResponseData?.flag == false) {
            emit(const PartyOperationFailed(reason: 'Invalid GST Number'));
          }
        }
      }
      if (companyRepo.currentCompany == null) {
        emit(const PartyOperationFailed(reason: 'Company not found'));
        return;
      }
      final party = event.partyModel.copyWith(
        id: generateId(),
        companyId: companyRepo.currentCompany!.id,
      );
      final response = await repo.createParty(party);
      if (response) {
        emit(const PartyOperationSuccess());
        emit(PartiesList(customers: repo.customers, suppliers: repo.suppliers));
      } else {
        emit(PartyOperationFailed(reason: repo.errorMessage ?? 'Failed'));
      }
    } catch (e) {
      logger.e('OnAddParty $e');
      emit(const PartyOperationFailed(reason: 'Failed to add parties'));
    }
  }

  Future<void> _onUpdateParty(
    OnUpdateParty event,
    Emitter<PartiesState> emit,
  ) async {
    emit(ProcessLoading());
    try {
      if (companyRepo.currentCompany == null) {
        emit(const PartyOperationFailed(reason: 'Company not found'));
        return;
      }
      final party = event.partyModel.copyWith(
        companyId: companyRepo.currentCompany!.id,
      );
      final response = await repo.updateParty(party);
      if (response) {
        emit(const PartyUpdateOperationSuccess());
        emit(PartiesList(customers: repo.customers, suppliers: repo.suppliers));
      } else {
        emit(PartyUpdateOperationFailed(reason: repo.errorMessage ?? 'Failed'));
      }
    } catch (e) {
      logger.e('OnAddParty $e');
      emit(const PartyUpdateOperationFailed(reason: 'Failed to fetch parties'));
    }
  }

  Future<void> _onDeleteParty(
    OnDeleteParty event,
    Emitter<PartiesState> emit,
  ) async {
    emit(ProcessLoading());
    try {
      final response = await repo.deleteParty(event.partyModel.id);
      if (response) {
        emit(const PartyDeleteOperationSuccess());
        emit(PartiesList(customers: repo.customers, suppliers: repo.suppliers));
      } else {
        emit(PartyDeleteOperationFailed(reason: repo.errorMessage ?? 'Failed'));
      }
    } catch (e) {
      logger.e('OnDeleteParty $e');
      emit(const PartyDeleteOperationFailed(reason: 'Failed to fetch parties'));
    }
  }

  void _onDataUpdate(
    OnPartiesLoaded event,
    Emitter<PartiesState> emit,
  ) {
    try {
      emit(PartiesList(customers: repo.customers, suppliers: repo.suppliers));
    } on Exception catch (e) {
      logger.e('OnPartiesLoaded $e');
      emit(const PartyOperationFailed(reason: 'Failed to fetch parties'));
    }
  }
}
