import 'package:equatable/equatable.dart';

class BackupState extends Equatable {
  final bool isExporting;
  final bool isImporting;
  final String? exportPayload;
  final String? statusMessage;
  final String? errorMessage;

  const BackupState({
    this.isExporting = false,
    this.isImporting = false,
    this.exportPayload,
    this.statusMessage,
    this.errorMessage,
  });

  BackupState copyWith({
    bool? isExporting,
    bool? isImporting,
    String? exportPayload,
    String? statusMessage,
    String? errorMessage,
  }) {
    return BackupState(
      isExporting: isExporting ?? this.isExporting,
      isImporting: isImporting ?? this.isImporting,
      exportPayload: exportPayload ?? this.exportPayload,
      statusMessage: statusMessage,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    isExporting,
    isImporting,
    exportPayload,
    statusMessage,
    errorMessage,
  ];
}
