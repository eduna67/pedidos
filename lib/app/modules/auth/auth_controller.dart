import 'dart:async';
import 'dart:convert';
import 'package:selects_api/app/core/Exceptions/email_exist.dart';
import 'package:selects_api/app/core/Exceptions/user_not_found.dart';
import 'package:selects_api/app/entities/user.dart';
import 'package:selects_api/app/repositories/user_repository.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'auth_controller.g.dart';

class AuthController {
  final _userRepository = UserRepository();

  @Route.post('/login')
  Future<Response> login(Request request) async {
    try {
      //Le o json que vei da internet e converte para um map
      final jsonRq = jsonDecode(await request.readAsString());

      //Procura no banco de dados o usuario com o email e senha informado
      final user =
          await _userRepository.login(jsonRq['email'], jsonRq['senha']);

      //Retorna um OK
      return Response.ok(
        user.toJson(),
        headers: {'content-type': 'application/json'},
      );
    } on UserNotFound catch (e, s) {
      print(e);
      print(s);
      return Response(
        403,
        body: jsonEncode({'error': 'Erro procurando usuário.'}),
        headers: {'content-type': 'application/json'},
      );
    } catch (e, s) {
      print(e);
      print(s);
      return Response.internalServerError();
    }
  }

  @Route.post('/regiter')
  Future<Response> regiter(Request request) async {
    try {
      //Le e converte para o usuário o que vei da internet
      final userRq = User.fromJson(await request.readAsString());

      //Grava no banco de dados
      await _userRepository.save(userRq);

      //Retorna um OK
      return Response.ok(
        jsonEncode({'status': 'Usuário cadastrado com sucesso.'}),
        headers: {'content-type': 'application/json'},
      );
    } on EmailExist catch (e, s) {
      print(e);
      print(s);
      return Response(
        400,
        body: jsonEncode({'error': 'E-mail já utilizado.'}),
        headers: {'content-type': 'application/json'},
      );
    } catch (e, s) {
      print(e);
      print(s);
      return Response.internalServerError();
    }

    //Router get router => _$AuthControllerRouter(this);
  }

  Router get router => _$AuthControllerRouter(this);
}
