import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:weather_location_manager/features/home/data/model/city_model.dart';
import 'package:weather_location_manager/features/home/data/remote/city_datasource_impl.dart';
import 'package:weather_location_manager/features/home/presentation/cubit/city_cubit.dart';
import 'package:weather_location_manager/features/home/presentation/widgets/city_container.dart';
import 'package:weather_location_manager/features/home/presentation/widgets/city_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final CityCubit cityCubit = CityCubit();
  final CityDataSourceImpl cityDatasource = CityDataSourceImpl(Dio());

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 400),
    vsync: this,
  );


  late final Animation<Offset> _offsetAnimation =
      Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero)
          .animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.linear,
  ));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cities = getCities();
    return FutureBuilder(
      future: cities,
      builder: (context, cities) => Scaffold(
          appBar: AppBar(
            title: const Text('Cities'),
            actions: [
              IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _openCityDialog(cities.data, null)),
            ],
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    itemCount: cities.data?.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: Key(cities.data?[index].id ?? ''),
                        onDismissed: (direction) {
                          // deleteCity(cities.data?[index].id);
                        },
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () => _openCityDialog(cities.data, index),
                              child: CityContainer(
                                city: cities.data?[index],
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      );
                    }),
              );
            },
          )),
    );
  }

  Future<List<CityModel>> getCities() async {
    final cities = await cityDatasource.getCities();
    return cities.fold((l) => List.empty(), (r) => r);
  }

  void _openCityDialog(List<CityModel>? cities, int? index) async {
    // Start the animation when opening the dialog
    _controller.reset();
    _controller.forward();

    if (cities == null) return;
    CityModel? city = await showDialog<CityModel>(
      context: context,
      builder: (BuildContext context) {
        return SlideTransition(
            position: _offsetAnimation,
            child: EditCityDialog(city: cities[index ?? 0]));
      },
    );

    if (city != null) {
      if (index != null) {
        cityCubit.updateCity(city);
        setState(() {
          cities[index] = city;
        });
      } else {
        cityCubit.addCity(city);
        // animate with new item
      }
    }
  }

  void _info(String message) async {}

  Widget _loading() {
    return const CircularProgressIndicator();
  }
}
