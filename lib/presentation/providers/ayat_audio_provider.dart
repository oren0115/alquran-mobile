import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../domain/entities/ayat_entity.dart';

final audioPlayerProvider = Provider<AudioPlayer>((ref) {
  final player = AudioPlayer();
  ref.onDispose(() {
    unawaited(player.dispose());
  });
  return player;
});

typedef AyatPlaybackKey = ({int surah, int ayat});

class AyatAudioState {
  const AyatAudioState({
    this.current,
    this.isPlaying = false,
    this.isLoading = false,
  });

  final AyatPlaybackKey? current;
  final bool isPlaying;
  final bool isLoading;

  bool matches(int surah, int ayat) {
    final c = current;
    return c != null && c.surah == surah && c.ayat == ayat;
  }

  AyatAudioState copyWith({
    AyatPlaybackKey? current,
    bool? isPlaying,
    bool? isLoading,
    bool clearCurrent = false,
  }) {
    return AyatAudioState(
      current: clearCurrent ? null : (current ?? this.current),
      isPlaying: isPlaying ?? this.isPlaying,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final ayatAudioProvider =
    NotifierProvider<AyatAudioNotifier, AyatAudioState>(AyatAudioNotifier.new);

class AyatAudioNotifier extends Notifier<AyatAudioState> {
  StreamSubscription<PlayerState>? _stateSub;

  @override
  AyatAudioState build() {
    final player = ref.read(audioPlayerProvider);
    _stateSub?.cancel();

    _stateSub = player.playerStateStream.listen((playerState) {
      final current = state.current;
      if (current == null) return;

      final playing = playerState.playing;
      final loading = playerState.processingState == ProcessingState.loading ||
          playerState.processingState == ProcessingState.buffering;

      if (playerState.processingState == ProcessingState.completed) {
        state = const AyatAudioState();
        return;
      }

      state = AyatAudioState(
        current: current,
        isPlaying: playing,
        isLoading: loading,
      );
    });

    ref.onDispose(() => _stateSub?.cancel());

    return const AyatAudioState();
  }

  Future<String?> toggleAyat(AyatEntity ayat, String qari) async {
    final surah = ayat.nomorSurah;
    if (surah == null) return 'Data surah tidak lengkap';

    final key = (surah: surah, ayat: ayat.nomorAyat);
    final player = ref.read(audioPlayerProvider);

    if (state.matches(surah, ayat.nomorAyat)) {
      if (player.playing) {
        await player.pause();
        return null;
      }
      if (player.processingState != ProcessingState.idle) {
        await player.play();
        return null;
      }
    }

    final url = ayat.audio?[qari];
    if (url == null || url.isEmpty) {
      return 'Audio tidak tersedia untuk qari ini';
    }

    try {
      state = AyatAudioState(current: key, isLoading: true);
      await player.stop();
      await player.setUrl(url);
      await player.play();
    } catch (e) {
      state = const AyatAudioState();
      return 'Gagal memutar audio: ${e.toString()}';
    }
    return null;
  }

  Future<void> stop() async {
    final player = ref.read(audioPlayerProvider);
    await player.stop();
    state = const AyatAudioState();
  }
}
