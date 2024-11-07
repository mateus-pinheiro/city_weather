import 'package:either_dart/either.dart';
import 'package:weather_location_manager/core/usecase/use_case.dart';
import 'package:weather_location_manager/features/home/domain/repositories/city_repository.dart';

class RemoveCityUsecase extends UseCase<String, bool> {
  final CityRepository repository;

  RemoveCityUsecase(this.repository);

  @override
  Future<Either<Exception, bool>> call(String params) async {
    return await repository.deleteCity(params);
  }
}
