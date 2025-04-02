part of 'timer_bloc.dart';

enum TimerStatus {
  init,
  timerInProgress,
  timerComplete,
}

class TimerState extends Equatable {
  final TimerStatus status;
  final int duration;

  const TimerState({
    this.status = TimerStatus.init,
    this.duration = 0,
  });

  @override
  List<Object?> get props => [status, duration];

  TimerState timerInProgress(int duration) {
    return _copyWith(
      status: TimerStatus.timerInProgress,
      duration: duration,
    );
  }

  TimerState timerComplete() {
    return _copyWith(
      status: TimerStatus.timerComplete,
      duration: 0,
    );
  }

  TimerState _copyWith({
    required TimerStatus status,
    required int duration,
  }) {
    return TimerState(
      status: status,
      duration: duration,
    );
  }
}
