class CityModel {
  final DateTime createdAt;
  final String city;
  final String avatar;
  final String temperature;
  final String description;
  final String id;

  CityModel({
    required this.createdAt,
    required this.city,
    required this.avatar,
    required this.temperature,
    required this.description,
    required this.id,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      createdAt: DateTime.parse(json['createdAt']),
      city: json['city'],
      avatar: json['avatar'],
      temperature: json['temperature'],
      description: json['description'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt.toIso8601String(),
      'city': city,
      'avatar': avatar,
      'temperature': temperature,
      'description': description,
      'id': id,
    };
  }
}
