enum RecordingStatus { idle, recording, paused }

class SubmitTaskState {
  final RecordingStatus status;
  final Duration elapsed;
  final bool submitting;
  final String? error;
  final bool isVoiceMode;
  final bool isSuccess;
  final String? initialText;

  SubmitTaskState({
    this.status = RecordingStatus.idle,
    this.elapsed = Duration.zero,
    this.submitting = false,
    this.error,
    this.isVoiceMode = true,
    this.isSuccess = false,
    this.initialText,
  });

  SubmitTaskState copyWith({
    RecordingStatus? status,
    Duration? elapsed,
    bool? submitting,
    String? error,
    bool? isVoiceMode,
    bool? isSuccess,
    String? initialText,
  }) => SubmitTaskState(
        status: status ?? this.status,
        elapsed: elapsed ?? this.elapsed,
        submitting: submitting ?? this.submitting,
        error: error,
        isVoiceMode: isVoiceMode ?? this.isVoiceMode,
        isSuccess: isSuccess ?? this.isSuccess,
        initialText: initialText ?? this.initialText,
      );
}
