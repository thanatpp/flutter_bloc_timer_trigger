import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_timer_trigger/repositories/fake_repository_impl.dart';
import 'package:flutter_bloc_timer_trigger/third_screen.dart';

import 'utils/timer_ticker.dart';
import 'bloc/timer_bloc.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TimerBloc(ticker: const TimerTicker(), fakeRepository: FakeRepositoryImpl()),
      child: _TimerScreenState(),
    );
  }
}

class _TimerScreenState extends StatelessWidget {
  final TextEditingController startController = TextEditingController();
  final TextEditingController endController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Flutter Demo Home Page'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(64.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const TimerText(),
                TextField(
                  controller: startController,
                  decoration: const InputDecoration(
                    labelText: 'start',
                  ),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: endController,
                  decoration: const InputDecoration(
                    labelText: 'end',
                  ),
                ),
                const SizedBox(height: 64),
                SizedBox(
                  height: 42,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<TimerBloc>().add(
                            TimerStarted(
                              start: startController.text,
                              end: endController.text,
                            ),
                          );
                    },
                    child: const Text('Start'),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: 42,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<TimerBloc>().add(const TimerComplete());
                    },
                    child: const Text('Stop'),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: 42,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const ThirdScreen()),
                      );
                    },
                    child: const Text('Next Page'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TimerText extends StatelessWidget {
  const TimerText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final duration = context.select((TimerBloc bloc) => bloc.state.duration);
    final minutesStr = ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final secondsStr = (duration % 60).floor().toString().padLeft(2, '0');
    return Text(
      '$minutesStr:$secondsStr',
      style: Theme.of(context).textTheme.displayLarge,
    );
  }
}
