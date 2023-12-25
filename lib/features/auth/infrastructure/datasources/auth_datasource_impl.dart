import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';

class AuthDataSourceImpl extends AuthDataSource {

  final dio = Dio(
    BaseOptions(
      baseUrl: Environment.apiUrl
    )
  );

  @override
  Future<User> checkAuthStatus(String token) {
    throw UnimplementedError();
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        }
      );
      final user = UserMapper.userJsonToEntity(response.data);

      return user;

    } on DioException catch (e) {
      // if (kDebugMode) print('>> [auth_datasource_impl] DioException (e): $e');
      // if (e.response?.statusCode == 401) throw WrongCredentials();
      if (e.response?.statusCode == 401){
        if(kDebugMode){
         print('>> [auth_datasource_impl] e.response?.statusCode = ${e.response?.statusCode}');
         print('>> [auth_datasource_impl] e.response?.data[message] = ${e.response?.data['message']}');
        }

        throw CustomError(e.response?.data['message'] ?? 'Error de credenciales');
      }


      if (e.type == DioExceptionType.connectionTimeout){
        if(kDebugMode) print('>> DioExceptionType.connectionTimeout');
        throw CustomError('Error de conexión');
      }

      throw Exception();
    
    } catch (e) {
      // if (kDebugMode) print('>> [auth_datasource_impl.dart] Exception: $e');
      throw Exception();
    }
  }

  @override
  Future<User> register(String email, String password, String fullName) {
    throw UnimplementedError();
  }

}