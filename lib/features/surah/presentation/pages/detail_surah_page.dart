import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../core/theme/theme.dart';
import '../../domain/entities/surah_entity.dart';
import '../../domain/entities/surah_detail_entity.dart';
import '../bloc/detail_bloc/detail_bloc.dart';
import '../bloc/detail_bloc/detail_state.dart';
import 'detail_tafsir_page.dart';

class DetailSurahPage extends StatefulWidget {
  final String id;
  final String name;

  const DetailSurahPage({super.key, required this.id, required this.name});

  @override
  State<StatefulWidget> createState() => _DetailSurahPageState();
}

class _DetailSurahPageState extends State<DetailSurahPage> {
  final AudioPlayer audioPlayer = AudioPlayer();
  late int voicer = 1;
  bool isPlayingFull = false;
  late String audioUrls;

  int? _playingAyatIndex;
  bool _isAudioPlaying = false;

  @override
  void initState() {
    super.initState();
    // Listen to player state streams to keep UI perfectly in sync
    audioPlayer.playerStateStream.listen((playerState) {
      if (!mounted) return;
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;

      setState(() {
        _isAudioPlaying = isPlaying && processingState != ProcessingState.completed;
        if (processingState == ProcessingState.completed) {
          _playingAyatIndex = null;
          isPlayingFull = false;
        }
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Surah ${widget.name}",
        ),
        actions: [
          BlocBuilder<DetailBloc, DetailState>(
            builder: (context, state) {
              if (state is DetailSuccess) {
                if (state.details.data?.audioFull == null) {
                  return const SizedBox.shrink();
                }
                final isFullPlaying = isPlayingFull && _isAudioPlaying && _playingAyatIndex == null;
                return IconButton(
                  icon: Icon(isFullPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white),
                  onPressed: () async {
                    final surah = state.details.data!.audioFull!;
                    audioUrls = getVoiceFullUrl(surah);
                    if (isFullPlaying) {
                      await audioPlayer.pause();
                    } else {
                      try {
                        setState(() {
                          _playingAyatIndex = null;
                          isPlayingFull = true;
                        });
                        await audioPlayer.stop();
                        await audioPlayer.setUrl(audioUrls);
                        await audioPlayer.play();
                      } catch (e) {
                        debugPrint("Error playing full surah: $e");
                      }
                    }
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: IslamicBackground(
        child: BlocBuilder<DetailBloc, DetailState>(
          builder: (context, state) {
            if (state is DetailLoading) {
              return Center(
                child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
              );
            }
  
            if (state is DetailSuccess) {
              return Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: ListView.builder(
                        itemCount: state.details.data!.ayat!.length + 2,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return _buildSurahHeaderCard(state.details.data!);
                          }
                          if (index == 1) {
                            return _buildSyeikhSelectorCard();
                          }
  
                          final ayatIndex = index - 2;
                          final surah = state.details.data!.ayat![ayatIndex];
                          String voice = getVoiceUrl(surah);
                          return _buildSurahItem(
                            surah.nomorAyat.toString(),
                            surah.teksArab.toString(),
                            surah.teksLatin.toString(),
                            surah.teksIndonesia.toString(),
                            voice,
                            ayatIndex,
                          );
                        },
                      ),
                    ),
                  ),
                  buildAudioSlider(),
                ],
              );
            }
  
            if (state is DetailFailed) {
              return Center(
                child: Text(
                  state.e,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
  
            return const Center(child: Text("Something went wrong."));
          },
        ),
      ),
    );
  }

  Widget _buildSurahHeaderCard(SurahDetailDataEntity data) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 8, left: 4, right: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xff11998e), Color(0xff38ef7d)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff11998e).withOpacity(0.25),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            data.namaLatin ?? "",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            data.arti ?? "",
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withOpacity(0.85),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 1,
            width: 120,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 8),
          Text(
            "${(data.tempatTurun ?? "").toUpperCase()} • ${(data.jumlahAyat ?? 0)} AYAT",
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          // Beautiful elevated button to view Tafsir
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => DetailTafsirPage(
                    id: widget.id,
                    name: widget.name,
                  ),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;
                    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                ),
              );
            },
            icon: const Icon(Icons.menu_book, size: 14, color: Color(0xff11998e)),
            label: const Text(
              "Tafsir Surat",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff11998e),
                fontSize: 12,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xff11998e),
              elevation: 1.5,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          if (widget.id != "1" && widget.id != "9") ...[
            const SizedBox(height: 16),
            Text(
              "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
              style: GoogleFonts.notoSansArabic(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildSyeikhSelectorCard() {
    final List<String> listSyeikh = [
      'Abdullah Al-Juhany',
      'Abdul Muhsin Al-Qasim',
      'Abdurrahman as-Sudais',
      'Ibrahim Al-Dossari',
      'Misyari Rasyid Al-Afasi',
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.record_voice_over_rounded,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                "Pilih Qari",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: blackColor,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Theme.of(context).primaryColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: voicer,
                icon: Icon(Icons.arrow_drop_down, color: Theme.of(context).primaryColor),
                elevation: 2,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                onChanged: (int? newValue) async {
                  if (newValue != null && newValue != voicer) {
                    await audioPlayer.stop();
                    setState(() {
                      voicer = newValue;
                      _playingAyatIndex = null;
                      isPlayingFull = false;
                    });
                  }
                },
                items: List.generate(listSyeikh.length, (index) {
                  return DropdownMenuItem<int>(
                    value: index + 1,
                    child: Text(listSyeikh[index]),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest2<Duration, Duration?, PositionData>(
        audioPlayer.positionStream,
        audioPlayer.durationStream,
        (position, duration) => PositionData(position, duration ?? Duration.zero),
      );

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  Widget _buildSurahItem(
      String id, String ayatArab, String arabLatin, String arti, String audioUrl, int index) {
    final bool isThisPlaying = _playingAyatIndex == index && _isAudioPlaying;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${widget.name} : $id",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  isThisPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                  color: Theme.of(context).primaryColor,
                  size: 30,
                ),
                onPressed: () async {
                  if (isThisPlaying) {
                    await audioPlayer.pause();
                  } else {
                    try {
                      setState(() {
                        _playingAyatIndex = index;
                        isPlayingFull = false;
                      });
                      await audioPlayer.stop();
                      await audioPlayer.setUrl(audioUrl);
                      await audioPlayer.play();
                    } catch (e) {
                      debugPrint("Error playing audio: $e");
                    }
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              ayatArab,
              textAlign: TextAlign.right,
              style: GoogleFonts.notoSansArabic(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                height: 1.8,
                color: Colors.black87,
              ),
              textDirection: TextDirection.rtl,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            arabLatin,
            style: TextStyle(
              fontSize: 14.0,
              color: Theme.of(context).primaryColor,
              fontStyle: FontStyle.italic,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            arti,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.grey.shade800,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  String convertToArabicNumeral(int number) {
    final arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    String numberString = number.toString();
    String arabicNumber = '';

    for (int i = 0; i < numberString.length; i++) {
      int digit = int.parse(numberString[i]);
      arabicNumber += arabicDigits[digit];
    }

    return arabicNumber;
  }

  String getVoiceUrl(AyatEntity surah) {
    if (surah.audio == null) return '';
    String voice = (voicer == 1)
        ? surah.audio!.s01.toString()
        : (voicer == 2)
            ? surah.audio!.s02.toString()
            : (voicer == 3)
                ? surah.audio!.s03.toString()
                : (voicer == 4)
                    ? surah.audio!.s04.toString()
                    : (voicer == 5)
                        ? surah.audio!.s05.toString()
                        : '';
    return voice;
  }

  String getVoiceFullUrl(AudioFullEntity surah) {
    String voice = (voicer == 1)
        ? surah.s01.toString()
        : (voicer == 2)
            ? surah.s02.toString()
            : (voicer == 3)
                ? surah.s03.toString()
                : (voicer == 4)
                    ? surah.s04.toString()
                    : (voicer == 5)
                        ? surah.s05.toString()
                        : '';
    return voice;
  }

  Widget buildAudioSlider() {
    final bool isPlayerVisible = _playingAyatIndex != null || isPlayingFull;

    if (!isPlayerVisible) return const SizedBox.shrink();

    final String title = isPlayingFull
        ? "Memutar Full Surah ${widget.name}"
        : "Memutar Surah ${widget.name} : Ayat ${(_playingAyatIndex! + 1)}";

    final String syeikhName = voicer == 1
        ? 'Abdullah Al-Juhany'
        : voicer == 2
            ? 'Abdul Muhsin Al-Qasim'
            : voicer == 3
                ? 'Abdurrahman as-Sudais'
                : voicer == 4
                    ? 'Ibrahim Al-Dossari'
                    : 'Misyari Rasyid Al-Afasi';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(Icons.music_note, color: Theme.of(context).primaryColor),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        "Qori: $syeikhName",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _isAudioPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                    color: Theme.of(context).primaryColor,
                    size: 36,
                  ),
                  onPressed: () async {
                    if (_isAudioPlaying) {
                      await audioPlayer.pause();
                    } else {
                      await audioPlayer.play();
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.stop_circle_outlined, color: Colors.red, size: 28),
                  onPressed: () async {
                    await audioPlayer.stop();
                    setState(() {
                      _playingAyatIndex = null;
                      isPlayingFull = false;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            StreamBuilder<PositionData>(
              stream: _positionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                final position = positionData?.position ?? Duration.zero;
                final duration = positionData?.duration ?? Duration.zero;

                return Column(
                  children: [
                    SliderTheme(
                      data: SliderThemeData(
                        activeTrackColor: Theme.of(context).primaryColor,
                        inactiveTrackColor: Colors.grey.shade200,
                        thumbColor: Theme.of(context).primaryColor,
                        overlayColor: Theme.of(context).primaryColor.withOpacity(0.2),
                        trackHeight: 4.0,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                      ),
                      child: Slider(
                        min: 0.0,
                        max: duration.inMilliseconds.toDouble() > 0
                            ? duration.inMilliseconds.toDouble()
                            : 1.0,
                        value: position.inMilliseconds.toDouble() > duration.inMilliseconds.toDouble()
                            ? duration.inMilliseconds.toDouble()
                            : position.inMilliseconds.toDouble(),
                        onChanged: (value) {
                          final newPosition = Duration(milliseconds: value.toInt());
                          audioPlayer.seek(newPosition);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(position),
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                          ),
                          Text(
                            _formatDuration(duration),
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PositionData {
  final Duration position;
  final Duration duration;

  PositionData(this.position, this.duration);
}
