import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:product_bat/core/network/dio_client.dart';
import 'package:product_bat/domain/usecase/fetch_list_product.dart';
import 'package:product_bat/domain/usecase/get_detail_product.dart';
import 'package:product_bat/presentation/cubit/product_cubit.dart';

import '../../data/datasource/remote/remote.dart';
import '../../data/repositories/repository_impl.dart';
import '../../domain/repositories/repositories_domain.dart';

final sl = GetIt.instance;

Future<void> init(String baseUrl) async {
  // Base DioClient
  sl.registerLazySingleton(() => DioClient(baseUrl));

  // Dio instance dari DioClient
  sl.registerLazySingleton<Dio>(() => sl<DioClient>().dio);

  // Data source
  sl.registerLazySingleton<Remote>(() => RemoteDataImpl(sl()));

  // Repository
  sl.registerLazySingleton<RepositoriesDomain>(() => RepositoryImpl(sl()));

  // Usecase
  sl.registerLazySingleton(() => FetchListProduct(sl()));
  sl.registerLazySingleton(() => GetDetailProduct(sl()));

  // Cubit
  sl.registerFactory(
    () => ProductCubit(sl<FetchListProduct>(), sl<GetDetailProduct>()),
  );
}
