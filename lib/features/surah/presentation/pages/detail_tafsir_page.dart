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
        backgroundColor: Colors.green,
        title: Text(
          "Tafsir ${widget.name}",
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
      ),
      body: BlocProvider(
        create: (_) => DetailTafsirBloc()
          ..add(DetailTafsirGetBySurahNumber("tafsir/${widget.id}")),
        child: BlocBuilder<DetailTafsirBloc, DetailTafsirState>(
          builder: (context, state) {
            if (state is DetailTafsirLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.lightGreen),
              );
            }

            if (state is DetailTafsirSuccess) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildDetailRow("Surah", state.detailTafsir.data!.namaLatin!, isTitle: true),
                    buildDetailRow("Arti", state.detailTafsir.data!.arti!),
                    buildDetailRow("Jumlah ayat", "${state.detailTafsir.data!.jumlahAyat!} Ayat"),
                    buildDetailRow("Tempat Turun", state.detailTafsir.data!.tempatTurun!),
                    const SizedBox(height: 10),
                    ..._buildTafsirList(state.detailTafsir.data!.tafsir!),
                  ],
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
    );
  }

  Widget buildDetailRow(String label, String value, {bool isTitle = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15,
              ),
            ),
          ),
          const Text(
            " :",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value.trim(),
              style: TextStyle(
                fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
                fontSize: 15,
                color: Colors.black,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTafsirList(List<TafsirEntity> tafsirList) {
    return tafsirList.map((tafsir) {
      return Column(
        children: [
          _buildTafsirItem(
            tafsir.ayat.toString(),
            tafsir.teks.toString(),
          ),
          const Divider(),
        ],
      );
    }).toList();
  }

  Widget _buildTafsirItem(String id, String arti) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.lightGreen,
            child: Text(
              id,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              arti,
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black87,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}
