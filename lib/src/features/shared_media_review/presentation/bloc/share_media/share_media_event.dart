import 'package:equatable/equatable.dart';
// import 'package:flutter_sharing_intent/model/sharing_file.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

abstract class SharedMediaEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadSharedMedia extends SharedMediaEvent {
  final List<SharedMediaFile>? media;

  LoadSharedMedia({required this.media});

  @override
  List<Object?> get props => [media];
}

class ClearSharedMedia extends SharedMediaEvent {}
