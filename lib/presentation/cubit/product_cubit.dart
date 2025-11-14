import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:product_bat/domain/usecase/fetch_list_product.dart';
import 'package:product_bat/domain/usecase/get_detail_product.dart';

import '../../domain/entities/product_entity.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final FetchListProduct fetchListProduct;
  final GetDetailProduct getDetailProduct;

  ProductCubit(this.fetchListProduct, this.getDetailProduct)
    : super(ProductInitial());

  Future<void> getListProduct() async {
    emit(ListProductLoading());
    final result = await fetchListProduct.execute();

    result.fold(
      (l) => emit(ListProductError(l)),
      (r) => emit(ListProductLoaded(r)),
    );
  }

  Future<void> detailProduct(int id) async {
    emit(ProductLoading());
    final result = await getDetailProduct.execute(id);

    result.fold((l) => emit(ProductError(l)), (r) => emit(ProductLoaded(r)));
  }
}
