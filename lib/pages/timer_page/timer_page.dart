import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:minimalist_state_management_timer_app/pages/timer_page/timer_page_logic.dart';
import 'package:minimalist_state_management_timer_app/services/service_locator.dart';

final logger = Logger();

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  TimerPageState createState() => TimerPageState();
}

class TimerPageState extends State<TimerPage> {
  final stateManager = getIt<TimerPageManager>();

  @override
  void initState() {
    stateManager.initTimerState();
    super.initState();
  }

  @override
  void dispose() {
    stateManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logger.d('building MyHomePage');
    return Scaffold(
      appBar: AppBar(title: const Text('My Timer App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            TimerTextWidget(),
            SizedBox(height: 20),
            ButtonsContainer(),
          ],
        ),
      ),
    );
  }
}

class TimerTextWidget extends StatelessWidget {
  const TimerTextWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final stateManager = getIt<TimerPageManager>();
    return ValueListenableBuilder<String>(
      valueListenable: stateManager.timeLeftNotifier,
      builder: (context, timeLeft, child) {
        logger.d('building time left state: $timeLeft');
        return Text(
          timeLeft,
          style: Theme.of(context).textTheme.headline2,
        );
      },
    );
  }
}

class ButtonsContainer extends StatelessWidget {
  const ButtonsContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stateManager = getIt<TimerPageManager>();
    return ValueListenableBuilder<ButtonState>(
      valueListenable: stateManager.buttonNotifier,
      builder: (context, buttonState, child) {
        logger.d('building button state: $buttonState');
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (buttonState == ButtonState.initial) ...[
              const StartButton(),
            ],
            if (buttonState == ButtonState.started) ...[
              const PauseButton(),
              const SizedBox(width: 20),
              const ResetButton(),
            ],
            if (buttonState == ButtonState.paused) ...[
              const StartButton(),
              const SizedBox(width: 20),
              const ResetButton(),
            ],
            if (buttonState == ButtonState.finished) ...[
              const ResetButton(),
            ],
          ],
        );
      },
    );
  }
}

class StartButton extends StatelessWidget {
  const StartButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        final stateManager = getIt<TimerPageManager>();
        stateManager.start();
      },
      child: const Icon(Icons.play_arrow),
    );
  }
}

class PauseButton extends StatelessWidget {
  const PauseButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        final stateManager = getIt<TimerPageManager>();
        stateManager.pause();
      },
      child: const Icon(Icons.pause),
    );
  }
}

class ResetButton extends StatelessWidget {
  const ResetButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        final stateManager = getIt<TimerPageManager>();
        stateManager.reset();
      },
      child: const Icon(Icons.replay),
    );
  }
}
