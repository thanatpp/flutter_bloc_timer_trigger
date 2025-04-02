class TimerTicker {
  const TimerTicker();

  Stream<int> tick({
    required Duration period,
    required int ticks,
  }) {
    final nTicks = ticks < 0 ? 0 : ticks;
    return Stream.periodic(period, (count) => ticks - count - 1).take(nTicks);
  }
}
