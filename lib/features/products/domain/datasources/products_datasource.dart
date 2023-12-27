import 'package:teslo_shop/features/products/domain/entities/product.dart';

abstract class ProductsDatasource {
  Future <List<Product>> getProductByPage({int limit = 10, int offset = 0});
  Future <List<Product>> getProductById(String id);
  Future <List<Product>> searchProductByTerm(String term);
  Future <List<Product>> createUpdateProduct(Map<String, dynamic> productLike);
}