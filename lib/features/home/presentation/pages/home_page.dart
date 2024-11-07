import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:weather_location_manager/features/home/data/model/city_model.dart';
import 'package:weather_location_manager/features/home/data/remote/city_datasource_impl.dart';
import 'package:weather_location_manager/features/home/presentation/widgets/city_container.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final CityDataSourceImpl cityDatasource = CityDataSourceImpl(Dio());

  @override
  Widget build(BuildContext context) {
    final cities = getCities();
    return FutureBuilder(
      future: cities,
      builder: (context, cities) => Scaffold(
          appBar: AppBar(
            title: const Text('Home Page'),
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              return ListView.builder(
                  itemCount: cities.data?.length,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CityContainer(
                            city: cities.data?[index],
                            ));
                  });
            },
          )),
    );
  }

  Future<List<CityModel>> getCities() async {
    final cities = await cityDatasource.getCities();
    return cities.fold((l) => List.empty(), (r) => r);
  }

  // deleteCity(String? id) async {
  //   await cityDatasource.deleteCity(id ?? '');
  // }
}
