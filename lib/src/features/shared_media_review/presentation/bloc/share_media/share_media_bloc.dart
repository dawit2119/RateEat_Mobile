import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
// import 'package:flutter_sharing_intent/model/sharing_file.dart';

import 'share_media_event.dart';
import 'share_media_state.dart';

class SharedMediaBloc extends Bloc<SharedMediaEvent, SharedMediaState> {
  SharedMediaBloc()
      : super(const SharedMediaState(status: SharedMediaStatus.initial)) {
    on<LoadSharedMedia>(_onLoadSharedMedia);
    on<ClearSharedMedia>(_onClearSharedMedia);
  }

  void _onLoadSharedMedia(
      LoadSharedMedia event, Emitter<SharedMediaState> emit) {
    emit(const SharedMediaState(status: SharedMediaStatus.loading));
    if (event.media!.isNotEmpty) {
      List<SharedMediaFile> mediaFiles = event.media!;
      emit(
        SharedMediaState(
          status: SharedMediaStatus.loaded,
          sharedFiles: mediaFiles,
        ),
      );
    }
  }

  void _onClearSharedMedia(
      ClearSharedMedia event, Emitter<SharedMediaState> emit) {
    emit(const SharedMediaState(status: SharedMediaStatus.initial));
  }
}
