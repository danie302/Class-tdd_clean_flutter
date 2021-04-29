import 'package:clean_architecture_tddd/core/error/exceptions.dart';
import 'package:clean_architecture_tddd/core/platform/network_info.dart';
import 'package:clean_architecture_tddd/features/data/datasources/number_trivia_local_datasource.dart';
import 'package:clean_architecture_tddd/features/data/datasources/number_trivia_remote_datasource.dart';
import 'package:clean_architecture_tddd/features/data/models/number_trivia_model.dart';
import 'package:clean_architecture_tddd/features/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_architecture_tddd/features/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tddd/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockRemoteDataSource extends Mock implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp((){
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestOffline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel(number: tNumber, text: 'test Trivia');
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test('should check if the device is online', 
    () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // Act
      repository.getConcreteNumberTrivia(tNumber);
      // Assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestOnline(() {
      test('should return remote data when the call to remote data source is successfull', () async {
        // Arrange
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
          .thenAnswer((_) async => tNumberTriviaModel);
        // Act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        // Assert
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, Right(tNumberTrivia));
      });

      test('should cache the data locally when the call to remote data source is successfull', () async {
        // Arrange
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
          .thenAnswer((_) async => tNumberTriviaModel);
        // Act
        await repository.getConcreteNumberTrivia(tNumber);
        // Assert
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test('should return server failure when the call to remote data source is unsuccessfull', () async {
        // Arrange
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
          .thenThrow(ServerException());
        // Act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        // Assert
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, Left(ServerFailure()));
      });
    });

    runTestOffline(() {

      test('should return last locally cached data when the cacherd data is present', () async {
        // Arrange
        when(mockLocalDataSource.getLastNumberTrivia())
          .thenAnswer((_) async => tNumberTriviaModel);
        // Act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        // Assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, Right(tNumberTrivia));
      });

      test('should return CacheFailure when there is no cached data present', () async {
        // Arrange
        when(mockLocalDataSource.getLastNumberTrivia())
          .thenThrow(CacheException());
        // Act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        // Assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, Left(CacheFailure()));
      });
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel(number: 123, text: 'test Trivia');
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test('should check if the device is online', 
    () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // Act
      repository.getRandomNumberTrivia();
      // Assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestOnline(() {
      test('should return remote data when the call to remote data source is successfull', () async {
        // Arrange
        when(mockRemoteDataSource.getRandomNumberTrivia())
          .thenAnswer((_) async => tNumberTriviaModel);
        // Act
        final result = await repository.getRandomNumberTrivia();
        // Assert
        verify(mockRemoteDataSource.getRandomNumberTrivia());
        expect(result, Right(tNumberTrivia));
      });

      test('should cache the data locally when the call to remote data source is successfull', () async {
        // Arrange
        when(mockRemoteDataSource.getRandomNumberTrivia())
          .thenAnswer((_) async => tNumberTriviaModel);
        // Act
        await repository.getRandomNumberTrivia();
        // Assert
        verify(mockRemoteDataSource.getRandomNumberTrivia());
        verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test('should return server failure when the call to remote data source is unsuccessfull', () async {
        // Arrange
        when(mockRemoteDataSource.getRandomNumberTrivia())
          .thenThrow(ServerException());
        // Act
        final result = await repository.getRandomNumberTrivia();
        // Assert
        verify(mockRemoteDataSource.getRandomNumberTrivia());
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, Left(ServerFailure()));
      });
    });

    runTestOffline(() {

      test('should return last locally cached data when the cacherd data is present', () async {
        // Arrange
        when(mockLocalDataSource.getLastNumberTrivia())
          .thenAnswer((_) async => tNumberTriviaModel);
        // Act
        final result = await repository.getRandomNumberTrivia();
        // Assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, Right(tNumberTrivia));
      });

      test('should return CacheFailure when there is no cached data present', () async {
        // Arrange
        when(mockLocalDataSource.getLastNumberTrivia())
          .thenThrow(CacheException());
        // Act
        final result = await repository.getRandomNumberTrivia();
        // Assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, Left(CacheFailure()));
      });
    });
  });
}