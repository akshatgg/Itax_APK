import '../../../core/config/api/api_routes.dart';
import '../../data/apis/models/items/item_model.dart';
import 'api_service.dart';
import 'api_task.dart';

class ItemsApiService extends ApiService {
  ItemsApiService() : super();

  Future<ApiTask<List<ItemModel>>> getAllItems(
    int pageNumber,
    String? searchField,
    String token,
  ) async {
    ApiTask<List<ItemModel>> task = ApiTask.empty();
    ApiTask<Map<String, dynamic>> reqTask = await sendReq<Map<String, dynamic>>(
      ApiRoutes.items,
      {},
      ApiRequestType.get,
      headers: {'Authorization': 'Bearer $token'},
      queryParameters: {
        'page': pageNumber,
        'search': searchField,
      },
    );
    if (reqTask.status == ApiStatus.success) {
      final partiesJson = reqTask.data!['items'] as List<dynamic>;
      final items = partiesJson
          .map((t) => ItemModel.fromJson(t as Map<String, dynamic>))
          .toList();
      task.data = items;
      task.status = ApiStatus.success;
    } else {
      task.data = [];
      task.status = reqTask.status;
      task.errorMessage = reqTask.errorMessage;
    }
    return task;
  }

  Future<ApiTask<ItemModel>> getItemById(
    int itemId,
    String token,
  ) async {
    ApiTask<ItemModel> task = ApiTask.empty();
    final url = '${ApiRoutes.items}/$itemId';
    ApiTask<Map<String, dynamic>> reqTask = await sendReq<Map<String, dynamic>>(
      url,
      {},
      ApiRequestType.get,
      headers: {'Authorization': 'Bearer $token'},
    );
    if (reqTask.status == ApiStatus.success) {
      ItemModel item =
          ItemModel.fromJson(reqTask.data!['item'] as Map<String, dynamic>);
      task.data = item;
      task.status = ApiStatus.success;
    } else {
      task.data = null;
      task.status = reqTask.status;
      task.errorMessage = reqTask.errorMessage;
    }
    return task;
  }

  Future<ApiTask<ItemModel>> createItem(
    ItemModel item,
    String token,
  ) async {
    ApiTask<ItemModel> task = ApiTask.empty();
    ApiTask<Map<String, dynamic>> reqTask = await sendReq<Map<String, dynamic>>(
      ApiRoutes.items,
      item.toJson(),
      ApiRequestType.post,
      headers: {'Authorization': 'Bearer $token'},
    );
    if (reqTask.status == ApiStatus.success) {
      ItemModel item =
          ItemModel.fromJson(reqTask.data!['item'] as Map<String, dynamic>);
      task.data = item;
      task.status = ApiStatus.success;
    } else {
      task.data = null;
      task.status = reqTask.status;
      task.errorMessage = reqTask.errorMessage;
    }
    return task;
  }

  Future<ApiTask<ItemModel>> updateItem(
    ItemModel item,
    String token,
  ) async {
    ApiTask<ItemModel> task = ApiTask.empty();
    final url = '${ApiRoutes.items}/${item.id}';
    ApiTask<Map<String, dynamic>> reqTask = await sendReq<Map<String, dynamic>>(
      url,
      item.toJson(),
      ApiRequestType.put,
      headers: {'Authorization': 'Bearer $token'},
    );
    if (reqTask.status == ApiStatus.success) {
      ItemModel item =
          ItemModel.fromJson(reqTask.data!['item'] as Map<String, dynamic>);
      task.data = item;
      task.status = ApiStatus.success;
    } else {
      task.data = null;
      task.status = reqTask.status;
      task.errorMessage = reqTask.errorMessage;
    }
    return task;
  }

  Future<ApiTask<ItemModel>> deleteItem(
    String itemId,
    String token,
  ) async {
    ApiTask<ItemModel> task = ApiTask.empty();
    final url = '${ApiRoutes.items}/$itemId';
    ApiTask<Map<String, dynamic>> reqTask = await sendReq<Map<String, dynamic>>(
      url,
      {},
      ApiRequestType.delete,
      headers: {'Authorization': 'Bearer $token'},
    );
    if (reqTask.status == ApiStatus.success) {
      ItemModel deletedItem = ItemModel.fromJson(
          reqTask.data!['deletedItem'] as Map<String, dynamic>);
      task.data = deletedItem;
      task.status = ApiStatus.success;
    } else {
      task.data = null;
      task.status = reqTask.status;
      task.errorMessage = reqTask.errorMessage;
    }
    return task;
  }
}
