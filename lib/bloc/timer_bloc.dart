import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc_timer_trigger/repositories/fake_repository.dart';
import 'package:flutter_bloc_timer_trigger/utils/timer_ticker.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final TimerTicker _ticker;
  final FakeRepository _fakeRepository;

  StreamSubscription<int>? _tickerTimerSubscription;
  StreamSubscription<int>? _tickerCallApiSubscription;

  TimerBloc({required TimerTicker ticker, required FakeRepository fakeRepository})
      : _ticker = ticker,
        _fakeRepository = fakeRepository,
        super(const TimerState()) {
    on<TimerStarted>(_onStaredTimer);
    on<TimerTicked>(_onTimerTicked);
    on<TimerCallApi>(_onTimerHandleCallApi);
    on<TimerComplete>(_onTimerComplete);
  }

  @override
  Future<void> close() {
    _clearTimer();
    return super.close();
  }

  void _onStaredTimer(
    TimerStarted event,
    Emitter<TimerState> emit,
  ) {
    final start = DateTime.parse(event.start);
    final end = DateTime.parse(event.end);
    final duration = end.difference(start);

    emit(state.timerInProgress(duration.inSeconds));
    _setTimer(duration);
  }

  void _setTimer(Duration duration) {
    _clearTimer();
    _tickerTimerSubscription =
        _ticker.tick(period: const Duration(seconds: 1), ticks: duration.inSeconds).listen((duration) {
      print("timer: $duration");
      add(TimerTicked(duration: duration));
    });

    _tickerCallApiSubscription =
        _ticker.tick(period: const Duration(minutes: 1), ticks: duration.inMinutes).listen((duration) {
      print("call api: $duration");
      add(TimerCallApi(duration: duration));
    });
  }

  void _onTimerTicked(
    TimerTicked event,
    Emitter<TimerState> emit,
  ) {
    if (event.duration > 0) {
      emit(state.timerInProgress(event.duration));
    } else {
      add(const TimerComplete());
    }
  }

  Future<void> _onTimerComplete(
    TimerComplete event,
    Emitter<TimerState> emit,
  ) async {
    _clearTimer();
    emit(state.timerComplete());
  }

  Future<void> _onTimerHandleCallApi(
    TimerCallApi event,
    Emitter<TimerState> emit,
  ) async {
    await _fakeRepository.fetchData();
  }

  void _clearTimer() {
    _tickerTimerSubscription?.cancel();
    _tickerCallApiSubscription?.cancel();
  }
}
