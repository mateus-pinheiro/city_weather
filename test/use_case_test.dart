import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:either_dart/either.dart';
import 'package:weather_location_manager/features/home/data/model/city_model.dart';
import 'package:weather_location_manager/features/home/domain/repositories/city_repository.dart';
import 'package:weather_location_manager/features/home/domain/use_case/add_city_usecase.dart';

class MockCityRepository extends Mock implements CityRepository {}

void main() {
  late AddCityUsecase usecase;
  late MockCityRepository mockRepository;

  setUp(() {
    mockRepository = MockCityRepository();
    usecase = AddCityUsecase(mockRepository);
  });

  group('AddCityUsecase', () {
    final city = CityModel(city: 'New York', description: '', temperature: '');

    test('should return CityModel on successful addition', () async {
      when(mockRepository.newCity(city))
          .thenAnswer((_) async => Right<Exception, CityModel>(city));

      final result = await usecase.call(city);

      // Assert: Verify the usecase returns the correct city
      expect(result.isRight, true);
      expect(result.right, city);
      verify(mockRepository.newCity(city)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return an Exception on failure', () async {
      final exception = Exception('Failed to add city');
      when(mockRepository.newCity(city))
          .thenAnswer((_) async => Left<Exception, CityModel>(exception));

      final result = await usecase.call(city);

      // Assert: Verify the usecase returns the exception
      expect(result.isLeft, true);
      expect(result.left, exception);
      verify(mockRepository.newCity(city)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
