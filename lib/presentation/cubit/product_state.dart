part of 'product_cubit.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ListProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final ProductEntity data;

  const ProductLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}

class ListProductLoaded extends ProductState {
  final List<ProductEntity> products;

  const ListProductLoaded(this.products);

  @override
  List<Object?> get props => [products];
}

class ListProductError extends ProductState {
  final String message;

  const ListProductError(this.message);

  @override
  List<Object?> get props => [message];
}
