import '../../../config/api/api_routes.dart';
import '../../../config/api/api_service.dart';
import '../../../config/api/api_task.dart';
import '../../../utils/logger.dart';
import '../../apis/models/common/gst_credits.dart';
import '../../apis/models/common/gst_response.dart';

class GSTValidationService extends ApiService {
  Future<ApiTask<GSTResponse>> validateGSTNumber(String gstNumber) async {
    ApiTask<GSTResponse> task = ApiTask.empty();
    ApiTask<Map<String, dynamic>> reqTask = await sendReq<Map<String, dynamic>>(
      ApiRoutes.gstValidation + gstNumber,
      {},
      ApiRequestType.get,
    );
    logger.d(reqTask.data);
    logger.d(reqTask.status);
    if (reqTask.status == ApiStatus.success) {
      final gstResponse = GSTResponse.fromJson(reqTask.data!);
      task.data = gstResponse;
      task.status = ApiStatus.success;
    } else {
      task.data = null;
      task.status = reqTask.status;
      task.errorMessage = reqTask.errorMessage;
    }
    return task;
  }

  Future<ApiTask<GSTCreditsResponse>> getGSTCredits() async {
    ApiTask<GSTCreditsResponse> task = ApiTask.empty();
    ApiTask<Map<String, dynamic>> reqTask = await sendReq<Map<String, dynamic>>(
      ApiRoutes.gstCredits,
      {},
      ApiRequestType.get,
    );
    logger.d(reqTask.data);
    logger.d(reqTask.status);
    if (reqTask.status == ApiStatus.success) {
      task.data = GSTCreditsResponse.fromJson(reqTask.data!);
      task.status = ApiStatus.success;
    } else {
      task.data = null;
      task.status = reqTask.status;
      task.errorMessage = reqTask.errorMessage;
    }
    return task;
  }
}
