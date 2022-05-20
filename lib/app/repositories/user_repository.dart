import 'package:mysql1/mysql1.dart';
import 'package:selects_api/app/core/Exceptions/email_exist.dart';
import 'package:selects_api/app/core/Exceptions/user_not_found.dart';
import 'package:selects_api/app/core/database/database.dart';
import 'package:selects_api/app/entities/user.dart';
import 'package:selects_api/app/core/util/cripty.dart';

class UserRepository {
  Future<void> save(User user) async {
    MySqlConnection? conn;
    try {
      conn = await Database().getConnection();

      final isUserExist = await conn.query(
        'SELECT * FROM usuario WHERE email = ?',
        [user.email],
      );

      if (isUserExist.isEmpty) {
        await conn.query(
          'INSERT INTO usuario (nome, email, senha) VALUES (?, ?, ? )',
          [
            user.nome,
            user.email,
            Cripty.generetedSha256Hash(user.senha),
          ],
        );
      } else {
        throw EmailExist('Email já cadastrado');
      }
    } on MySqlException catch (e, s) {
      print(e);
      print(s);
      throw Exception();
    } finally {
      await conn?.close();
    }
  }

  Future<User> login(String email, String senha) async {
    MySqlConnection? conn;
    try {
      conn = await Database().getConnection();

      final isUserExist = await conn.query(
        'SELECT * FROM usuario WHERE email = ? and senha =?',
        [email, Cripty.generetedSha256Hash(senha)],
      );

      if (isUserExist.isEmpty) {
        throw UserNotFound();
      } else {
        final userDb = isUserExist.first;
        return User(
          id: userDb['id'],
          nome: userDb['nome'],
          email: userDb['email'],
          senha: '',
        );
      }
    } on MySqlException catch (e, s) {
      print(e);
      print(s);
      throw Exception('Erro ao buscar usuário');
    } finally {
      await conn?.close();
    }
  }
}
