class SubmitTaskEntity {
  final String id;
  final String? transcript;
  final String? audioPath;
  final DateTime createdAt;

  SubmitTaskEntity({
    required this.id,
    this.transcript,
    this.audioPath,
    required this.createdAt,
  });
}
