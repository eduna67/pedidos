import 'dart:developer';

import 'package:mysql1/mysql1.dart';
import 'package:dotenv/dotenv.dart';

class Database {
  Future<MySqlConnection> getConnection() async {
    final env = DotEnv(includePlatformEnvironment: true)..load();
    final host = env['databaseHost'] ?? 'localhost';
    final port = int.parse(env['databasePort'] ?? '3306');
    final user = env['databaseUser'] ?? 'root';
    final password = env['databasePassword'] ?? '';
    final db = env['databaseName'] ?? 'teste';
    //try {
    final connection = await MySqlConnection.connect(ConnectionSettings(
      host: host,
      port: port,
      user: user,
      password: password,
      db: db,
    ));
    MySqlConnection.connect(ConnectionSettings(
      host: host,
      port: port,
      user: user,
      password: password,
      db: db,
    ));
    
    return connection;
    // } on MySqlException catch (e, s) {
    //   print(e);
    //   print(s);
    //   throw Exception();
    // }
  }
}
