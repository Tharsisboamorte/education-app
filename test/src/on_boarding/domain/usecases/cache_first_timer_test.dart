import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failures.dart';
import 'package:education_app/src/on_boarding/domain/repository/on_boarding_repo.dart';
import 'package:education_app/src/on_boarding/domain/usecases/cache_first_timer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'on_boarding_repo.mock.dart';

void main() {
  late OnBoardingRepo repository;
  late CacheFirstTimer usecase;

  setUp(() {
    repository = MockOnBoardingRepo();
    usecase = CacheFirstTimer(repository);
  });

  test(
    'should call the [OnBoardingRepository.cacheFirstTimer] '
    'and return the right data',
    () async {
      when(() => repository.cacheFirstTime()).thenAnswer(
        (_) async => Left(
          ServerFailure(message: 'Unknown Error Occurred', statusCode: 500),
        ),
      );

      final result = await usecase();

      expect(
        result,
        equals(
          Left<Failure, dynamic>(
            ServerFailure(
              message: 'Unknown Error Occurred',
              statusCode: 500,
            ),
          ),
        ),
      );

      verify(() => repository.cacheFirstTime()).called(1);
      verifyNoMoreInteractions(repository);
    },
  );
}
