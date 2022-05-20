
import 'dart:io';
import 'package:dotenv/dotenv.dart';

class GetEnv {

  static Future<DotEnv> _getEnv() async {
    var env = DotEnv(includePlatformEnvironment: true)..load();
    return env;
  }

  static Future<String> getEnvVar(String key) async {
    var env = await _getEnv();
    return env[key].toString();
  }

  static Future<String> getEnvVar1(String key, {String ?defaultValue}) async {
    defaultValue ??= '';
    var value = Platform.environment[key];
    if (value == null) {
      return defaultValue;
    }
    return value;
  }

  var env = DotEnv(includePlatformEnvironment: true)..load();

}