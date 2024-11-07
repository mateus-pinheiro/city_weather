import 'package:either_dart/either.dart';
import 'package:weather_location_manager/core/usecase/use_case.dart';
import 'package:weather_location_manager/features/home/data/model/city_model.dart';
import 'package:weather_location_manager/features/home/domain/repositories/city_repository.dart';

class AddCityUsecase extends UseCase<CityModel, bool> {
  final CityRepository repository;

  AddCityUsecase(this.repository);

  @override
  Future<Either<Exception, bool>> call(CityModel params) async {
    return await repository.newCity(params);
  }
}
