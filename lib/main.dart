import 'dart:convert';

import 'package:equran_app/services/equran_services.dart';
import 'package:equran_app/shared/theme.dart';
import 'package:equran_app/ui/pages/detail_surah.dart';
import 'package:equran_app/ui/pages/splash_screen_page.dart';
import 'package:equran_app/utils/loading_dialog.dart';
import 'package:equran_app/utils/utils_equran.dart';
import 'package:flutter/material.dart';

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
  List<Map<String, String>> _allsurahs = [];
  List<Map<String, String>> _filteredsurahs = [];
  SurahList surahList = SurahList();

  @override
  void initState() {
    super.initState();
    _listSurah();
  }

  final TextEditingController _searchController = TextEditingController();
  TextCapitalization textCapitalization = TextCapitalization.none;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
            "E-Qur'an App",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _searchController,
              textCapitalization: textCapitalization,
              keyboardType: TextInputType.text,
              cursorColor: Colors.green, // Green cursor color
              style: blackTextStyle.copyWith(
                fontSize: 14,
                fontWeight: medium,
              ),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: greyColor),
                hintText: "Cari nama surah atau arti surah",
                hintStyle: greyTextStyle.copyWith(fontSize: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.green), // Green focused border color
                ),
                contentPadding: const EdgeInsets.all(12),
                filled: false,
                fillColor: null,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredsurahs.length,
                itemBuilder: (context, index) {
                  final surah = _filteredsurahs[index];
                  return Column(
                    children: [
                      _buildSurahItem(surah['id']!, surah['name']!, surah['jumlah']!),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _listSurah() async {
    // CustomLoadingDialog().showLoadingDialog(context, title: "Load Surah", content: "Loading...");
    List<Map<String, String>> allsurah = [];
    String data = await EquranServices().hitEquran("surat");

    try {
      // CustomLoadingDialog().dismissLoadingDialog(context);
      surahList = SurahList.fromJson(jsonDecode(data));

      for (var item in surahList.data!) {
        allsurah.add({'name': item.namaLatin.toString(), 'id': item.nomor.toString(), 'arti': item.arti.toString(), 'jumlah': item.jumlahAyat.toString(),  'audio': jsonEncode(item.audioFull).toString()});
      }
      setState(() {
        _allsurahs = allsurah;
        _filteredsurahs = _allsurahs;
        _searchController.addListener(_filtersurahs);
      });
    } catch(e) {
      // CustomLoadingDialog().dismissLoadingDialog(context);
      showCustomSnackbar(context, e.toString());
    }
  }

  void _filtersurahs() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredsurahs = _allsurahs.where((surah) {
        final nameLower = surah['name']!.toLowerCase();
        final artiLower = surah['arti']!.toLowerCase();
        return nameLower.contains(query) || artiLower.contains(query);
      }).toList();
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
