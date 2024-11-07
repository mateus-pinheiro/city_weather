import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:weather_location_manager/features/home/data/model/city_model.dart';
import 'package:weather_location_manager/features/home/data/remote/city_datasource.dart';

const String kBaseUrl = 'https://672ba4801600dda5a9f5dcbf.mockapi.io/api/v1';

class CityDataSourceImpl implements CityDataSource {
  final Dio dio;

  CityDataSourceImpl(this.dio);

  @override
  Future<Either<Exception, List<CityModel>>> getCities() async {
    try {
      final response = await dio.get('$kBaseUrl/city');
      final List<CityModel> cities = (response.data as List)
          .map((city) => CityModel.fromJson(city))
          .toList();

      return Right(cities);
    } on DioException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, CityModel>> getCityById(String id) async {
    try {
      final response = await dio.get('$kBaseUrl/city/$id');
      final city = CityModel.fromJson(response.data);

      return Right(city);
    } on DioException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, bool>> deleteCity(String id) async {
    try {
      await dio.delete('$kBaseUrl/city/$id');
      return const Right(true);
    } on DioException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, bool>> newCity(CityModel city) async {
    try {
      await dio.post('$kBaseUrl/city', data: city.toJson());
      return const Right(true);
    } on DioException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, CityModel>> updateCity(CityModel city) async {
    try {
      final response =
          await dio.put('$kBaseUrl/city/${city.id}', data: city.toJson());
      final cityUpdated = CityModel.fromJson(response.data);
      return Right(cityUpdated);
    } on DioException catch (e) {
      return Left(e);
    }
  }
}
