import 'package:equatable/equatable.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

enum SharedMediaStatus { initial, loading, loaded, error }

class SharedMediaState extends Equatable {
  final SharedMediaStatus status;
  final List<SharedMediaFile>? sharedFiles;
  final String? errorMessage;

  const SharedMediaState({
    this.status = SharedMediaStatus.initial,
    this.sharedFiles,
    this.errorMessage,
  });

  // Convenience factory methods to easily create different states
  factory SharedMediaState.initial() {
    return const SharedMediaState(status: SharedMediaStatus.initial);
  }

  factory SharedMediaState.loading() {
    return const SharedMediaState(status: SharedMediaStatus.loading);
  }

  factory SharedMediaState.loaded(List<SharedMediaFile> files) {
    return SharedMediaState(
      status: SharedMediaStatus.loaded,
      sharedFiles: files,
    );
  }

  factory SharedMediaState.error(String message) {
    return SharedMediaState(
      status: SharedMediaStatus.error,
      errorMessage: message,
    );
  }

  @override
  List<Object?> get props => [status, sharedFiles, errorMessage];

  @override
  String toString() =>
      'SharedMediaState(status: $status, files: $sharedFiles, error: $errorMessage)';
}
