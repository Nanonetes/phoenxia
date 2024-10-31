import 'dart:convert';
import 'dart:io';

class Phoenixa {
  late final HttpServer server;
  final Map<String, Function(HttpRequest, HttpResponse)> routes = {};

  Future<void> listen({
    required InternetAddress address,
    required int port,
    Function? callback,
  }) async {
    server = await HttpServer.bind(
      address,
      port,
    );
    if (callback != null) callback();
    requestHandler();
  }

  Future<void> requestHandler() async {
    await for (HttpRequest request in server) {
      String route = '${request.method.toUpperCase()} ${request.uri.path}';
      final handler = routes[route];
      if (handler != null) handler(request, request.response);
      if (handler == null) {
        request.response
            .setStatus(200)
            .sendJson({'error': 'Cant ${request.method} ${request.uri.path}'});
        return;
      }
    }
  }

  void route({
    required String method,
    required String path,
    required Function(HttpRequest, HttpResponse) callback,
  }) {
    routes['${method.toUpperCase()} $path'] = callback;
  }
}

extension ResponseExtensions on HttpResponse {
  HttpResponse setStatus(code) {
    statusCode = code;
    return this;
  }

  Future<void> sendFile({
    required String path,
    required String mime,
  }) async {
    headers.contentType = ContentType(
      mime.split('/').first,
      mime.split('/').last,
    );
    final file = File(path);
    final readStream = file.openRead();
    await readStream.pipe(this);
  }

  Future<void> sendJson(data) async {
    headers.contentType = ContentType.json;
    final json = jsonEncode(data);
    final jsonStream = Stream.value(json.codeUnits);
    await jsonStream.pipe(this);
  }
}
