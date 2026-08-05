import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:finora/features/app_initialization/presentation/cubit/app_initialization_cubit.dart';
import 'package:finora/features/app_initialization/presentation/cubit/app_initialization_state.dart';
import 'package:finora/features/user/domain/entities/user.dart';
import 'package:finora/features/user/domain/repositories/user_repository.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late UserRepository mockRepository;
  late AppInitializationCubit initCubit;

  final tUser = User(
    id: '123',
    name: 'Test User',
    preferredCurrencyCode: 'USD',
    preferredLanguage: 'en',
    themeMode: 'system',
    onboardingCompleted: true,
    createdAt: DateTime.utc(2026, 8, 3),
    lastOpenedAt: DateTime.utc(2026, 8, 3),
  );

  setUp(() {
    mockRepository = MockUserRepository();
    initCubit = AppInitializationCubit(mockRepository);
  });

  tearDown(() {
    initCubit.close();
  });

  test('initial state should be AppInitializationInitial', () {
    expect(initCubit.state, const AppInitializationInitial());
  });

  group('initialize', () {
    test('emits [Loading, OnboardingRequired] when user is null', () async {
      when(
        () => mockRepository.getUser(),
      ).thenAnswer((_) async => const Right(null));

      final expectedStates = [
        const AppInitializationLoading(),
        const AppInitializationOnboardingRequired(),
      ];

      final future = expectLater(
        initCubit.stream,
        emitsInOrder(expectedStates),
      );

      await initCubit.initialize();
      await future;
    });

    test(
      'emits [Loading, OnboardingRequired] when onboarding is not completed',
      () async {
        final uncompletedUser = tUser.copyWith(onboardingCompleted: false);
        when(
          () => mockRepository.getUser(),
        ).thenAnswer((_) async => Right(uncompletedUser));

        final expectedStates = [
          const AppInitializationLoading(),
          const AppInitializationOnboardingRequired(),
        ];

        final future = expectLater(
          initCubit.stream,
          emitsInOrder(expectedStates),
        );

        await initCubit.initialize();
        await future;
      },
    );

    test(
      'emits [Loading, AppInitializationCompleted] when user onboarding is completed',
      () async {
        registerFallbackValue(tUser);
        when(
          () => mockRepository.getUser(),
        ).thenAnswer((_) async => Right(tUser));
        when(
          () => mockRepository.saveUser(any()),
        ).thenAnswer((_) async => const Right(null));

        final expectedStates = [
          const AppInitializationLoading(),
          isA<AppInitializationCompleted>(),
        ];

        final future = expectLater(
          initCubit.stream,
          emitsInOrder(expectedStates),
        );

        await initCubit.initialize();
        await future;
      },
    );
  });
}
