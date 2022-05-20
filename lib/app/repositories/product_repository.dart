import 'package:mysql1/mysql1.dart';
import 'package:selects_api/app/core/database/database.dart';
import 'package:selects_api/app/entities/product.dart';

class ProductRepository {
  Future<List<Product>> findALL() async {
    MySqlConnection? conn;
    try {
      conn = await Database().getConnection();
      final result = await conn.query('SELECT * FROM produto');
      return result
          .map(
            (p) => Product(
              id: p['id'],
              nome: p['nome'],
              descricao: (p['descricao'] as Blob?)?.toString() ?? '',
              preco: p['preco'],
              imagem: (p['imagem'] as Blob?)?.toString() ?? '',
            ),
          )
          .toList();
    } on MySqlException catch (e, s) {
      print(e);
      print(s);
      throw Exception();
    } finally {
      await conn?.close();
    }
  }

  Future<Product> findById(int id) async {
    MySqlConnection? conn;
    try {
      conn = await Database().getConnection();
      final result = await conn.query('SELECT * FROM produto WHERE id = ?', [id]);
      return result
          .map(
            (p) => Product(
              id: p['id'],
              nome: p['nome'],
              descricao: (p['descricao'] as Blob?)?.toString() ?? '',
              preco: p['preco'],
              imagem: (p['imagem'] as Blob?)?.toString() ?? '',
            ),
          )
          .first;
    } on MySqlException catch (e, s) {
      print(e);
      print(s);
      throw Exception();
    } finally {
      await conn?.close();
    }
  }
}
