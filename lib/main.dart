import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_location_manager/features/home/presentation/bloc/city_cubit.dart';
import 'package:weather_location_manager/features/home/presentation/bloc/city_state.dart';
import 'package:weather_location_manager/features/home/presentation/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'City Weather',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => BlocProvider(
            create: (_) => CityCubit(CityState()), child: const HomePage()),
      },
    );
  }
}
