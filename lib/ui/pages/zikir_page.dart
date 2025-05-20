import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../blocs/zikir/zikir_bloc.dart';
import '../../models/zikir_list.dart';

class ZikirPage extends StatefulWidget {

  final String url;

  const ZikirPage({super.key, required this.url});

  @override
  State<ZikirPage> createState() => _ZikirPageState();
}

class _ZikirPageState extends State<ZikirPage> {
  List<Data> _allZikirs = [];
  List<Data> _filteredZikirs = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Zikir ${widget.url.isEmpty ? "Sehari - Hari" : "Pagi & Sore"}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: BlocProvider(
        create: (_) => ZikirBloc()..add(
            GetZikir(widget.url.isEmpty ? "dzikir" : "dzikir?type=${widget.url}")
        ),
        child: BlocBuilder<ZikirBloc, ZikirState>(
          builder: (context, state) {
            if (state is ZikirLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.lightGreen),
              );
            }

            if (state is ZikirSuccess) {
              _allZikirs = state.zikirList.data!;
              _filteredZikirs = _allZikirs;

              return Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _searchController,
                            textCapitalization: TextCapitalization.none,
                            keyboardType: TextInputType.text,
                            cursorColor: Colors.green,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            onChanged: (text) {
                              _filterZikirs(text);
                            },
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.search, color: Colors.grey),
                              hintText: "Cari jenis, judul atau arti zikir",
                              hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(color: Colors.green),
                              ),
                              contentPadding: const EdgeInsets.all(12),
                            ),
                          ),
                        ),
                        if (widget.url.isNotEmpty) ...[
                          const SizedBox(width: 10),
                          PopupMenuButton<String>(
                            onSelected: (value) {
                              _searchController.clear();
                              context.read<ZikirBloc>().add(GetZikir('dzikir?ype=$value'));
                            },
                            itemBuilder: (context) => [
                              for (var option in ['pagi', 'sore'])
                                PopupMenuItem(value: option, child: Text(option.toUpperCase())),
                            ],
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                AntDesign.filter_outline,
                                color: Colors.white,
                                size: 23,
                              ),
                            ),
                          )
                        ]
                      ],
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _filteredZikirs.length,
                        itemBuilder: (context, index) {
                          final zikir = _filteredZikirs[index];
                          return _buildZikirItem(
                            zikir.type.toString() ,
                            zikir.ulang.toString(),
                            zikir.indo.toString(),
                            zikir.arab.toString(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }

            if (state is ZikirFailed) {
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

  void _filterZikirs(String keyword) {
    setState(() {
      _filteredZikirs = _allZikirs.where((zikir) {
        final lower = keyword.toLowerCase();
        return zikir.indo!.toLowerCase().contains(lower) || zikir.type!.toLowerCase().contains(lower);
      }).toList();
    });
  }

  Widget _buildZikirItem(String type, String ulang, String arti, String arab) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ulang,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16.0,
                ),
              ),
              Text(
                capitalizeFirst(type),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              arab,
              style: GoogleFonts.notoSansArabic(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            arti,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black54,
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }

  String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }


}