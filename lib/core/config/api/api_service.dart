import 'package:dio/dio.dart';

import '../../../core/constants/network_constants.dart';
import '../../../core/utils/logger.dart';
import 'api_task.dart';

class ApiService {
  final Dio dio;

  final Map<String, CancelToken> cancelTokens = {};

  ApiService()
      : dio = Dio(BaseOptions(
          baseUrl: networkUrl,
          responseType: ResponseType.json,
        ));

  void cancelActiveRequest(String requestId) {
    CancelToken? cancelToken = cancelTokens[requestId];
    if (cancelToken != null) {
      cancelTokens[requestId]?.cancel('Request $requestId cancelled by user');
      cancelTokens.remove(requestId);
    }
  }

  Future<ApiTask<T>> sendReq<T>(
    String url,
    Object? body,
    ApiRequestType type, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    ApiTask<T> task = ApiTask.empty();
    CancelToken cancelToken = CancelToken();
    cancelTokens[url] = cancelToken;
    try {
      final Response<T> res;
      switch (type) {
        case ApiRequestType.post:
          res = await dio.post<T>(
            url,
            data: body,
            queryParameters: queryParameters,
            options: Options(headers: headers),
          );
        case ApiRequestType.put:
          res = await dio.put<T>(url, data: body);
        case ApiRequestType.delete:
          res = await dio.delete<T>(url, data: body);
        case ApiRequestType.get:
          res = await dio.get<T>(url, data: body);
      }
      if (res.statusCode == 200 || res.statusCode == 201) {
        task.data = res.data;
        task.status = ApiStatus.success;
      } else {
        task.errorMessage =
            (res.data as Map<String, dynamic>?)?['message'].toString() ?? '';
        logger.d('response ${res.data}');
      }
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        task.status = ApiStatus.requestCancelled;
        task.errorMessage = 'Request Cancelled by user';
      } else {
        task.data = null;
        task.status = ApiStatus.serverError;
        task.errorMessage = e.response?.data['message'].toString() ?? '';
        logger.d('Error response ${task.errorMessage}');
      }
      logger.d('$url Error : $e');
    }
    cancelTokens.remove(url);
    return task;
  }
}

enum ApiRequestType { get, post, put, delete }
