import 'package:calories/infrastructure/mapper/calories_mapper.dart';
import 'package:calories/infrastructure/models/request/calories_request.dart';
import 'package:calories/infrastructure/models/response/calories_response.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio;

  ApiService(String baseUrl)
      : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 60),
            receiveTimeout: const Duration(seconds: 60),
            headers: {'Content-Type': 'application/json'},
          ),
        );

  Future<Either<String, CaloriesResponse>> predictCalories(
      CaloriesRequest request) async {
    try {
      final response = await _dio.post(
        '/predict',
        data: CaloriesMapper.fromCaloriesRequestToMap(request),
      );

      final CaloriesResponse data =
          CaloriesMapper.fromMapToCaloriesResponse(response.data);

      return Right(data);
    } on DioException catch (e) {
      if (e.response != null) {
        return Left('Error en la API: ${e.response?.data}');
      } else {
        return Left('Error de conexión: ${e.message}');
      }
    } catch (e) {
      return Left('Error inesperado: $e');
    }
  }
}
