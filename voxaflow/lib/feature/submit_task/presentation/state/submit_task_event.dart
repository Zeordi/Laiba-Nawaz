abstract class SubmitTaskEvent {}

class StartRecordingEvent extends SubmitTaskEvent {}
class PauseRecordingEvent extends SubmitTaskEvent {}
class ResumeRecordingEvent extends SubmitTaskEvent {}
class StopRecordingEvent extends SubmitTaskEvent {}
class TimerTickEvent extends SubmitTaskEvent {}
class ToggleInputModeEvent extends SubmitTaskEvent {
  final bool isVoiceMode;
  ToggleInputModeEvent(this.isVoiceMode);
}
class SubmitTextEvent extends SubmitTaskEvent {
  final String text;
  SubmitTextEvent(this.text);
}

class ResetSubmitTaskEvent extends SubmitTaskEvent {}
class RecordingErrorEvent extends SubmitTaskEvent {
  final String error;
  RecordingErrorEvent(this.error);
}
