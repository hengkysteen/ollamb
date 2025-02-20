abstract class HttpClientInterface {
  Future<dynamic> get({required String url});
  Future<dynamic> post({required String url, Map<String, dynamic>? body});
  Future<dynamic> delete({required String url, Map<String, dynamic>? body});
  Future<dynamic> stream({required String url, required String method, Map<String, dynamic>? body});
}
