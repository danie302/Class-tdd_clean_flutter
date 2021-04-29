import 'package:clean_architecture_tddd/core/error/failures.dart';
import 'package:clean_architecture_tddd/core/usecases/usecase.dart';
import 'package:clean_architecture_tddd/features/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tddd/features/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTrivia, Params> {
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(Params params) async {
    return await repository.getConcreteNumberTrivia(params.number);
  }
}
