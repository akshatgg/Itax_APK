import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/strings_constants.dart';
import '../../../../core/data/apis/models/company/company_model.dart';
import '../../../../core/data/apis/models/shared/file_metadata.dart';
import '../../../../core/data/repos/company_repo.dart';
import '../../../../core/data/repos/dashboard_data_repo.dart';
import '../../../../core/data/repos/day_book_repo.dart';
import '../../../../core/data/repos/invoice_repo.dart';
import '../../../../core/data/repos/items_repo.dart';
import '../../../../core/data/repos/notes_repo.dart';
import '../../../../core/data/repos/parties_repo.dart';
import '../../../../core/data/repos/receipt_repo.dart';
import '../../../../core/data/repos/services/file_storage_service.dart';
import '../../../../core/utils/id_generator.dart';
import '../../../../core/utils/logger.dart';

part 'company_event.dart';
part 'company_state.dart';

class CompanyBloc extends Bloc<CompanyEvent, CompanyState> {
  final CompanyRepo repo;
  final FileStorageService fileService;
  final ItemsRepo itemsRepo;
  final PartiesRepo partiesRepo;
  final ReceiptRepo receiptRepo;
  final InvoiceRepo invoiceRepo;
  final NotesRepo notesRepo;
  final DayBookRepo dayBookRepo;
  final DashboardDataRepo dashboardDataRepo;

  List<CompanyModel> get companies => repo.companies;

  CompanyModel? get currentCompany => repo.currentCompany;

  late StreamSubscription<void> _subscription;

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }

  CompanyBloc({
    required this.repo,
    required this.fileService,
    required this.itemsRepo,
    required this.partiesRepo,
    required this.receiptRepo,
    required this.invoiceRepo,
    required this.notesRepo,
    required this.dayBookRepo,
    required this.dashboardDataRepo,
  }) : super(CompanyInitial()) {
    on<OnGetCompany>(_onGetCompany);
    on<OnAddCompany>(_onAddCompany);
    on<OnDeleteCompany>(_onDeleteCompany);
    on<OnUpdateCompany>(_onUpdateCompany);
    on<OnUpdateCurrentCompany>(_onUpdateCurrentCompany);
    on<OnCompanyLoaded>(_onCompanyLoaded);

    _subscription = repo.companyStream.listen((_) {
      add(OnCompanyLoaded());
    });
  }

  Future<void> _onGetCompany(
    OnGetCompany event,
    Emitter<CompanyState> emit,
  ) async {
    emit(ProcessLoadingCompany());
    try {
      final response = await repo.getAllCompany();
      if (response.isNotEmpty) {
        emit(CompanyList(company: repo.companies));
      } else {
        emit(CompanyOperationFailed(reason: repo.errorMessage ?? AppStrings.failed));
      }
    } catch (e) {
      logger.e('OnGetCompany $e');
      emit(const CompanyOperationFailed(reason: AppStrings.companyFetchFailed));
    }
  }

  Future<void> _onAddCompany(
    OnAddCompany event,
    Emitter<CompanyState> emit,
  ) async {
    emit(ProcessLoadingCompany());
    try {
      FileMetadata? file;
      if (event.companyImage != null) {
        final imageBytes =
            await fileService.saveFileInChunks(event.companyImage!);
        file = imageBytes;
      }
      final company = event.companyModel.copyWith(
        id: generateId(),
        companyImage: file,
      );
      final response = await repo.createCompany(company);
      if (response != null) {
        emit(CompanyList(company: repo.companies));
        emit(const CompanyOperationSuccess());
      } else {
        emit(CompanyOperationFailed(reason: repo.errorMessage ?? AppStrings.failed));
      }
    } catch (e) {
      logger.e('OnAddItem $e');
      emit(const CompanyOperationFailed(reason: AppStrings.companyFetchFailed));
    }
  }

  Future<void> _onDeleteCompany(
    OnDeleteCompany event,
    Emitter<CompanyState> emit,
  ) async {
    emit(ProcessLoadingCompany());
    try {
      final response = await repo.deleteCompany(event.companyModel.id);
      if (response) {
        emit(CompanyDeleteOperationSuccess());
        emit(CompanyList(company: repo.companies));
      } else {
        emit(CompanyDeleteOperationFailed(
            reason: repo.errorMessage ?? AppStrings.failed));
      }
    } catch (e) {
      logger.e('OnDeleteItem $e');
      emit(const CompanyDeleteOperationFailed(reason: AppStrings.companyFetchFailed));
    }
  }

  Future<void> _onUpdateCompany(
    OnUpdateCompany event,
    Emitter<CompanyState> emit,
  ) async {
    emit(ProcessLoadingCompany());
    try {
      final response = await repo.updateCompany(event.companyModel);
      if (response != null) {
        emit(const CompanyOperationSuccess());
        emit(CompanyList(company: repo.companies));
      } else {
        emit(CompanyOperationFailed(reason: repo.errorMessage ?? AppStrings.failed));
      }
    } catch (e) {
      logger.e('OnDeleteItem $e');
      emit(const CompanyOperationFailed(reason: AppStrings.companyFetchFailed));
    }
  }

  Future<void> _onUpdateCurrentCompany(
    OnUpdateCurrentCompany event,
    Emitter<CompanyState> emit,
  ) async {
    repo.updateCurrentCompany(event.index);
    await itemsRepo.getAllItems(notify: true);
    await partiesRepo.getAllParties(notify: true);
    await receiptRepo.getAllReceipts(notify: true);
    await invoiceRepo.getAllInvoices(notify: true);
    await notesRepo.getAllNotes(notify: true);
    await dayBookRepo.getAllDayBooks(notify: true);
    emit(CompanyUpdateCurrentCompany(companyId: repo.currentCompany!.id));
  }

  Future<void> _onCompanyLoaded(
    OnCompanyLoaded event,
    Emitter<CompanyState> emit,
  ) async {
    emit(CompanyList(company: repo.companies));
  }
}
