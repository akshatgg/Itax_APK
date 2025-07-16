class ApiTask<T> {
  ApiStatus status;
  T? data;
  String errorMessage;

  ApiTask.empty({
    this.status = ApiStatus.unknown,
    this.data,
    this.errorMessage = '',
  });
}

enum ApiStatus { success, fail, serverError, unknown, requestCancelled }
