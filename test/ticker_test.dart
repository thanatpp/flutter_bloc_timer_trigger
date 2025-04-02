import 'package:flutter_bloc_timer_trigger/utils/timer_ticker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Ticker', () {
    test('emits [2, 1, 0] countdown sequence and completes when ticks more than 0', () {
      const ticker = TimerTicker();
      expectLater(
        ticker.tick(period: const Duration(microseconds: 1), ticks: 3),
        emitsInOrder([2, 1, 0]),
      );
    });

    test('emits empty countdown sequence and completes when ticks equal 0', () {
      const ticker = TimerTicker();
      expectLater(
        ticker.tick(period: const Duration(microseconds: 1), ticks: 0),
        emitsInOrder([]),
      );
    });

    test('emits empty countdown sequence and completes when less than 0', () {
      const ticker = TimerTicker();
      expectLater(
        ticker.tick(period: const Duration(microseconds: 1), ticks: -1),
        emitsInOrder([]),
      );
    });
  });
}
