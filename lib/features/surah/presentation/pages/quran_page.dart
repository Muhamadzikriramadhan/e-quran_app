import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme.dart';
import '../bloc/surah_bloc/surah_bloc.dart';
import '../bloc/surah_bloc/surah_event.dart';
import '../bloc/surah_bloc/surah_state.dart';
import '../bloc/detail_bloc/detail_bloc.dart';
import '../bloc/detail_bloc/detail_event.dart';
import 'detail_surah_page.dart';

class QuranPage extends StatefulWidget {
  const QuranPage({super.key});

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  late final SurahBloc _surahBloc;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _surahBloc = SurahBloc()..add(const GetListSurah("surat"));
  }

  @override
  void dispose() {
    _surahBloc.close();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackgroundColor,
      appBar: AppBar(
        title: const Text("Al-Qur'an"),
      ),
      body: IslamicBackground(
        child: BlocProvider.value(
          value: _surahBloc,
          child: BlocBuilder<SurahBloc, SurahState>(
            builder: (context, state) {
              if (state is SurahLoading) {
                return Center(
                  child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
                );
              } else if (state is SurahSuccess) {
                final allSurahs = state.surah.data ?? [];
                final query = _searchController.text.toLowerCase();
                
                final displaySurahs = query.isEmpty
                    ? allSurahs
                    : allSurahs.where((surah) {
                        final nameLower = (surah.namaLatin ?? "").toLowerCase();
                        final artiLower = (surah.arti ?? "").toLowerCase();
                        return nameLower.contains(query) || artiLower.contains(query);
                      }).toList();
  
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _searchController,
                        textCapitalization: TextCapitalization.none,
                        keyboardType: TextInputType.text,
                        cursorColor: Theme.of(context).primaryColor,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        onChanged: (text) {
                          setState(() {}); // Rebuild to apply search filter locally
                        },
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          prefixIcon: const Icon(Icons.search, color: Colors.grey),
                          hintText: "Cari nama surah atau arti surah",
                          hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Theme.of(context).primaryColor),
                          ),
                          contentPadding: const EdgeInsets.all(12),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: displaySurahs.length,
                          itemBuilder: (context, index) {
                            final surah = displaySurahs[index];
                            return _buildSurahItem(
                              surah.nomor.toString(),
                              surah.namaLatin.toString(),
                              surah.jumlahAyat.toString(),
                              surah.tempatTurun.toString(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              } else if (state is SurahFailed) {
                return Center(
                  child: Text(
                    state.e,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                );
              } else {
                return const Center(
                  child: Text("Something went wrong or data not available."),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSurahItem(String id, String name, String jumlah, String tempat) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
                create: (_) => DetailBloc()..add(DetailGetBySurahNumber("surat/$id")),
                child: DetailSurahPage(
                  id: id,
                  name: name,
                ),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(
                    id,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16.0),
                    ),
                    Text(
                      '$jumlah ayat | $tempat',
                      style: const TextStyle(
                          fontWeight: FontWeight.normal, color: Colors.black54, fontSize: 14.0),
                    ),
                  ],
                ),
              ],
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }
}
