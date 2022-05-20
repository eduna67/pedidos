import 'dart:developer';


import 'app/repositories/product_repository.dart';

void main() async {
  final _pro = ProductRepository();

  final products = await _pro.findALL();

  for (var p in products) {
    log('p.toMap(): ', name: p.toMap().toString());
    // print(p.toJson());
    // print(p.toString());
  }

  print(products);
  //Transforma o retorno em json, o produto é um map
  final products_to_map = products.map((p) => p.toMap()).toList();
  print(products_to_map.toString());

  // teste o arquivo .env
  
  // var env = DotEnv(includePlatformEnvironment: true)..load();

  // p('read all vars? ${env.isEveryDefined([
  //       'databaseHost',
  //       'databasePort',
  //       'xpto'
  //     ])}');

  // p('databaseHost=${env['databaseHost']}');
  // p('databasePort=${env['databasePort']}');
  // p('your home directory is: ${env['HOME']}');

  // env.clear();
  // p('cleared!');

  // p('env has key databaseHost? ${env.isDefined('databaseHost')}');
  // p('env has key databasePort? ${env.isDefined('databasePort')}');
  // p('your home directory is still: ${env['HOME']}');
}

//p(String msg) => stdout.writeln(msg);
