import 'package:either_dart/either.dart';

abstract class UseCase<Params, Result> {
  Future<Either<Exception, Result>> call(Params params);
}
