import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/data/apis/models/items/item_model.dart';
import '../../../../../core/data/repos/company_repo.dart';
import '../../../../../core/data/repos/items_repo.dart';
import '../../../../../core/data/repos/services/file_storage_service.dart';
import '../../../../../core/utils/id_generator.dart';
import '../../../../../core/utils/logger.dart';

part 'item_event.dart';
part 'item_state.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final ItemsRepo repo;
  final CompanyRepo companyRepo;
  final FileStorageService fileStorageService;

  List<ItemModel> get items => repo.items;

  List<ItemModel> get stockItems => repo.stockItems;

  List<ItemModel> get noStockItems => repo.noStockItems;

  late StreamSubscription<void> _subscription;

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }

  ItemBloc(this.repo, this.companyRepo, this.fileStorageService)
      : super(ItemInitial()) {
    on<OnGetItem>(_onGetItem);
    on<OnAddItem>(_onAddItem);
    on<OnDeleteItem>(_onDeleteItem);
    on<OnUpdateItem>(_onUpdateItem);
    on<OnItemLoaded>(_onDataUpdate);
    on<OnStockUpdateItem>(_onStockUpdateItem);

    _subscription = repo.itemStream.listen((_) {
      add(OnItemLoaded());
    });
  }

  Future<void> _onGetItem(
    OnGetItem event,
    Emitter<ItemState> emit,
  ) async {
    emit(ProcessLoading());
    try {
      final response = await repo.getAllItems();
      if (response.isNotEmpty) {
        emit(ItemsList(items: repo.items));
      } else {
        emit(ItemOperationFailed(reason: repo.errorMessage ?? 'Failed'));
      }
    } catch (e) {
      logger.e('OnGetItem $e');
      emit(const ItemOperationFailed(reason: 'Failed to fetch items'));
    }
  }

  Future<void> _onAddItem(
    OnAddItem event,
    Emitter<ItemState> emit,
  ) async {
    emit(ProcessLoading());
    try {
      final fileMetaData = event.image != null
          ? await fileStorageService.saveFileInChunks(event.image!)
          : null;

      if (companyRepo.currentCompany == null) {
        emit(const ItemOperationFailed(reason: 'Company not found'));
        return;
      }
      final item = event.itemModel.copyWith(
        id: generateId(),
        companyId: companyRepo.currentCompany!.id,
        fileMetadata: fileMetaData,
      );
      final response = await repo.createItem(item);
      if (response) {
        emit(ItemsList(items: repo.items));
      } else {
        emit(ItemOperationFailed(reason: repo.errorMessage ?? 'Failed'));
      }
    } catch (e) {
      logger.e('OnAddItem $e');
      emit(const ItemOperationFailed(reason: 'Failed to add item'));
    }
  }

  Future<void> _onDeleteItem(
    OnDeleteItem event,
    Emitter<ItemState> emit,
  ) async {
    emit(ProcessLoading());
    try {
      final response = await repo.deleteItem(event.itemModel.id);
      logger.d(response);
      if (response) {
        emit(ItemDeleteOperationSuccess());
        emit(ItemsList(items: repo.items));
      } else {
        emit(ItemDeleteOperationFailed(reason: repo.errorMessage ?? 'Failed'));
      }
    } catch (e) {
      logger.e('OnDeleteItem $e');
      emit(const ItemDeleteOperationFailed(reason: 'Failed to fetch items'));
    }
  }

  Future<void> _onUpdateItem(
    OnUpdateItem event,
    Emitter<ItemState> emit,
  ) async {
    emit(ProcessLoading());
    try {
      final fileMetaData = event.image != null
          ? await fileStorageService.saveFileInChunks(event.image!)
          : null;
      final item = event.itemModel.copyWith(
        fileMetadata: fileMetaData,
        updatedAt: DateTime.now(),
        companyId: companyRepo.currentCompany!.id,
      );
      logger.i(item);
      final response = await repo.updateItem(item);
      if (response) {
        emit(const ItemOperationSuccess(message: 'Item Updated Successfully'));
        emit(ItemsList(items: repo.items));
      } else {
        emit(ItemOperationFailed(reason: repo.errorMessage ?? 'Failed'));
      }
    } catch (e) {
      logger.e('OnDeleteItem $e');
      emit(const ItemOperationFailed(reason: 'Failed to fetch items'));
    }
  }

  Future<void> _onStockUpdateItem(
    OnStockUpdateItem event,
    Emitter<ItemState> emit,
  ) async {
    emit(ProcessLoading());
    try {
      final response = await repo.updateItem(event.itemModel);
      if (response) {
        emit(const ItemStockUpdateSuccess(
            message: 'Stock Updated Successfully'));
        emit(ItemsList(items: repo.items));
      } else {
        emit(ItemStockUpdateFailed(reason: repo.errorMessage ?? 'Failed'));
      }
    } catch (e) {
      logger.e('OnDeleteItem $e');
      emit(const ItemStockUpdateFailed(reason: 'Failed to fetch items'));
    }
  }

  void _onDataUpdate(
    OnItemLoaded event,
    Emitter<ItemState> emit,
  ) {
    emit(ItemsList(items: repo.items));
  }
}
