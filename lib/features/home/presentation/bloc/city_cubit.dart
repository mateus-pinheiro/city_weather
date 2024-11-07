import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_location_manager/features/home/data/model/city_model.dart';
import 'package:weather_location_manager/features/home/data/remote/city_datasource_impl.dart';
import 'package:weather_location_manager/features/home/data/repository_impl/city_repository_impl.dart';
import 'package:weather_location_manager/features/home/domain/repositories/city_repository.dart';
import 'package:weather_location_manager/features/home/domain/use_case/add_city_usecase.dart';
import 'package:weather_location_manager/features/home/domain/use_case/get_cities_usecase.dart';
import 'package:weather_location_manager/features/home/domain/use_case/remove_city_usecase.dart';
import 'package:weather_location_manager/features/home/domain/use_case/update_city_usecase.dart';
import 'package:weather_location_manager/features/home/presentation/bloc/city_state.dart';

class CityCubit extends Cubit<CityState> {
  final CityRepository _cityRepository =
      CityRepositoryImpl(CityDataSourceImpl(Dio()));

  late final AddCityUsecase _addCityUsecase;
  late final UpdateCityUsecase _updateCityUsecase;
  late final RemoveCityUsecase _removeCityUsecase;
  late final GetCitiesUsecase _getCitiesUsecase;

  CityCubit(super.initialState) {
    _addCityUsecase = AddCityUsecase(_cityRepository);
    _updateCityUsecase = UpdateCityUsecase(_cityRepository);
    _removeCityUsecase = RemoveCityUsecase(_cityRepository);
    _getCitiesUsecase = GetCitiesUsecase(_cityRepository);
  }

  List<CityModel> cities = [];

  void getCities() async {
    emit(CityLoadingState(isLoading: true));
    final either = await _getCitiesUsecase.call(null);
    either.fold((l) {
      emit(CityErrorState(message: l.toString()));
    }, (r) {
      cities = r;
      emit(CityState(cities: r));
    });
  }

  void deleteCity(String id) async {
    final either = await _removeCityUsecase.call(id);
    either.fold((l) {
      emit(CityErrorState(message: l.toString()));
    }, (r) {
      cities.removeWhere((city) => city.id == id);
      emit(CitySuccessState(
          message: r ? "City deleted." : "City not deleted.", cities: cities));
    });
  }

  void updateCity(CityModel city) async {
    final either = await _updateCityUsecase.call(city);
    return either.fold((l) {
      emit(CityErrorState(message: l.toString()));
    }, (r) {
      cities[cities.indexWhere((element) => element.id == city.id)] = city;
      emit(CitySuccessState(message: "City updated.", cities: cities));
    });
  }

  void addCity(CityModel city) async {
    final either = await _addCityUsecase.call(city);
    return either.fold((l) {
      cities.removeAt(0);
      emit(CityErrorState(message: l.toString()));
    }, (r) {
      cities[0] = r;
      emit(CitySuccessState(message: "City added.", cities: cities));
    });
  }
}
