// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:dio/dio.dart';

class BaseRemoteHandler {
  final Dio dio;

  BaseRemoteHandler(this.dio);

  Future<dynamic> request({
    required String endpoint,
    String method = 'GET',
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    bool withAuth = true,
  }) async {
    try {
      Response response;

      switch (method.toUpperCase()) {
        case 'POST':
          response = await dio.post(endpoint, data: data);
          break;
        case 'PUT':
          response = await dio.put(endpoint, data: data);
          break;
        case 'DELETE':
          response = await dio.delete(endpoint, data: data);
          break;
        default:
          response = await dio.get(endpoint, queryParameters: queryParameters);
      }

      final statusCode = response.statusCode ?? 500;

      if (statusCode == 200 || statusCode == 201) {
        final resData = response.data;

        if (resData is Map<String, dynamic> && resData.containsKey('data')) {
          return resData['data'];
        }

        return resData;
      }

      final message = response.data?['error'] ?? 'Gagal memproses permintaan';

      throw Exception(message);
    } on DioException catch (e, stackTrace) {
      final String errorMessage;

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        errorMessage = 'Koneksi ke server timeout. Periksa jaringan Anda.';
      } else if (e.type == DioExceptionType.badResponse) {
        final data = e.response?.data;
        String extractedMessage =
            'Server mengembalikan kesalahan (${e.response?.statusCode})';

        if (data != null) {
          if (data is Map<String, dynamic>) {
            if (data.containsKey('error')) {
              final errors = data['error'];

              if (errors is String) {
                extractedMessage = errors;
              } else if (errors is Map<String, dynamic>) {
                final firstKey = errors.keys.isNotEmpty
                    ? errors.keys.first
                    : null;
                final firstValue = firstKey != null ? errors[firstKey] : null;

                if (firstValue is List && firstValue.isNotEmpty) {
                  extractedMessage = firstValue.first.toString();
                } else if (firstValue is String) {
                  extractedMessage = firstValue;
                } else {
                  extractedMessage = data['error'] ?? extractedMessage;
                }
              }
            } else if (data.containsKey('message')) {
              extractedMessage = data['message'];
            }
          }
        }

        errorMessage = extractedMessage;
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'Tidak ada koneksi internet. Coba lagi nanti.';
      } else {
        errorMessage = 'Terjadi kesalahan koneksi (${e.message})';
      }

      throw Exception(errorMessage);
    } on TimeoutException catch (e, stackTrace) {
      const msg = 'Waktu koneksi habis. Silakan coba lagi.';

      throw Exception(msg);
    } catch (e, stackTrace) {
      final msg = 'Terjadi kesalahan tidak terduga: $e';

      throw Exception(msg);
    }
  }
}
