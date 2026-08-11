import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voxflow/feature/submit_task/presentation/state/submit_task_event.dart';
import 'package:voxflow/feature/submit_task/presentation/state/submit_task_state.dart';
import 'package:voxflow/feature/submit_task/domain/usecase/submit_audio_usecase.dart';
import 'package:voxflow/feature/submit_task/domain/usecase/submit_text_usecase.dart';

class SubmitTaskBloc extends Bloc<SubmitTaskEvent, SubmitTaskState> {
  final SubmitAudioUseCase submitAudio;
  final SubmitTextUseCase submitText;
  Timer? _timer;
  final SpeechToText _speechToText = SpeechToText();
  String _fullTranscript = '';
  String _currentSessionWords = '';

  SubmitTaskBloc({required this.submitAudio, required this.submitText})
      : super(SubmitTaskState()) {
    on<StartRecordingEvent>(_onStart);
    on<PauseRecordingEvent>(_onPause);
    on<ResumeRecordingEvent>(_onResume);
    on<TimerTickEvent>(_onTick);
    on<StopRecordingEvent>(_onStop);
    on<ToggleInputModeEvent>(_onToggleMode);
    on<SubmitTextEvent>(_onSubmitText);
    on<ResetSubmitTaskEvent>(_onReset);
    on<RecordingErrorEvent>(_onError);
  }

  void _onError(RecordingErrorEvent event, Emitter<SubmitTaskState> emit) {
    emit(state.copyWith(error: event.error, status: RecordingStatus.idle));
  }

  void _onReset(ResetSubmitTaskEvent event, Emitter<SubmitTaskState> emit) {
    emit(SubmitTaskState()); // Reset to initial state completely
  }

  void _onToggleMode(ToggleInputModeEvent event, Emitter<SubmitTaskState> emit) {
    emit(state.copyWith(isVoiceMode: event.isVoiceMode));
  }

  Future<void> _onStart(StartRecordingEvent event, Emitter<SubmitTaskState> emit) async {
    try {
      bool available = await _speechToText.initialize(
        onError: (error) => add(RecordingErrorEvent(error.errorMsg)),
        onStatus: (status) => print('Speech status: $status'),
      );

      if (available) {
        _fullTranscript = '';
        _currentSessionWords = '';
        await _speechToText.listen(onResult: (result) {
          _currentSessionWords = result.recognizedWords;
        });
      
        _timer?.cancel();
        _timer = Timer.periodic(const Duration(seconds: 1), (_) {
          add(TimerTickEvent());
        });
        emit(SubmitTaskState(
          status: RecordingStatus.recording,
          isVoiceMode: state.isVoiceMode,
        ));
      } else {
        emit(state.copyWith(error: "Speech recognition not available"));
      }
    } catch (e) {
      emit(state.copyWith(error: "Failed to start recording: $e"));
    }
  }

  void _onTick(TimerTickEvent event, Emitter<SubmitTaskState> emit) {
     if (state.status == RecordingStatus.recording) {
      emit(state.copyWith(elapsed: state.elapsed + const Duration(seconds: 1)));
    }
  }

  Future<void> _onPause(PauseRecordingEvent event, Emitter<SubmitTaskState> emit) async {
    _timer?.cancel();
    await _speechToText.stop();
    if (_currentSessionWords.isNotEmpty) {
      _fullTranscript += (_fullTranscript.isEmpty ? "" : " ") + _currentSessionWords;
      _currentSessionWords = '';
    }
    emit(state.copyWith(status: RecordingStatus.paused));
  }

  Future<void> _onResume(ResumeRecordingEvent event, Emitter<SubmitTaskState> emit) async {
    if (state.status == RecordingStatus.paused) {
      if (!_speechToText.isListening) {
         // Re-initialize might not be needed but listen is
         await _speechToText.listen(onResult: (result) {
            _currentSessionWords = result.recognizedWords;
         });
      }

      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        add(TimerTickEvent());
      });
      emit(state.copyWith(status: RecordingStatus.recording));
    }
  }

  Future<void> _onStop(StopRecordingEvent event, Emitter<SubmitTaskState> emit) async {
    _timer?.cancel();
    emit(state.copyWith(status: RecordingStatus.idle, submitting: true));
    
    await _speechToText.stop();
    if (_currentSessionWords.isNotEmpty) {
      _fullTranscript += (_fullTranscript.isEmpty ? "" : " ") + _currentSessionWords;
      _currentSessionWords = '';
    }

    // Simulate processing delay for transition smoothness
    await Future.delayed(const Duration(seconds: 1));
    
    emit(state.copyWith(
      submitting: false,
      isVoiceMode: false,
      initialText: _fullTranscript, // Use actual transcribed text
      elapsed: Duration.zero,
    ));
    // Reset internal state for next time
    _fullTranscript = '';
    _currentSessionWords = '';
  }

  Future<void> _onSubmitText(SubmitTextEvent event, Emitter<SubmitTaskState> emit) async {
    emit(state.copyWith(submitting: true, error: null, isSuccess: false));
    try {
      await submitText(event.text);
      emit(state.copyWith(submitting: false, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(submitting: false, error: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
