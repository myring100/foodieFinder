import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FindDinning extends StatefulWidget {
  final Position currentPosition;
  FindDinning(this.currentPosition);

  @override
  State<FindDinning> createState() => _FindDinningState();
}

class _FindDinningState extends State<FindDinning> {
  late GoogleMapController _controller;


  @override
  Widget build(BuildContext context) {
    Position currntPosition = widget.currentPosition;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Restaurants'),
      ),
      body: FutureBuilder<dynamic>(
        future: fetchNearbyRestaurants(currntPosition),
        builder: (context,snapshot){
          if (snapshot.connectionState==ConnectionState.waiting){
            return CircularProgressIndicator();
          }
          else if (snapshot.hasError){
            print('snapshot has error');
            return Center(child: Text('Data Error'),);
          }
          else {
            List data = snapshot.data ?? [];
            print('here i have snapshot data \n $data');

            return ListView.builder(
                itemCount: (data.length),
                itemBuilder: (context,index){
                  return ListTile(
                    title: Text(data[index]["name"]),
                  );
                });
          }
        },

      ),
    );
  }

}
Future<dynamic> fetchNearbyRestaurants(Position userLocation) async {

  final apiKey = dotenv.env['place_api_key'];
  const radius = 5000; // 검색 반경 (미터)
  const type = 'japanese restaurant'; // 검색할 장소 유형

  final response = await http.get(Uri.parse(
    'https://maps.googleapis.com/maps/api/place/nearbysearch/json?'
        'keyword=cruise&'
        'location=${userLocation.latitude},${userLocation.longitude}'
        '&radius=$radius'
        '&type=$type'
        '&key=$apiKey',
  ));

  if (response.statusCode == 200) {
    final data = json.decode(response.body)["results"];
    // 데이터를 파싱하고 식당 목록을 얻어옵니다.
    // 데이터를 사용하여 지도에 마커를 추가하거나 원하는 방식으로 표시합니다.
    // 예제
    // data.forEach((element) {
    //   print(element["name"]);
    // });
    // print(data[1]["name"]);
    return data;
  } else {
    throw Exception('Failed to load nearby restaurants');
  }
}



