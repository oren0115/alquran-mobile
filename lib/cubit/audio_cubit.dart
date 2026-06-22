import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

import '../models/ayat.dart';
import 'audio_state.dart';

class AudioCubit extends Cubit<AudioState> {
  AudioCubit({AudioPlayer? player})
      : _player = player ?? AudioPlayer(),
        super(const AudioState()) {
    _stateSub = _player.playerStateStream.listen(_onPlayerState);
  }

  final AudioPlayer _player;
  StreamSubscription<PlayerState>? _stateSub;

  AudioPlayer get player => _player;

  void _onPlayerState(PlayerState playerState) {
    final current = state.current;
    if (current == null) return;

    if (playerState.processingState == ProcessingState.completed) {
      emit(const AudioState());
      return;
    }

    emit(
      AudioState(
        current: current,
        isPlaying: playerState.playing,
        isLoading: playerState.processingState == ProcessingState.loading ||
            playerState.processingState == ProcessingState.buffering,
      ),
    );
  }

  Future<String?> toggleAyat(Ayat ayat, String qari) async {
    final surah = ayat.nomorSurah;
    if (surah == null) return 'Data surah tidak lengkap';

    final key = (surah: surah, ayat: ayat.nomorAyat);

    if (state.matches(surah, ayat.nomorAyat)) {
      if (_player.playing) {
        await _player.pause();
        return null;
      }
      if (_player.processingState != ProcessingState.idle) {
        await _player.play();
        return null;
      }
    }

    final url = ayat.audio?[qari];
    if (url == null || url.isEmpty) {
      return 'Audio tidak tersedia untuk qari ini';
    }

    try {
      emit(AudioState(current: key, isLoading: true));
      await _player.stop();
      await _player.setUrl(url);
      await _player.play();
    } catch (e) {
      emit(const AudioState());
      return 'Gagal memutar audio: ${e.toString()}';
    }
    return null;
  }

  Future<void> stop() async {
    await _player.stop();
    emit(const AudioState());
  }

  @override
  Future<void> close() {
    _stateSub?.cancel();
    unawaited(_player.dispose());
    return super.close();
  }
}
