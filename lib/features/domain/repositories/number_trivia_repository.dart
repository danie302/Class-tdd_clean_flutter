import 'package:clean_architecture_tddd/core/error/failures.dart';
import 'package:clean_architecture_tddd/features/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number);
}
