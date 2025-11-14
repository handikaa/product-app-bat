import 'package:dartz/dartz.dart';
import 'package:product_bat/domain/entities/product_entity.dart';

abstract class RepositoriesDomain {
  Future<Either<String, List<ProductEntity>>> getListProduct();
  Future<Either<String, ProductEntity>> getDetailProduct(int id);
}
