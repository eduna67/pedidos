import 'dart:io';

import 'package:selects_api/app/core/modules/auth/auth_controller.dart';
import 'package:selects_api/app/core/modules/product/product_controller.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
// import 'package:dotenv/dotenv.dart';

// Configure routes.
final _router = Router()
  ..mount('/auth/', AuthController().router)
  ..mount('/produto/', ProductController().router)
  ..get('/', _rootHandler)
  ..get('/echo/<message>', _echoHandler);

void main(List<String> args) async {

  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // var env = await DotEnv(includePlatformEnvironment: true)..load();

  // Load environment variables from .env file.

  // Configure a pipeline that logs requests.
  final _handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await shelf_io.serve(_handler, ip, port);
  print('Servidor iniciando no ip $ip e porta  ${server.port}');
}
Response _rootHandler(Request req) {
  return Response.ok('Olá, primeiro back-end em dart v.2022.05.17',headers: {'content-type': 'application/json'});
}

Response _echoHandler(Request request) {
  final message = request.params['message'];
  return Response.ok('$message',headers: {'content-type': 'application/json'});
}

