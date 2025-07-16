import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/enums/invoice_status.dart';
import '../../../../../core/constants/enums/invoice_type.dart';
import '../../../../../core/constants/strings_constants.dart';
import '../../../../../core/data/apis/models/invoice/invoice_model.dart';
import '../../../../../core/data/repos/company_repo.dart';
import '../../../../../core/data/repos/dashboard_data_repo.dart';
import '../../../../../core/data/repos/day_book_repo.dart';
import '../../../../../core/data/repos/invoice_repo.dart';
import '../../../../../core/data/repos/items_repo.dart';
import '../../../../../core/data/repos/parties_repo.dart';
import '../../../../../core/utils/id_generator.dart';
import '../../../../../core/utils/logger.dart';

part 'invoice_event.dart';
part 'invoice_state.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  final InvoiceRepo invoiceRepo;
  final PartiesRepo partyRepo;
  final ItemsRepo itemRepo;
  final DayBookRepo dayBookRepo;
  final CompanyRepo companyRepo;
  final DashboardDataRepo dashboardDataRepo;

  List<InvoiceModel> get invoices => invoiceRepo.invoices;

  Map<String, InvoiceModel> get idWiseInvoices => invoiceRepo.idWiseInvoices;

  Map<String, List<InvoiceModel>> get partyWiseInvoices =>
      invoiceRepo.partyWiseInvoices;

  Map<InvoiceType, List<InvoiceModel>> get typeWiseInvoices =>
      invoiceRepo.typeWiseInvoices;

  Map<InvoiceStatus, List<InvoiceModel>> get statusWiseInvoices =>
      invoiceRepo.statusWiseInvoices;

  int get lastInvoiceNumber => invoiceRepo.lastInvoiceNumber;
  late StreamSubscription<void> _subscription;

  Map<int, List<InvoiceModel>> get monthWiseInvoice =>
      invoiceRepo.monthWiseInvoice;

  Map<InvoiceType, double> get typeWiseAmounts => invoiceRepo.typeWiseAmounts;

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }

  InvoiceBloc({
    required this.invoiceRepo,
    required this.partyRepo,
    required this.itemRepo,
    required this.dayBookRepo,
    required this.companyRepo,
    required this.dashboardDataRepo,
  }) : super(InvoiceInitial(List.empty(growable: true))) {
    on<GetAllInvoices>(_onGetAllInvoices);
    on<CreateInvoice>(_onCreateInvoice);
    on<UpdateInvoice>(_onUpdateInvoice);
    on<DeleteInvoice>(_onDeleteInvoice);
    on<OnInvoiceLoaded>(_onDataUpdate);
    _subscription = invoiceRepo.invoiceStream.listen((_) {
      add(const OnInvoiceLoaded());
    });
  }

  void _onGetAllInvoices(
      GetAllInvoices event, Emitter<InvoiceState> emit) async {
    try {
      emit(InvoiceLoading(state.invoices));
      final invoices = await invoiceRepo.getAllInvoices();
      emit(InvoiceLoaded(invoices));
    } on Exception catch (e) {
      logger.d('Error fetching invoices: $e');
      emit(InvoiceError(invoices, AppStrings.failedToFetchInvoices));
    }
  }

  void _onCreateInvoice(CreateInvoice event, Emitter<InvoiceState> emit) async {
    try {
      emit(InvoiceLoading(state.invoices));
      final invoice = event.invoice.copyWith(
        id: generateId(),
        companyId: companyRepo.currentCompany!.id,
      );
      final isDone = await invoiceRepo.createInvoice(invoice);
      logger.d(isDone);
      if (isDone) {
        await partyRepo.onCreateInvoice(invoice);
        await itemRepo.onInvoiceCreated(invoice);
        await dayBookRepo.onInvoiceCreated(invoice);
        await dashboardDataRepo.onInvoiceAdded(invoice);
        emit(InvoiceLoaded(invoices));
      } else {
        emit(InvoiceError(state.invoices, AppStrings.failedToCreateInvoices));
      }
    } on Exception catch (e) {
      logger.d('Error creating invoice: $e');
      emit(InvoiceError(state.invoices, AppStrings.failedToCreateInvoices));
    }
  }

  void _onUpdateInvoice(UpdateInvoice event, Emitter<InvoiceState> emit) async {
    try {
      emit(InvoiceLoading(state.invoices));
      final invoice = event.invoice.copyWith(
        companyId: companyRepo.currentCompany!.id,
      );
      final isDone = await invoiceRepo.updateInvoice(invoice);
      if (isDone) {
        await dashboardDataRepo.onInvoiceUpdated(event.invoice, invoice);
        await partyRepo.onUpdateInvoice(invoice);
        await itemRepo.onInvoiceUpdated(event.invoice, invoice);
        emit(InvoiceLoaded(invoices));
      } else {
        emit(InvoiceError(state.invoices, AppStrings.failedToUpdateInvoices));
      }
    } on Exception catch (e) {
      logger.d('Error updating invoice: $e');
      emit(InvoiceError(state.invoices, AppStrings.failedToUpdateInvoices));
    }
  }

  void _onDeleteInvoice(DeleteInvoice event, Emitter<InvoiceState> emit) async {
    try {
      emit(InvoiceLoading(state.invoices));
      final invoice = state.invoices.firstWhere((e) => e.id == event.invoiceId);
      final isDone = await invoiceRepo.deleteInvoice(invoice.id);
      if (isDone) {
        await dashboardDataRepo.onInvoiceDeleted(invoice);
        await partyRepo.onInvoiceDeleted(invoice);
        await itemRepo.onInvoiceDeleted(invoice);
        emit(InvoiceLoaded(invoices));
      } else {
        emit(InvoiceError(state.invoices, AppStrings.failedToDeleteInvoices));
      }
    } on Exception catch (e) {
      logger.d('Error deleting invoice: $e');
      emit(InvoiceError(state.invoices, AppStrings.failedToDeleteInvoices));
    }
  }

  void _onDataUpdate(OnInvoiceLoaded event, Emitter<InvoiceState> emit) {
    try {
      emit(InvoiceLoaded(invoiceRepo.invoices));
    } on Exception catch (e) {
      logger.d('Error updating invoice: $e');
      emit(InvoiceError(state.invoices, AppStrings.failedToUpdateInvoices));
    }
  }
}
