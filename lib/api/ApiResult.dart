class ApiResult{
  final bool status;
  final String message;
  final dynamic data;

  ApiResult({
    required this.status,
    required this.message,
    required this.data
  });
}