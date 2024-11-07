import 'package:flutter/material.dart';
import 'package:weather_location_manager/features/home/data/model/city_model.dart';

class EditCityDialog extends StatefulWidget {
  final CityModel? city;
  const EditCityDialog({super.key, required this.city});

  @override
  EditCityDialogState createState() => EditCityDialogState();
}

class EditCityDialogState extends State<EditCityDialog> {
  late TextEditingController _cityController;
  late TextEditingController _temperatureController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();

    _cityController = TextEditingController(text: widget.city?.city);
    _temperatureController =
        TextEditingController(text: widget.city?.temperature);
    _descriptionController =
        TextEditingController(text: widget.city?.description);
  }

  @override
  void dispose() {
    _cityController.dispose();
    _temperatureController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final updatedCity = CityModel(
      city: _cityController.text,
      temperature: _temperatureController.text,
      description: _descriptionController.text,
      createdAt: widget.city?.createdAt ?? DateTime.now(),
    );

    Navigator.of(context).pop(updatedCity);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.city != null ? 'Edit City Information' : 'Add City Information') ,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(labelText: 'City'),
            ),
            TextField(
              controller: _temperatureController,
              decoration: const InputDecoration(labelText: 'Temperature'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // Cancel button
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveChanges, // Save changes and close dialog
          child: widget.city == null ? const Text('Save new city') : const Text('Update'),
        ),
      ],
    );
  }
}
