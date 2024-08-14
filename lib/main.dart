import 'dart:convert';

import 'package:equran_app/blocs/surah/surah_bloc.dart';
import 'package:equran_app/shared/theme.dart';
import 'package:equran_app/ui/pages/detail_surah.dart';
import 'package:equran_app/ui/pages/splash_screen_page.dart';
import 'package:equran_app/utils/utils_equran.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'models/surah_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: lightBackgroundColor,
        appBarTheme: AppBarTheme(
          backgroundColor: lightBackgroundColor,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: blackColor),
          titleTextStyle: blackTextStyle.copyWith(
            fontSize: 20,
            fontWeight: semiBold,
          ),
        ),
      ),
      routes: {
        '/': (_) => const SplashScreenPage(),
        '/home': (_) => HomePage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Data> _allsurahs = [];
  List<Data> _filteredSurahs = []; // List for holding filtered data
  final TextEditingController _searchController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SurahBloc()..add(GetListSurah("surat")),
      child: BlocBuilder<SurahBloc, SurahState>(
        builder: (context, state) {
          if (state is SurahLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.lightGreen),
            );
          } else if (state is SurahSuccess) {
            _allsurahs = state.surah.data!;
            if (_filteredSurahs.isEmpty) {
              showToast("Data tidak ada!");
              _filteredSurahs = _allsurahs;
            }

            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.green,
                title: const Text(
                  "E-Qur'an App",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              body: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _searchController,
                      textCapitalization: TextCapitalization.none,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.green,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      onChanged: (text) {
                        _filtersurahs(text); // Pass text to the filter function
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        hintText: "Cari nama surah atau arti surah",
                        hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _filteredSurahs.length,
                        itemBuilder: (context, index) {
                          final surah = _filteredSurahs[index];
                          return _buildSurahItem(
                              surah.nomor.toString(),
                              surah.namaLatin.toString(),
                              surah.jumlahAyat.toString());
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is SurahFailed) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.green,
                title: const Text(
                  "E-Qur'an App",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
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
              title: const Text(
                "E-Qur'an App",
                style: TextStyle(
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

  void _filtersurahs(String query) {
    setState(() {
      if (query.isEmpty) {
        showToast("Data tidak ada!");
        _filteredSurahs = _allsurahs;
      } else {
        _filteredSurahs = _allsurahs.where((surah) {
          final nameLower = surah.nama!.toLowerCase();
          final artiLower = surah.arti!.toLowerCase();
          return nameLower.contains(query.toLowerCase()) ||
              artiLower.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  Widget _buildSurahItem(String id, String name, String jumlah) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
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
              pageBuilder: (context, animation, secondaryAnimation) =>
                  DetailSurah(
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
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // Leading number icon
                CircleAvatar(
                  backgroundColor: Colors.lightGreen,
                  child: Text(
                    id,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16.0),
                    ),
                    Text(
                      '$jumlah ayat',
                      style: const TextStyle(
                          fontWeight: FontWeight.normal, color: Colors.black54, fontSize: 14.0),
                    ),
                  ],
                ),
              ],
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey),
          ],
        ),
      ),
    );
  }

}
