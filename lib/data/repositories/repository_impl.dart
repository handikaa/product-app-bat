import 'package:dartz/dartz.dart';
import 'package:product_bat/domain/entities/product_entity.dart';
import 'package:product_bat/domain/repositories/repositories_domain.dart';

import '../datasource/remote/remote.dart';

class RepositoryImpl implements RepositoriesDomain {
  final Remote remote;

  RepositoryImpl(this.remote);

  @override
  Future<Either<String, List<ProductEntity>>> getListProduct() async {
    try {
      final result = await remote.getListProduct();

      final entities = result.map((model) => model.toEntity()).toList();

      return Right(entities);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, ProductEntity>> getDetailProduct(int id) async {
    try {
      final result = await remote.getDetailProduct(id);

      final entities = result.toEntity();

      return Right(entities);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
