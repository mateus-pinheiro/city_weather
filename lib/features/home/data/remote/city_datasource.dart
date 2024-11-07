import 'package:either_dart/either.dart';
import 'package:weather_location_manager/features/home/data/model/city_model.dart';

abstract class CityDataSource {
  Future<Either<Exception, List<CityModel>>> getCities();
  Future<Either<Exception, CityModel>> getCityById(String id);
  Future<Either<Exception, CityModel>> newCity(CityModel city);
  Future<Either<Exception, CityModel>> updateCity(CityModel city);
  Future<Either<Exception, bool>> deleteCity(String id);
}
