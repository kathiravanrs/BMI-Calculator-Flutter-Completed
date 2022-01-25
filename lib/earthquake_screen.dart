import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'card_data.dart';

// ignore: must_be_immutable
class EarthquakeScreen extends StatefulWidget {
  String orderBy;
  int minMag;
  int limit;

  EarthquakeScreen(
      {@required this.orderBy, @required this.minMag, @required this.limit});

  @override
  _EarthquakeScreenState createState() =>
      _EarthquakeScreenState(orderBy: orderBy, minMag: minMag, limit: limit);
}

class _EarthquakeScreenState extends State<EarthquakeScreen> {
  _EarthquakeScreenState(
      {@required this.orderBy, @required this.minMag, @required this.limit});

  final String orderBy;
  final int minMag;
  final int limit;

  String url() {
    return 'https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&'
        'eventtype=earthquake'
        '&orderby=$orderBy'
        '&minmag=$minMag'
        '&limit=$limit';
  }

  // List earthquakes;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.mounted);
    this.getJson();
  }

  Future<List> getJson() async {
    List earthquakes;

    var response = await http.get(
      Uri.parse(url()),
      headers: {'Accept': 'application.json'},
    );

    if (response.statusCode == 200) {
      setState(() {
        var convertDataToJson = jsonDecode(response.body);
        earthquakes = convertDataToJson['features'];
      });
    }
    return earthquakes;
  }

  Future<List> _refresh() {
    return getJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        title: Text('QuakeFinder'),
        backgroundColor: Colors.black,
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child: FutureBuilder(
          future: getJson(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Container(
                color: Colors.grey[800],
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            return ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: snapshot.hasData ? snapshot.data.length : 0,
              itemBuilder: (BuildContext context, int index) {
                Map properties = snapshot.data[index]['properties'];

                double magnitude = properties['mag'].toDouble();

                String place = properties['place'];

                var time = properties['time'];

                var formattedDate = DateFormat.yMMMd().format(
                  DateTime.fromMillisecondsSinceEpoch(time),
                );

                return Container(
                  color: Colors.grey[800],
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Card(
                    elevation: 6,
                    color: Color(0x983d5e80),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: CardData(
                        magnitude: magnitude,
                        place: place,
                        date: formattedDate,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
