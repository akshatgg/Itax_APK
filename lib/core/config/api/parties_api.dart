import '../../../core/config/api/api_routes.dart';
import '../../data/apis/models/party/party_model.dart';
import 'api_service.dart';
import 'api_task.dart';

class PartiesApiService extends ApiService {
  PartiesApiService() : super();

  Future<ApiTask<List<PartyModel>>> getAllParties(
    int pageNumber,
    String? searchField,
    String token,
  ) async {
    ApiTask<List<PartyModel>> task = ApiTask.empty();
    ApiTask<Map<String, dynamic>> reqTask = await sendReq<Map<String, dynamic>>(
      ApiRoutes.parties,
      {},
      ApiRequestType.get,
      headers: {'Authorization': 'Bearer $token'},
      queryParameters: {
        'page': pageNumber,
        'search': searchField,
      },
    );
    if (reqTask.status == ApiStatus.success) {
      final partiesJson = reqTask.data!['parties'] as List<dynamic>;
      final accounts = partiesJson
          .map((t) => PartyModel.fromJson(t as Map<String, dynamic>))
          .toList();
      task.data = accounts;
      task.status = ApiStatus.success;
    } else {
      task.data = [];
      task.status = reqTask.status;
      task.errorMessage = reqTask.errorMessage;
    }
    return task;
  }

  Future<ApiTask<PartyModel>> getPartyById(
    int partyId,
    String token,
  ) async {
    ApiTask<PartyModel> task = ApiTask.empty();
    final url = '${ApiRoutes.parties}/$partyId';
    ApiTask<Map<String, dynamic>> reqTask = await sendReq<Map<String, dynamic>>(
      url,
      {},
      ApiRequestType.get,
      headers: {'Authorization': 'Bearer $token'},
    );
    if (reqTask.status == ApiStatus.success) {
      PartyModel newAccount =
          PartyModel.fromJson(reqTask.data!['party'] as Map<String, dynamic>);
      task.data = newAccount;
      task.status = ApiStatus.success;
    } else {
      task.data = null;
      task.status = reqTask.status;
      task.errorMessage = reqTask.errorMessage;
    }
    return task;
  }

  Future<ApiTask<PartyModel>> createParty(
    PartyModel party,
    String token,
  ) async {
    ApiTask<PartyModel> task = ApiTask.empty();
    ApiTask<Map<String, dynamic>> reqTask = await sendReq<Map<String, dynamic>>(
      ApiRoutes.parties,
      party.toJson(),
      ApiRequestType.post,
      headers: {'Authorization': 'Bearer $token'},
    );
    if (reqTask.status == ApiStatus.success) {
      PartyModel newAccount =
          PartyModel.fromJson(reqTask.data!['party'] as Map<String, dynamic>);
      task.data = newAccount;
      task.status = ApiStatus.success;
    } else {
      task.data = null;
      task.status = reqTask.status;
      task.errorMessage = reqTask.errorMessage;
    }
    return task;
  }

  Future<ApiTask<PartyModel>> deleteParty(
    String partyId,
    String token,
  ) async {
    ApiTask<PartyModel> task = ApiTask.empty();
    final url = '${ApiRoutes.parties}/$partyId';
    ApiTask<Map<String, dynamic>> reqTask = await sendReq<Map<String, dynamic>>(
      url,
      {},
      ApiRequestType.delete,
      headers: {'Authorization': 'Bearer $token'},
    );
    if (reqTask.status == ApiStatus.success) {
      PartyModel deletedAc = PartyModel.fromJson(
          reqTask.data!['deletedParty'] as Map<String, dynamic>);
      task.data = deletedAc;
      task.status = ApiStatus.success;
    } else {
      task.data = null;
      task.status = reqTask.status;
      task.errorMessage = reqTask.errorMessage;
    }
    return task;
  }
}
