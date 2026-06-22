import 'package:equatable/equatable.dart';

typedef AyatPlaybackKey = ({int surah, int ayat});

class AudioState extends Equatable {
  const AudioState({
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

  AudioState copyWith({
    AyatPlaybackKey? current,
    bool? isPlaying,
    bool? isLoading,
    bool clearCurrent = false,
  }) {
    return AudioState(
      current: clearCurrent ? null : (current ?? this.current),
      isPlaying: isPlaying ?? this.isPlaying,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [current, isPlaying, isLoading];
}
