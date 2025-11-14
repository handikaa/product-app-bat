import 'package:dartz/dartz.dart';
import 'package:product_bat/domain/entities/product_entity.dart';

import '../repositories/repositories_domain.dart';

class GetDetailProduct {
  final RepositoriesDomain repositoriesDomain;

  GetDetailProduct(this.repositoriesDomain);

  Future<Either<String, ProductEntity>> execute(int id) async {
    return await repositoriesDomain.getDetailProduct(id);
  }
}
