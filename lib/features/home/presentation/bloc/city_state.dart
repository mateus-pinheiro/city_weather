import 'package:weather_location_manager/features/home/data/model/city_model.dart';

class CityState {
  final List<CityModel>? cities;

  CityState({this.cities});
}

class CityLoadingState extends CityState {
  final bool? isLoading;

  CityLoadingState({required this.isLoading});
}

class CitySuccessState extends CityState {
  final String? message;

  CitySuccessState({required this.message, super.cities});
}

class CityErrorState extends CityState {
  final String? message;

  CityErrorState({required this.message});
}
