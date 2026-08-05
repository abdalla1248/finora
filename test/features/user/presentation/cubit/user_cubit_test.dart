import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:finora/features/user/domain/entities/user.dart';
import 'package:finora/features/user/domain/repositories/user_repository.dart';
import 'package:finora/features/user/presentation/cubit/user_cubit.dart';
import 'package:finora/features/user/presentation/cubit/user_state.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late UserRepository mockRepository;
  late UserCubit userCubit;

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
    userCubit = UserCubit(mockRepository);
  });

  tearDown(() {
    userCubit.close();
  });

  test('initial state should be UserInitial', () {
    expect(userCubit.state, const UserInitial());
  });

  group('loadUser', () {
    test('emits [UserLoading, UserLoaded] when user is retrieved', () async {
      when(
        () => mockRepository.getUser(),
      ).thenAnswer((_) async => Right(tUser));

      final expectedStates = [const UserLoading(), UserLoaded(tUser)];

      final future = expectLater(
        userCubit.stream,
        emitsInOrder(expectedStates),
      );

      await userCubit.loadUser();
      await future;
    });

    test(
      'emits [UserLoading, UserLoaded(null)] when user does not exist',
      () async {
        when(
          () => mockRepository.getUser(),
        ).thenAnswer((_) async => const Right(null));

        final expectedStates = [const UserLoading(), const UserLoaded(null)];

        final future = expectLater(
          userCubit.stream,
          emitsInOrder(expectedStates),
        );

        await userCubit.loadUser();
        await future;
      },
    );
  });

  group('createUser', () {
    test('emits [UserLoading, UserLoaded] when creation succeeds', () async {
      registerFallbackValue(tUser);
      when(
        () => mockRepository.saveUser(any()),
      ).thenAnswer((_) async => const Right(null));

      final expectedStates = [
        const UserLoading(),
        isA<UserLoaded>().having((s) => s.user?.name, 'name', 'New User'),
      ];

      final future = expectLater(
        userCubit.stream,
        emitsInOrder(expectedStates),
      );

      await userCubit.createUser(
        name: 'New User',
        preferredCurrencyCode: 'EUR',
        preferredLanguage: 'en',
        themeMode: 'dark',
      );
      await future;
    });
  });

  group('clearUser', () {
    test(
      'emits [UserLoading, UserLoaded(null)] when clearing succeeds',
      () async {
        when(
          () => mockRepository.clearUser(),
        ).thenAnswer((_) async => const Right(null));

        final expectedStates = [const UserLoading(), const UserLoaded(null)];

        final future = expectLater(
          userCubit.stream,
          emitsInOrder(expectedStates),
        );

        await userCubit.clearUser();
        await future;
      },
    );
  });
}
