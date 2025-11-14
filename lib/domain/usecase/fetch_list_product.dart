import 'package:dartz/dartz.dart';
import 'package:product_bat/domain/entities/product_entity.dart';

import '../repositories/repositories_domain.dart';

class FetchListProduct {
  final RepositoriesDomain repositoriesDomain;

  FetchListProduct(this.repositoriesDomain);

  Future<Either<String, List<ProductEntity>>> execute() async {
    return await repositoriesDomain.getListProduct();
  }
}
