import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../blocs/doa/doa_bloc.dart';
import '../../models/doa_list.dart';

class DoaPage extends StatefulWidget {

  @override
  State<DoaPage> createState() => _DoaPageState();
}

class _DoaPageState extends State<DoaPage> {
  List<Data> _alldoas = [];
  List<Data> _filtereddoas = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Doa",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: BlocProvider(
        create: (_) => DoaBloc()..add(GetDoa("doa")),
        child: BlocBuilder<DoaBloc, DoaState>(
          builder: (context, state) {
            if (state is DoaLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.lightGreen),
              );
            }

            if (state is DoaSuccess) {
              _alldoas = state.doaList.data!;
              if (_filtereddoas.isEmpty) {
                _filtereddoas = _alldoas;
              }

              return Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Search field takes most of the space
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
                              _filterdoas(text);
                            },
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.search, color: Colors.grey),
                              hintText: "Cari nama, judul atau arti doa",
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
                        const SizedBox(width: 10),
                        // Filter icon
                        GestureDetector(
                          onTap: () {
                            context.read<DoaBloc>().add(GetDoa("doa?source=haji"));
                          },
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
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _filtereddoas.length,
                        itemBuilder: (context, index) {
                          final doa = _filtereddoas[index];
                          return _builddoaItem(
                            doa.judul.toString(),
                            doa.indo.toString(),
                            doa.arab.toString(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }

            if (state is DoaFailed) {
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

  void _filterdoas(String query) {
    setState(() {
      if (query.isEmpty) {
        _filtereddoas = _alldoas;
      } else {
        _filtereddoas = _alldoas.where((doa) {
          final nameLower = doa.judul!.toLowerCase();
          final artiLower = doa.indo!.toLowerCase();
          return nameLower.contains(query.toLowerCase()) ||
              artiLower.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  Widget _builddoaItem(String latin, String arti, String arab) {
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
          Text(
            latin,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 16.0,
            ),
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

}