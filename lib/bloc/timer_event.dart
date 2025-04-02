part of 'timer_bloc.dart';

sealed class TimerEvent {
  const TimerEvent();
}

final class TimerStarted extends TimerEvent {
  final String start;
  final String end;

  const TimerStarted({
    required this.start,
    required this.end,
  });
}

final class TimerComplete extends TimerEvent {
  const TimerComplete();
}

final class TimerTicked extends TimerEvent {
  final int duration;

  const TimerTicked({
    required this.duration,
  });
}

final class TimerCallApi extends TimerEvent {
  final int duration;

  const TimerCallApi({
    required this.duration,
  });
}
