import 'package:dio/dio.dart';

import '../../../core/utils/api_constant.dart';
import '../../model/product_model.dart';
import 'base_remote_handler.dart';

abstract class Remote {
  Future<List<ProductModel>> getListProduct();
  Future<ProductModel> getDetailProduct(int id);
}

class RemoteDataImpl implements Remote {
  final Dio dio;
  final BaseRemoteHandler _handler;

  RemoteDataImpl(this.dio) : _handler = BaseRemoteHandler(dio);

  @override
  Future<List<ProductModel>> getListProduct() async {
    final result = await _handler.request(
      endpoint: ApiConstant.listProduct,
      method: 'GET',
      withAuth: true,
    );

    if (result is List) {
      return result
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    throw Exception("Format data brand tidak sesuai");
  }

  @override
  Future<ProductModel> getDetailProduct(int id) async {
    final result = await _handler.request(
      endpoint: "${ApiConstant.detailProduct}/$id",
      method: 'GET',
      withAuth: true,
    );

    if (result is Map<String, dynamic>) {
      return ProductModel.fromJson(result);
    }

    throw Exception("Format data brand tidak sesuai");
  }
}
