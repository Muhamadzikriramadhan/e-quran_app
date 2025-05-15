import 'package:equran_app/models/asmaul_husna.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../blocs/asmaulhusna/asmaul_husna_bloc.dart';

class AsmaulHusnaPage extends StatefulWidget {

  @override
  State<AsmaulHusnaPage> createState() => _AsmaulHusnaPageState();
}

class _AsmaulHusnaPageState extends State<AsmaulHusnaPage> {
  List<Data> _allasmaulhusnas = [];
  List<Data> _filteredasmaulhusnas = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Asmaul Husna",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: BlocProvider(
        create: (_) => AsmaulHusnaBloc()..add(GetAsmaulHusna("quran/asma")),
        child: BlocBuilder<AsmaulHusnaBloc, AsmaulHusnaState>(
          builder: (context, state) {
            if (state is AsmaulHusnaLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.lightGreen),
              );
            }

            if (state is AsmaulHusnaSuccess) {
              _allasmaulhusnas = state.asmaulHusna.data!;
              if (_filteredasmaulhusnas.isEmpty) {
                _filteredasmaulhusnas = _allasmaulhusnas;
              }

              return Padding(
                padding: const EdgeInsets.all(10),
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
                        _filterasmaulhusnas(text);
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search, color: Colors.grey),
                        hintText: "Cari nama atau arti asmaul husna",
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
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _filteredasmaulhusnas.length,
                        itemBuilder: (context, index) {
                          final asmaulhusna = _filteredasmaulhusnas[index];
                          return _buildAsmaulHusnaItem(
                            asmaulhusna.id.toString(),
                            asmaulhusna.latin.toString(),
                            asmaulhusna.indo.toString(),
                            asmaulhusna.arab.toString(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }

            if (state is AsmaulHusnaFailed) {
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

  void _filterasmaulhusnas(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredasmaulhusnas = _allasmaulhusnas;
      } else {
        _filteredasmaulhusnas = _allasmaulhusnas.where((asmaulhusna) {
          final nameLower = asmaulhusna.latin!.toLowerCase();
          final artiLower = asmaulhusna.indo!.toLowerCase();
          return nameLower.contains(query.toLowerCase()) ||
              artiLower.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  Widget _buildAsmaulHusnaItem(String id, String latin, String arti, String arab) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
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
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  latin,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                ),
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
          ),
          const SizedBox(width: 10),
          // Arabic text on the right
          Text(
            arab,
            style: GoogleFonts.notoSansArabic(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }

}