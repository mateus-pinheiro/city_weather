import 'package:dio/dio.dart';
import 'package:weather_location_manager/features/home/data/model/city_model.dart';
import 'package:weather_location_manager/features/home/data/remote/city_datasource_impl.dart';
import 'package:weather_location_manager/features/home/data/repository_impl/city_repository_impl.dart';
import 'package:weather_location_manager/features/home/domain/repositories/city_repository.dart';

class CityCubit {
  final CityRepository _cityRepository =
      CityRepositoryImpl(CityDataSourceImpl(Dio()));

  CityCubit();

  Future<List<CityModel>> getCities() async {
    // emit(CityState.loading());
    final either = await _cityRepository.getCities();
    return either.fold((l) {
      // emit(CityState.error(l.toString()));
      return [];
    }, (r) {
      // emit(CityState.success(r))
      return r;
    });
  }

  Future<void> deleteCity(String id) async {
    final either = await _cityRepository.deleteCity(id);
    return either.fold((l) {
      // emit(CityState.error(l.toString()));
    }, (r) {
      // emit(CityState.success(r))
    });
  }

  Future<void> updateCity(CityModel city) async {
    final either = await _cityRepository.updateCity(city);
    return either.fold((l) {
      // emit(CityState.error(l.toString()));
    }, (r) {
      // emit(CityState.success(r))
    });
  }

  Future<void> addCity(CityModel city) async {
    final either = await _cityRepository.newCity(city);
    return either.fold((l) {
      // emit(CityState.error(l.toString()));
    }, (r) {
      // emit(CityState.success(r))
    });
  }
}
