import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimerState {
  final int time;
  final bool isTimerFinished;

  TimerState({required this.time, required this.isTimerFinished});
}

class TimerCubit extends Cubit<TimerState> {
  Timer? _timer;
  static const int _initialTime = 60; // 60 seconds

  TimerCubit() : super(TimerState(time: _initialTime, isTimerFinished: false)) {
    startTimer();
  }

  void startTimer() {
    _timer?.cancel();
    emit(TimerState(time: _initialTime, isTimerFinished: false));
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (state.time > 0) {
        emit(TimerState(time: state.time - 1, isTimerFinished: false));
      } else {
        _timer?.cancel();
        emit(TimerState(time: 0, isTimerFinished: true));
      }
    });
  }

  void restartTimer() {
    startTimer();
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
