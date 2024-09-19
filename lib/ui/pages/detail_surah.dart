import 'dart:convert';

import 'package:equran_app/blocs/details/detail_bloc.dart';
import 'package:equran_app/models/surah_detail.dart';
import 'package:equran_app/ui/pages/detail_tafsir.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';

import '../../models/surah_list.dart';
import '../../utils/utils_equran.dart';
import 'package:rxdart/rxdart.dart';

class DetailSurah extends StatefulWidget {

  final String id;
  final String name;

  const DetailSurah({super.key, required this.id, required this.name});

  @override
  State<StatefulWidget> createState() => _DetailSurahPage();
}

class _DetailSurahPage extends State<DetailSurah> {

  final AudioPlayer audioPlayer = AudioPlayer();
  SurahList surahList = SurahList();
  late int voicer = 1;
  bool isPlaying = false;
  bool isPlayingFull = false;
  late String audioUrls;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playIndicatorSound(String url) async {
    try {
      // Load the sound from an asset or network URL
      await audioPlayer.setUrl(url); // Use your local sound asset
      // Alternatively, if it's a network file, use:
      // await _audioPlayer.setUrl('https://example.com/indicator_sound.mp3');

      // Play the sound
      await audioPlayer.play();
    } catch (e) {
      print("Error playing sound: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      DetailBloc()..add(DetailGetBySurahNumber("surat/${widget.id}")),
      child: BlocBuilder<DetailBloc, DetailState>(
        builder: (context, state) {
          if (state is DetailLoading) {
            return Container(
              margin: const EdgeInsets.only(top: 30),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.lightGreen),
              ),
            );
          }

          if (state is DetailSuccess) {
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.green,
                  title: Text(
                    "Surah ${widget.name}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(isPlayingFull ? Icons.pause : Icons.play_arrow, color: Colors.white),
                      onPressed: () async {
                        audioUrls = ((voicer == 1)
                            ? state.details.data!.audioFull?.s01.toString()
                            : (voicer == 2)
                            ? state.details.data!.audioFull?.s02.toString()
                            : (voicer == 3)
                            ? state.details.data!.audioFull?.s03.toString()
                            : (voicer == 4)
                            ? state.details.data!.audioFull?.s04.toString()
                            : (voicer == 5)
                            ? state.details.data!.audioFull?.s05.toString()
                            : '')!;
                        if (isPlayingFull) {
                          await audioPlayer.pause();
                          setState(() {
                            isPlayingFull = false;
                          });
                        } else {
                          _playIndicatorSound(audioUrls);
                          // await audioPlayer.setUrl(audioUrls);
                          // await audioPlayer.play();
                          setState(() {
                            isPlayingFull = true;
                          });
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      onPressed: () {
                        _showMenu(context, widget.id, widget.name);
                      },
                    ),
                  ],
                ),
                body: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.details.data!.ayat!.length,
                          itemBuilder: (context, index) {
                            final surah = state.details.data!.ayat![index];
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
                            return Column(
                              children: [
                                _buildSurahItem(
                                  surah.nomorAyat.toString(),
                                  surah.teksArab.toString(),
                                  surah.teksLatin.toString(),
                                  surah.teksIndonesia.toString(),
                                  voice,
                                ),
                                const Divider(),
                              ],
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: StreamBuilder<PositionData>(
                          stream: _positionDataStream,
                          builder: (context, snapshot) {
                            final positionData = snapshot.data;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_formatDuration(positionData?.position ?? Duration.zero)),
                                Expanded(
                                  child: SliderTheme(
                                    data: SliderThemeData(
                                      activeTrackColor: Colors.lightGreen,
                                      inactiveTrackColor: Colors.grey,
                                      thumbColor: Colors.green,
                                      overlayColor: Colors.blue.withOpacity(0.2),
                                      trackHeight: 4.0,
                                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
                                    ),
                                    child: Slider(
                                      min: 0.0,
                                      max: positionData?.duration.inMilliseconds.toDouble() ?? 1.0,
                                      value: positionData == null
                                          ? 0.0
                                          : positionData.position.inMilliseconds > positionData.duration.inMilliseconds
                                          ? positionData.duration.inMilliseconds.toDouble()
                                          : positionData.position.inMilliseconds.toDouble(),
                                      onChanged: (value) {
                                        final newPosition = Duration(milliseconds: value.toInt());
                                        audioPlayer.seek(newPosition);
                                      },
                                    ),
                                  ),
                                ),
                                Text(_formatDuration(positionData?.duration ?? Duration.zero)),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
            );
          }

          if (state is DetailFailed) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.green,
                title: Text(
                  "Surah ${widget.name}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white
                  ),
                ),
              ),
              body: Center(
                child: Text(
                  state.e,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.green,
              title: Text(
                "Surah ${widget.name}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            body: const Center(
              child: Text("Something went wrong or data not available."),
            ),
          );
        },
      ),
    );
  }

  void _showMenu(BuildContext context, String id, String name) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(size.width - 100, 0, 0, 0),
      items: <PopupMenuItem<String>>[
        const PopupMenuItem<String>(
          value: '1',
          child: Text('Pilih Murotal Syeikh'),
        ),
        const PopupMenuItem<String>(
          value: '2',
          child: Row(
            children: [
              Icon(Icons.menu_book, color: Colors.lightGreen),
              SizedBox(width: 10),
              Text('Tafsir Surat'),
            ],
          ),
        ),
      ],
    ).then((value) async {
      if (value != null) {
        if (value == '1') {
          List<String> listSyeikh = [
            'Abdullah-Al-Juhany',
            'Abdul-Muhsin-Al-Qasim',
            'Abdurrahman-as-Sudais',
            'Ibrahim-Al-Dossari',
            'Misyari-Rasyid-Al-Afasi',
          ];
          SpinnerDialog(
            title: 'Silahkan Pilih Syeikh',
            context: context,
            items: listSyeikh,
            onItemSelected: (selected, index) {
              int selectedIndex = index;
              setState(() {
                voicer = selectedIndex +1;
              });
            },
          ).show();
        } else {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => DetailTafsir(
                id: id,
                name: name,
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
        }
      }
    });
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

  Widget _buildSurahItem(String id, String ayatArab, String arabLatin, String arti, String audioUrl) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          margin: const EdgeInsets.symmetric(vertical: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.lightGreen,
                    child: Text(
                      convertToArabicNumeral(int.parse(id)),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      ayatArab,
                      textAlign: TextAlign.right,
                      style: GoogleFonts.notoSansArabic(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                  IconButton(
                    icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.green),
                    onPressed: () async {
                      if (isPlaying) {
                        await audioPlayer.pause();
                        setState(() {
                          isPlaying = false;
                        });
                      } else {
                        // await audioPlayer.setUrl(audioUrl);
                        // await audioPlayer.play();
                        _playIndicatorSound(audioUrl);
                        setState(() {
                          isPlaying = true;
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                arabLatin,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                arti,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        );
      },
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

}

class PositionData {
  final Duration position;
  final Duration duration;

  PositionData(this.position, this.duration);
}