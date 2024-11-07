import 'package:flutter/material.dart';
import 'package:weather_location_manager/features/home/data/model/city_model.dart';

class CityContainer extends StatefulWidget {
  const CityContainer({super.key, this.city, this.deleteCity});

  final CityModel? city;
  final VoidCallback? deleteCity;

  @override
  CityContainerState createState() => CityContainerState();
}

class CityContainerState extends State<CityContainer> {
  @override
  Widget build(BuildContext context) {
    return _buildContainerContent();
  }

  Widget _buildContainerContent() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CityContainerInfo(
            city: widget.city,
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () => widget.deleteCity!(),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}

class CityContainerInfo extends StatelessWidget {
  const CityContainerInfo({super.key, this.city});
  final CityModel? city;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${city?.city} -',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Text(
                city?.temperature ?? '',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            city?.description ?? '',
            style: const TextStyle(color: Colors.white),
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}


  