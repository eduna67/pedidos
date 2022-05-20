import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:selects_api/app/repositories/product_repository.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'product_controller.g.dart';

class ProductController {
  final _pro = ProductRepository();

  @Route.get('/findAll')
  Future<Response> find(Request request) async {
    final products = await _pro.findALL();
    //Transforma o retorno em json, o produto é um map
    final products_to_map = products.map((p) => p.toMap()).toList();
    try {
      return Response.ok(products_to_map          ,
        headers: {'content-type': 'application/json'},
      );
    } catch (e, s) {
      print(e);
      print(s);
      log('Erro ao buscar produtos', error: e, stackTrace: s);
      return Response.internalServerError();
    }
  }

  Router get router => _$ProductControllerRouter(this);
}
