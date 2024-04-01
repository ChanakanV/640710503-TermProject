import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Beer {
  final String? name;
  final String? image;
  final double? averageRating;
  final int? reviews;

  Beer({
    required this.name,
    required this.image,
    this.averageRating,
    this.reviews,
  });

  factory Beer.fromJson(Map<String, dynamic> json) {
    return Beer(
      name: json['name'],
      image: json['image'],
      averageRating: json['rating'] != null ? json['rating']['average'] : null,
      reviews: json['rating'] != null ? json['rating']['reviews'] : null,
    );
  }
}

class BeerListPage extends StatefulWidget {
  @override
  _BeerListPageState createState() => _BeerListPageState();
}

class _BeerListPageState extends State<BeerListPage> {
  List<Beer>? _beers;

  @override
  void initState() {
    super.initState();
    _getBeers();
  }

  Future<void> _getBeers() async {
    try {
      var dio = Dio(BaseOptions(responseType: ResponseType.plain));
      var response = await dio.get('https://api.sampleapis.com/beers/ale');
      List list = jsonDecode(response.data);

      setState(() {
        _beers = list.map((beer) => Beer.fromJson(beer)).toList();
        _beers!.sort((a, b) => a.name!.compareTo(b.name!));
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of Beer', style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.w900),),
        backgroundColor: Color.fromARGB(255, 93, 83, 35),
      ),
      body: _beers == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _beers!.length,
              itemBuilder: (context, index) {
                var beer = _beers![index];
                return ListTile(
                  title: Text(beer.name ?? ''),
                  trailing: beer.image != null
                      ? Image.network(
                          beer.image!,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        )
                      : SizedBox.shrink(),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BeerDetailPage(beer: beer),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

class BeerDetailPage extends StatelessWidget {
  final Beer beer;

  const BeerDetailPage({Key? key, required this.beer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(beer.name ?? ''),
      ),
      body: Container(
        color:
            Color.fromARGB(255, 236, 243, 144), 
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Name: ${beer.name ?? ''}',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),

                Text(
                  'Average rating: ${beer.averageRating != null ? beer.averageRating.toString() : 'N/A'}',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),

                Text(
                  'Reviews: ${beer.reviews != null ? beer.reviews.toString() : 'N/A'}',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),

                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: beer.image != null
                        ? Image.network(
                            beer.image!,
                            fit: BoxFit.contain, 
                          )
                        : SizedBox.shrink(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: BeerListPage(),
  ));
}
