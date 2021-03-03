import 'package:flutter/material.dart';

import 'package:srinu_anna/constants.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

void main() {
  runApp(SrinuAnnaApp());
}

class SrinuAnnaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Rishank Imperia",
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var apartments = [
    Apartment(number: 102, sqft: 1300),
    Apartment(number: 103, sqft: 1265),
    Apartment(number: 104, sqft: 1265),
    Apartment(number: 105, sqft: 1295),
    Apartment(number: 106, sqft: 1765),
    Apartment(number: 107, sqft: 1885),
    Apartment(number: 108, sqft: 1265),
    Apartment(number: 109, sqft: 1265),
    Apartment(number: 110, sqft: 1265),
    Apartment(number: 111, sqft: 1265),
    Apartment(number: 112, sqft: 3530),
    Apartment(number: 201, sqft: 1765),
    Apartment(number: 202, sqft: 1300),
    Apartment(number: 203, sqft: 1265),
    Apartment(number: 204, sqft: 1265),
    Apartment(number: 205, sqft: 1295),
    Apartment(number: 206, sqft: 1765),
    Apartment(number: 207, sqft: 1885),
    Apartment(number: 208, sqft: 1265),
    Apartment(number: 209, sqft: 1265),
    Apartment(number: 210, sqft: 1265),
    Apartment(number: 303, sqft: 1265),
    Apartment(number: 305, sqft: 1295),
    Apartment(number: 308, sqft: 1265),
    Apartment(number: 309, sqft: 1265),
    Apartment(number: 310, sqft: 1265),
    Apartment(number: 311, sqft: 1265),
    Apartment(number: 407, sqft: 1885),
    Apartment(number: 403, sqft: 1265),
  ];

  var selectedApartments = <Apartment>[];
  var filteredApartment = <Apartment>[];
  String searchText = "";

  @override
  void initState() {
    super.initState();
    apartments.sort((a1, a2) => a1.number.compareTo(a2.number));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Srinu Anna"),
          actions: [
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                setState(() {
                  apartments = apartments
                      .map((e) => e.copyWith(isSelected: true))
                      .toList();
                });
              },
            ),
            SizedBox(
              width: 10,
            ),
            IconButton(
                icon: Icon(Icons.print),
                onPressed: () {
                  generateDocument();
                }),
            SizedBox(
              width: 30,
            )
          ],
        ),
        body: Container(
          color: kBgDarkColor,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  // controller: _controller,
                  onChanged: _handleSearchChange,

                  decoration: InputDecoration(
                      hintText: "Search..",
                      filled: true,
                      fillColor: kBgLightColor,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none),
                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.grey,
                      )),
                ),
              ),
              if (searchText.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      final a = filteredApartment[index];
                      return ApartmentCard(
                        apartment: a,
                        isSelected: a.isSelected,
                        onTap: onApartmentSelect,
                      );
                    },
                    itemCount: filteredApartment.length,
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      final a = apartments[index];
                      return ApartmentCard(
                        apartment: a,
                        isSelected: a.isSelected,
                        onTap: onApartmentSelect,
                      );
                    },
                    itemCount: apartments.length,
                  ),
                )
            ],
          ),
        ));
  }

  _handleSearchChange(String text) {
    if (text.isNotEmpty) {
      setState(() {
        searchText = text;
        filteredApartment = apartments
            .where((element) =>
                element.number.toString().toLowerCase().contains(text))
            .toList(growable: false);
      });
    } else {
      setState(() {
        searchText = text;
      });
    }
  }

  onApartmentSelect(Apartment a) {
    setState(() {
      apartments = apartments.map((e) {
        if (e.number == a.number) {
          return e.copyWith(isSelected: !e.isSelected);
        } else {
          return e;
        }
      }).toList();
    });
  }

  generateDocument() {
    final doc = pw.Document();
    doc.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.standard,
        build: (pw.Context context) {
          return [
            pw.Text("Rishank Imperia",
                textAlign: pw.TextAlign.center,
                style:
                    pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Table.fromTextArray(
                cellAlignment: pw.Alignment.center,
                headers: ["Flat No", "SFT", "Amount"],
                data:
                    apartments.where((element) => element.isSelected).map((e) {
                  return [
                    "${e.number}",
                    "${e.sqft}",
                    "${(e.sqft * priceForSFT).round()}"
                  ];
                }).toList())
          ];
        }));
    print("doc $doc");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Scaffold(
                  appBar: AppBar(
                    title: Text("Print it"),
                  ),
                  body: PdfPreview(
                    allowPrinting: false,
                    build: (format) async {
                      print("fromat $format");
                      final d = await doc.save();
                      return d;
                    },
                  ),
                )));
  }
}

class ApartmentCard extends StatelessWidget {
  final Apartment apartment;
  final bool isSelected;
  final Function(Apartment) onTap;

  const ApartmentCard(
      {Key? key,
      required this.apartment,
      required this.isSelected,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
        child: Container(
          decoration: BoxDecoration(
              color: kBgDarkColor, borderRadius: BorderRadius.circular(10)),
          child: InkWell(
            onTap: () => onTap(apartment),
            child: Container(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          apartment.number.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.4,
                              fontSize: 18),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "sft: ${apartment.sqft}",
                          style: TextStyle(),
                        )
                      ],
                    ),
                  ),
                  isSelected ? Icon(Icons.check) : SizedBox.shrink()
                ],
              ),
            ),
          ),
        ).addNeumorphism());
  }
}

class Apartment {
  final int number;
  final int sqft;
  final bool isSelected;

  Apartment(
      {required this.number, required this.sqft, this.isSelected = false});

  Apartment copyWith({
    int? number,
    int? sqft,
    bool? isSelected,
  }) {
    return Apartment(
      number: number ?? this.number,
      sqft: sqft ?? this.sqft,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

extension Neumorphism on Widget {
  addNeumorphism(
      {double borderRadius = 10.0,
      Offset offset = const Offset(5, 5),
      double blurRadius = 10,
      Color topShadowColor = Colors.white60,
      Color bottomShadowColor = const Color(0x26234395)}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        boxShadow: [
          BoxShadow(
            offset: offset,
            blurRadius: blurRadius,
            color: bottomShadowColor,
          ),
          BoxShadow(
            offset: Offset(-offset.dx, -offset.dx),
            blurRadius: blurRadius,
            color: topShadowColor,
          ),
        ],
      ),
      child: this,
    );
  }
}

const priceForSFT = 1.5;
