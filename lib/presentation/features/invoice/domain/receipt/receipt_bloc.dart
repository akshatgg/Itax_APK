import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/enums/invoice_type.dart';
import '../../../../../core/constants/strings_constants.dart';
import '../../../../../core/data/apis/models/invoice/invoice_model.dart';
import '../../../../../core/data/apis/models/invoice/receipt_model.dart';
import '../../../../../core/data/repos/company_repo.dart';
import '../../../../../core/data/repos/dashboard_data_repo.dart';
import '../../../../../core/data/repos/day_book_repo.dart';
import '../../../../../core/data/repos/invoice_repo.dart';
import '../../../../../core/data/repos/parties_repo.dart';
import '../../../../../core/data/repos/receipt_repo.dart';
import '../../../../../core/utils/id_generator.dart';
import '../../../../../core/utils/list_extenstion.dart';
import '../../../../../core/utils/logger.dart';

part 'receipt_event.dart';
part 'receipt_state.dart';

class ReceiptBloc extends Bloc<ReceiptEvent, ReceiptState> {
  final ReceiptRepo receiptRepo;
  final InvoiceRepo invoiceRepo;
  final PartiesRepo partyRepo;
  final CompanyRepo companyRepo;
  final DayBookRepo dayBookRepo;
  final DashboardDataRepo dashboardDataRepo;

  List<ReceiptModel> get receipts => receiptRepo.receipts;

  Map<String, List<ReceiptModel>> get partyWiseReceipts =>
      receiptRepo.partyWiseReceipts;

  Map<InvoiceType, List<ReceiptModel>> get typeWiseReceipts =>
      receiptRepo.typeWiseReceipts;

  int get lastReceiptNumber => receiptRepo.lastReceiptNumber;

  Map<InvoiceType, double> get typeWiseAmounts => receiptRepo.typeWiseAmounts;

  late StreamSubscription<void> _subscription;

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }

  ReceiptBloc({
    required this.receiptRepo,
    required this.invoiceRepo,
    required this.partyRepo,
    required this.companyRepo,
    required this.dayBookRepo,
    required this.dashboardDataRepo,
  }) : super(const ReceiptInitial(receipts: [])) {
    on<OnSelectInvoice>(_onSelectInvoice);
    on<OnGetReceipt>(_onGetReceipt);
    on<CreateReceipt>(_onCreateReceipt);
    on<UpdateReceipt>(_onUpdateReceipt);
    on<OnReceiptUpdated>(_onReceiptUpdated);
    on<DeleteReceipt>(_onDeleteReceipt);
    _subscription = receiptRepo.receiptStream.listen((_) {
      add(const OnReceiptUpdated());
    });
  }

  void _onDeleteReceipt(
    DeleteReceipt event,
    Emitter<ReceiptState> emit,
  ) async {
    try {
      emit(ReceiptLoading(receipts: state.receipts));
      final receipt = state.receipts.firstWhere((e) => e.id == event.receiptId);
      final isDone = await receiptRepo.deleteReceipt(receipt.id);
      if (isDone) {
        await invoiceRepo.onReceiptDeleted(receipt);
        await partyRepo.onReceiptDeleted(receipt);
        await dashboardDataRepo.onReceiptDeleted(receipt);
        emit(ReceiptLoaded(receipts: state.receipts));
      } else {
        emit(ReceiptError(
            receipts: state.receipts,
            errorMessage: AppStrings.failedToDeleteReceipt));
      }
    } on Exception catch (e) {
      logger.d('Error deleting receipt: $e');
      emit(ReceiptError(
          receipts: state.receipts,
          errorMessage: AppStrings.failedToDeleteReceipt));
    }
  }

  void _onReceiptUpdated(
    OnReceiptUpdated event,
    Emitter<ReceiptState> emit,
  ) {
    emit(ReceiptLoaded(
      receipts: receiptRepo.receipts,
    ));
  }

  void _onGetReceipt(
    OnGetReceipt event,
    Emitter<ReceiptState> emit,
  ) async {
    try {
      emit(ReceiptLoading(receipts: state.receipts));
      final receipts = await receiptRepo.getAllReceipts();
      emit(ReceiptLoaded(receipts: receipts));
    } on Exception catch (e) {
      logger.d('Error getting receipts: $e');
      emit(ReceiptError(
          receipts: state.receipts,
          errorMessage: AppStrings.failedToGetReceipt));
    }
  }

  void _onSelectInvoice(
    OnSelectInvoice event,
    Emitter<ReceiptState> emit,
  ) async {
    emit(SelectedInvoiceDataState(
      receipts: state.receipts,
      selectedInvoiceData: event.selectedInvoiceData,
    ));
  }

  void _onCreateReceipt(
    CreateReceipt event,
    Emitter<ReceiptState> emit,
  ) async {
    try {
      emit(ReceiptLoading(receipts: state.receipts));
      final receipt = event.receipt.copyWith(
        id: generateId(),
        companyId: companyRepo.currentCompany!.id,
      );
      final isDone = await receiptRepo.createReceipt(receipt);
      if (isDone) {
        await invoiceRepo.onReceiptCreated(receipt);
        await partyRepo.onReceiptCreated(receipt);
        await dayBookRepo.onReceiptCreated(receipt);
        await dashboardDataRepo.onReceiptAdded(receipt);
        emit(ReceiptLoaded(receipts: state.receipts));
      } else {
        emit(ReceiptError(
            receipts: state.receipts,
            errorMessage: AppStrings.failedToCreateReceipt));
      }
    } on Exception catch (e) {
      logger.d('Error creating receipt: $e');
      emit(ReceiptError(
          receipts: state.receipts,
          errorMessage: AppStrings.failedToCreateReceipt));
    }
  }

  void _onUpdateReceipt(
    UpdateReceipt event,
    Emitter<ReceiptState> emit,
  ) async {
    try {
      emit(ReceiptLoading(receipts: state.receipts));
      final receipt = event.receipt.copyWith(
        companyId: companyRepo.currentCompany!.id,
      );

      final previous = receiptRepo.receipts
          .firstWhereOrNull((element) => element.id == receipt.id);
      if (previous == null) {
        emit(ReceiptError(
            receipts: state.receipts,
            errorMessage: AppStrings.notFoundReceipt));
        return;
      }
      final isDone = await receiptRepo.updateReceipt(receipt);
      if (isDone) {
        await invoiceRepo.onReceiptUpdated(previous, receipt);
        await partyRepo.onReceiptUpdated(previous, receipt);
        await dashboardDataRepo.onReceiptUpdated(previous, receipt);
        emit(ReceiptLoaded(receipts: state.receipts));
      } else {
        emit(ReceiptError(
            receipts: state.receipts,
            errorMessage: AppStrings.failedToUpdateReceipt));
      }
    } on Exception catch (e) {
      logger.d('Error updating receipt: $e');
      emit(ReceiptError(
          receipts: state.receipts,
          errorMessage: AppStrings.failedToUpdateReceipt));
    }
  }
}
