import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_location_manager/features/home/data/model/city_model.dart';
import 'package:weather_location_manager/features/home/presentation/bloc/city_cubit.dart';
import 'package:weather_location_manager/features/home/presentation/bloc/city_state.dart';
import 'package:weather_location_manager/features/home/presentation/widgets/city_dialog.dart';
import 'package:weather_location_manager/features/home/presentation/widgets/city_item_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final listKey = GlobalKey<AnimatedListState>();

  late final AnimationController _dialogAnimationController =
      AnimationController(
    duration: const Duration(milliseconds: 400),
    vsync: this,
  );

  late final Animation<Offset> _dialogOffsetAnimation =
      Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero)
          .animate(CurvedAnimation(
    parent: _dialogAnimationController,
    curve: Curves.linear,
  ));

  @override
  void initState() {
    context.read<CityCubit>().getCities();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CityCubit, CityState>(listener: (context, state) {
      if (state is CitySuccessState) {
        _info(state.message ?? "", true);
      } else if (state is CityErrorState) {
        _info(state.message ?? "", false);
      }
    }, child: BlocBuilder<CityCubit, CityState>(builder: (context, state) {
      if (state is CityLoadingState) {
        return _loading();
      } else {
        return _buildCityList(state.cities ?? []);
      }
    }));
  }

  @override
  void dispose() {
    _dialogAnimationController.dispose();
    super.dispose();
  }

  Widget _buildCityList(List<CityModel> cities) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Cities'),
          actions: [
            IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _addCity(CityModel(
                    city: "Barra Grande",
                    temperature: "40",
                    description: "description"))),
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: AnimatedList(
                  key: listKey,
                  initialItemCount: cities.length,
                  itemBuilder: (context, index, animation) {
                    return CityItemList(
                        city: cities[index],
                        animation: animation,
                        onRemoveTap: () => _removeCity(index),
                        onDismissed: () => context
                            .read<CityCubit>()
                            .deleteCity(cities[index].id ?? ''),
                        onTap: () => _openCityDialog(index));
                  }),
            );
          },
        ));
  }

  void _openCityDialog(int? index) async {
    _dialogAnimationController.reset();
    _dialogAnimationController.forward();
    final cityCubit = context.read<CityCubit>();
    final cities = cityCubit.state.cities;

    if (cities == null) return;
    CityModel? city = await showDialog<CityModel>(
      context: context,
      builder: (BuildContext context) {
        return SlideTransition(
            position: _dialogOffsetAnimation,
            child: EditCityDialog(city: index != null ? cities[index] : null));
      },
    );

    if (city != null) {
      final cityCubit = context.read<CityCubit>();
      if (index != null) {
        cityCubit.updateCity(city);
      } else {
        _addCity(city);
      }
    }
  }

  void _addCity(CityModel city) {
    final cityCubit = context.read<CityCubit>();
    cityCubit.cities.insert(0, city);
    listKey.currentState?.insertItem(
      0,
      duration: const Duration(milliseconds: 500),
    );
  }

  void _removeCity(int index) {
    final cityCubit = context.read<CityCubit>();
    final removedCity = cityCubit.state.cities?[index];
    cityCubit.cities.removeAt(index);

    if (removedCity != null) {
      listKey.currentState?.removeItem(
        index,
        (context, animation) => CityItemList(
          city: removedCity,
          animation: animation,
          onRemoveTap: () {},
          onDismissed: () {},
          onTap: () {},
        ),
        duration: const Duration(milliseconds: 300),
      );

      // cityCubit.deleteCity(removedCity.id ?? "");
    }
  }

  void _info(String message, bool isSuccess) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
      ));
    });
  }

  Widget _loading() {
    return const Center(child: CircularProgressIndicator());
  }
}
