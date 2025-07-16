import 'dart:async';

import '../../constants/enums/invoice_type.dart';
import '../../utils/get_it_instance.dart';
import '../../utils/logger.dart';
import '../apis/models/invoice/invoice_model.dart';
import '../apis/models/items/item_model.dart';
import 'company_repo.dart';
import 'storage/item_storage.dart';

class ItemsRepo {
  final ItemStorage storageService;

  ItemsRepo({
    required this.storageService,
  });

  String? errorMessage;
  final _itemStreamController = StreamController<void>.broadcast();

  Stream<void> get itemStream => _itemStreamController.stream;

  void notifyItemUpdated() {
    _itemStreamController.add(null);
  }

  void dispose() {
    _itemStreamController.close();
  }

  final List<ItemModel> _items = List.empty(growable: true);
  final Map<String, ItemModel> _idWiseItems = {};

  final List<ItemModel> _stockItems = List.empty(growable: true);
  final Map<String, ItemModel> _idWiseStockItems = {};

  final List<ItemModel> _noStockItems = List.empty(growable: true);
  final Map<String, ItemModel> _idWiseNoStockItems = {};

  List<ItemModel> get items => _items;

  Map<String, ItemModel> get idWiseItems => _idWiseItems;

  List<ItemModel> get stockItems => _stockItems;

  Map<String, ItemModel> get idWiseStockItems => _idWiseStockItems;

  List<ItemModel> get noStockItems => _noStockItems;

  Map<String, ItemModel> get idWiseNoStockItems => _idWiseNoStockItems;

  Future<List<ItemModel>> getAllItems({bool notify = true}) async {
    final response = await storageService.getAllItems(
      getIt.get<CompanyRepo>().currentCompany!.id,
    );
    if (response.isNotEmpty) {
      var list = response;
      _biffercateListData(list);
      if (notify) notifyItemUpdated();
      return list;
    }
    return [];
  }

  Future<ItemModel?> getItemById(String itemId) async {
    return await storageService.getItemById(itemId);
  }

  Future<bool> createItem(ItemModel item) async {
    final response = await storageService.createItem(item);
    if (response) {
      await getAllItems();
    }
    return response;
  }

  Future<bool> deleteItem(
    String itemId,
  ) async {
    final response = await storageService.deleteItem(itemId);
    if (response) {
      await getAllItems();
      return true;
    }
    return false;
  }

  Future<bool> updateItem(ItemModel item, {bool notify = true}) async {
    final response = await storageService.updateItem(item);
    if (response) {
      await getAllItems(notify: notify);
      return true;
    }
    return false;
  }

  void _biffercateListData(List<ItemModel> items) {
    if (items.isEmpty) return;
    _items.clear();
    _idWiseItems.clear();
    _stockItems.clear();
    _idWiseStockItems.clear();
    _noStockItems.clear();
    _idWiseNoStockItems.clear();

    for (var item in items) {
      _items.add(item);
      _idWiseItems[item.id] = item;
      if (item.closingStock > 0) {
        _stockItems.add(item);
        _idWiseStockItems[item.id] = item;
      } else {
        _noStockItems.add(item);
      }
      _idWiseNoStockItems[item.id] = item;
    }
  }

  Future<void> onInvoiceCreated(InvoiceModel invoice) async {
    for (var invoiceItem in invoice.invoiceItems) {
      var item = _idWiseItems[invoiceItem.id];
      logger.d(invoiceItem.id);
      logger.d(_idWiseItems.keys.toList());
      logger.d(item);
      if (item == null) continue;
      if (invoice.type == InvoiceType.purchase) {
        item = item.copyWith(
          closingStock: item.closingStock + invoiceItem.quantity,
        );
      } else {
        item = item.copyWith(
          closingStock: item.closingStock - invoiceItem.quantity,
        );
      }
      logger.d('updating item ${item.toJson()}');
      await updateItem(item, notify: true);
    }
  }

  Future<void> onInvoiceUpdated(
      InvoiceModel previous, InvoiceModel current) async {
    for (var invoiceItem in current.invoiceItems) {
      var item = _idWiseItems[invoiceItem.id];
      if (item == null) continue;
      if (previous.invoiceItems
          .any((element) => element.id == invoiceItem.id)) {
        await onInvoiceDeleted(previous);
      } else {
        await onInvoiceCreated(current);
      }
    }
  }

  Future<void> onInvoiceDeleted(InvoiceModel invoice) async {
    for (var invoiceItem in invoice.invoiceItems) {
      var item = _idWiseItems[invoiceItem.id];
      if (item == null) continue;
      if (invoice.type == InvoiceType.purchase) {
        item = item.copyWith(
          closingStock: item.closingStock - invoiceItem.quantity,
        );
      } else {
        item = item.copyWith(
          closingStock: item.closingStock + invoiceItem.quantity,
        );
      }
      await updateItem(item, notify: true);
    }
  }
}
