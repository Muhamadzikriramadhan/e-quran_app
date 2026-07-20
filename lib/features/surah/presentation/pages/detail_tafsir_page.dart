import 'package:equran_app/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/tafsir_detail_entity.dart';
import '../bloc/detail_tafsir_bloc/detail_tafsir_bloc.dart';
import '../bloc/detail_tafsir_bloc/detail_tafsir_event.dart';
import '../bloc/detail_tafsir_bloc/detail_tafsir_state.dart';

class DetailTafsirPage extends StatefulWidget {
  final String id;
  final String name;

  const DetailTafsirPage({super.key, required this.id, required this.name});

  @override
  State<StatefulWidget> createState() => _DetailTafsirPageState();
}

class _DetailTafsirPageState extends State<DetailTafsirPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tafsir ${widget.name}",
        ),
      ),
      body: IslamicBackground(
        child: BlocProvider(
          create: (_) => DetailTafsirBloc()
            ..add(DetailTafsirGetBySurahNumber("tafsir/${widget.id}")),
          child: BlocBuilder<DetailTafsirBloc, DetailTafsirState>(
            builder: (context, state) {
              if (state is DetailTafsirLoading) {
                return Center(
                  child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor),
                );
              }

              if (state is DetailTafsirSuccess) {
                final data = state.detailTafsir.data!;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: ListView.builder(
                    itemCount: data.tafsir!.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return _buildTafsirHeaderCard(data);
                      }
                      
                      final tafsirItem = data.tafsir![index - 1];
                      return _buildTafsirItem(
                        tafsirItem.ayat.toString(),
                        tafsirItem.teks.toString(),
                      );
                    },
                  ),
                );
              }

              if (state is DetailTafsirFailed) {
                return Center(
                  child: Text(
                    state.e,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                );
              }

              return const Center(
                child: Text("Something went wrong or data not available."),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTafsirHeaderCard(TafsirDetailDataEntity data) {
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
          const Text(
            "Tafsir Lengkap Surat",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 4),
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
        ],
      ),
    );
  }

  Widget _buildTafsirItem(String id, String arti) {
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
          // Row for Ayat Number badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Tafsir Ayat : $id",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Tafsir text content
          Text(
            arti,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.grey.shade800,
              height: 1.5,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
