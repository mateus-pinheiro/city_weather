import 'package:either_dart/either.dart';
import 'package:weather_location_manager/features/home/data/model/city_model.dart';
import 'package:weather_location_manager/features/home/data/remote/city_datasource.dart';
import 'package:weather_location_manager/features/home/domain/repositories/city_repository.dart';

class CityRepositoryImpl implements CityRepository {
  final CityDataSource cityDataSource;

  CityRepositoryImpl(this.cityDataSource);

  @override
  Future<Either<Exception, List<CityModel>>> getCities() async {
    return await cityDataSource.getCities();
  }

  @override
  Future<Either<Exception, bool>> deleteCity(String id) async {
    return await cityDataSource.deleteCity(id);
  }

  @override
  Future<Either<Exception, CityModel>> getCityById(String id) async {
    return await cityDataSource.getCityById(id);
  }

  @override
  Future<Either<Exception, CityModel>> newCity(CityModel city) async {
    return await cityDataSource.newCity(city);
  }

  @override
  Future<Either<Exception, CityModel>> updateCity(CityModel city) async {
    return await cityDataSource.updateCity(city);
  }
}
