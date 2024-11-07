import 'package:either_dart/either.dart';
import 'package:weather_location_manager/core/usecase/use_case.dart';
import 'package:weather_location_manager/features/home/data/model/city_model.dart';
import 'package:weather_location_manager/features/home/domain/repositories/city_repository.dart';

class GetCitiesUsecase extends UseCase<void, List<CityModel>> {
  final CityRepository repository;

  GetCitiesUsecase(this.repository);

  @override
  Future<Either<Exception, List<CityModel>>> call(void params) async {
    return await repository.getCities();
  }
}
