import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_location_manager/features/home/data/model/city_model.dart';
import 'package:weather_location_manager/features/home/data/remote/city_datasource_impl.dart';
import 'package:weather_location_manager/features/home/data/repository_impl/city_repository_impl.dart';
import 'package:weather_location_manager/features/home/domain/repositories/city_repository.dart';
import 'package:weather_location_manager/features/home/presentation/bloc/city_state.dart';

class CityCubit extends Cubit<CityState> {
  final CityRepository _cityRepository =
      CityRepositoryImpl(CityDataSourceImpl(Dio()));

  CityCubit(super.initialState);

  List<CityModel> cities = [];

  void getCities() async {
    emit(CityLoadingState(isLoading: true));
    final either = await _cityRepository.getCities();
    either.fold((l) {
      emit(CityErrorState(message: l.toString()));
    }, (r) {
      cities = r;
      emit(CityState(cities: r));
    });
  }

  void deleteCity(String id) async {
    final either = await _cityRepository.deleteCity(id);
    either.fold((l) {
      emit(CityErrorState(message: l.toString()));
    }, (r) {
      cities.removeWhere((city) => city.id == id);
      emit(
          CitySuccessState(message: r ? "City deleted." : "City not deleted.", cities: cities));
    });
    ;
  }

  void updateCity(CityModel city) async {
    final either = await _cityRepository.updateCity(city);
    return either.fold((l) {
      emit(CityErrorState(message: l.toString()));
    }, (r) {
      cities[cities.indexWhere((element) => element.id == city.id)] = city;
      emit(CitySuccessState(message: "City ${r.city} updated."));
    });
  }

  void addCity(CityModel city) async {
    final either = await _cityRepository.newCity(city);
    return either.fold((l) {
      emit(CityErrorState(message: l.toString()));
    }, (r) {
      cities.add(city);
      emit(CitySuccessState(message: r ? "City added." : "City not added."));
    });
  }
}
