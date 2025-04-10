import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc_timer_trigger/bloc/timer_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'helper_test.mocks.dart';

void main() {
  group('TimerBloc', () {
    late MockTimerTicker mockTicker;
    late MockFakeRepository mockFakeRepository;
    late TimerBloc bloc;

    const expectedState = TypeMatcher<TimerState>();

    setUp(() {
      mockTicker = MockTimerTicker();
      mockFakeRepository = MockFakeRepository();
      bloc = TimerBloc(ticker: mockTicker, fakeRepository: mockFakeRepository);
    });

    tearDown(() => bloc.close());

    test('initial state is collect', () {
      expect(bloc.state.status, TimerStatus.init);
      expect(bloc.state.duration, 0);
    });

    group('TimerStarted', () {
      blocTest(
        'should be calculate duration collect when call TimerStarted',
        build: () => bloc,
        act: (bloc) {
          when(mockTicker.tick(
            period: anyNamed("period"),
            ticks: anyNamed("ticks"),
          )).thenAnswer((invocation) {
            return Stream<int>.value(189);
          });

          bloc.add(const TimerStarted(start: '2024-11-20T15:50:15', end: '2024-11-20T15:53:25'));
        },
        expect: () => [
          expectedState
              .having(
                (state) => state.status,
            'status should be timerInProgress',
            TimerStatus.timerInProgress,
          )
              .having(
                (state) => state.duration,
            'duration should be 190',
            190,
          ),
          expectedState
              .having(
                (state) => state.status,
                'status should be timerInProgress',
                TimerStatus.timerInProgress,
              )
              .having(
                (state) => state.duration,
                'duration should be 9',
                189,
              )
        ],
        verify: (bloc) {
          verify(mockTicker.tick(
            period: argThat(equals(const Duration(seconds: 1)), named: "period"),
            ticks: argThat(equals(190), named: "ticks"),
          )).called(1);

          verify(mockTicker.tick(
            period: argThat(equals(const Duration(minutes: 1)), named: "period"),
            ticks: argThat(equals(3), named: "ticks"),
          )).called(1);
        },
      );
    });

    group('TimerTicked', () {
      blocTest(
        'should be emit [timerInProgress] and valid state when call TimerTicked with duration more than 0',
        build: () => bloc,
        act: (bloc) {
          bloc.add(const TimerTicked(duration: 20));
        },
        expect: () => [
          expectedState
              .having(
                (state) => state.status,
                'status should be timerInProgress',
                TimerStatus.timerInProgress,
              )
              .having(
                (state) => state.duration,
                'duration should be 20',
                20,
              )
        ],
      );

      blocTest(
        'should be emit [timerComplete] and valid state when call TimerTicked with duration less than 0',
        build: () => bloc,
        act: (bloc) {
          bloc.add(const TimerTicked(duration: 0));
        },
        expect: () => [
          expectedState
              .having(
                (state) => state.status,
                'status should be timerComplete',
                TimerStatus.timerComplete,
              )
              .having(
                (state) => state.duration,
                'duration should be 0',
                0,
              )
        ],
      );
    });

    group('TimerCallApi', () {
      blocTest('should be emit call fetchData when call TimerCallApi with duration more than 0',
          build: () => bloc,
          act: (bloc) {
            bloc.add(const TimerCallApi(duration: 2));
          },
          verify: (_) {
            verify(mockFakeRepository.fetchData()).called(1);
          });

      blocTest('should be emit call fetchData when call TimerCallApi with duration less than 0',
          build: () => bloc,
          act: (bloc) {
            bloc.add(const TimerCallApi(duration: 0));
          },
          verify: (_) {
            verifyNever(mockFakeRepository.fetchData());
          });
    });
  });
}
