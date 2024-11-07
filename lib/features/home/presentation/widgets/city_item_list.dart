import 'package:flutter/material.dart';
import 'package:weather_location_manager/features/home/data/model/city_model.dart';
import 'package:weather_location_manager/features/home/presentation/widgets/city_container.dart';

class CityItemList extends StatelessWidget {
  const CityItemList(
      {super.key,
      required this.city,
      required this.animation,
      required this.onDismissed,
      required this.onRemoveTap,
      required this.onTap});

  final CityModel? city;
  final Animation<double> animation;
  final VoidCallback onDismissed;
  final VoidCallback onTap;
  final VoidCallback onRemoveTap;

  @override
  Widget build(BuildContext context) => SizeTransition(
        sizeFactor: animation,
        child: buildItem(),
      );

  Widget buildItem() {
    return Dismissible(
      key: Key(city?.id.toString() ?? ""),
      onDismissed: (direction) {
        onDismissed();
        // deleteCity(cities.data?[index].id);
      },
      child: Column(
        children: [
          GestureDetector(
            onTap: () => onTap(),
            child: CityContainer(
              city: city,
              deleteCity: onRemoveTap,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
