import 'dart:convert';

import 'package:clean_architecture_tddd/features/data/models/number_trivia_model.dart';
import 'package:clean_architecture_tddd/features/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test Text');

  test(
    'should be a subclass of NumberTrivia entity',
    () async {
      // Arrange
      expect(tNumberTriviaModel, isA<NumberTrivia>());
      // Act
      // Assert
    },
  );

  group('fromJSON', (){
    test('should return a valid model when then JSON number is an integer', 
    () async {
      // Arrange
      final Map<String, dynamic> jsonMap =
        json.decode(fixture('trivia.json'));
      // Act
      final result = NumberTriviaModel.fromJson(jsonMap);
      // Assert
      expect(result, tNumberTriviaModel);
    });
    test('should return a valid model when then JSON number is an regarded as a double', 
    () async {
      // Arrange
      final Map<String, dynamic> jsonMap =
        json.decode(fixture('trivia_double.json'));
      // Act
      final result = NumberTriviaModel.fromJson(jsonMap);
      // Assert
      expect(result, tNumberTriviaModel);
    });
  });

  group('to JSON', (){
    test('should return a JSON map', 
    () async {
      // Arrange
      // Act
      final result = tNumberTriviaModel.toJson();
      // Assert
      final expectedMap = {
        "text": "Test Text",
        "number": 1,
      };
      expect(result, expectedMap);
    });
  });
}