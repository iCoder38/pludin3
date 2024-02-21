import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:pludin/classes/controllers/profile/my_profile.dart';
// import 'package:readmore/readmore.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeFeedsForLocation extends StatefulWidget {
  const HomeFeedsForLocation({super.key, this.getData});

  final getData;

  @override
  State<HomeFeedsForLocation> createState() => _HomeFeedsForLocationState();
}

class _HomeFeedsForLocationState extends State<HomeFeedsForLocation> {
  //
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  var strUserLat = 0.0;
  var strUserLong = 0.0;
  //
  @override
  void initState() {
    //
    funcGetUserLatAndLong();
    //
    super.initState();
  }

  funcGetUserLatAndLong() async {
    var myLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    if (kDebugMode) {
      print(myLocation.latitude);
    }
    if (kDebugMode) {
      print(myLocation.longitude);
    }
    //
    strUserLat = myLocation.latitude;
    strUserLong = myLocation.longitude;
    //
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 350,
      width: MediaQuery.of(context).size.width,
      color: Colors.transparent,
      child: Column(
        children: [
          if (widget.getData['message'].split(',')[2] == '')
            ...[]
          else ...[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.getData['message'].split(',')[2],
                ),
              ),
            ),
          ],

          Container(
            // margin: const EdgeInsets.all(10.0),
            color: Colors.pink[600],
            width: MediaQuery.of(context).size.width,
            height: 180,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  double.parse(widget.getData['message'].split(',')[0]),
                  double.parse(widget.getData['message'].split(',')[1]),
                ),
                zoom: 14.0,
              ),
              markers: markers.values.toSet(),
            ),
          ),
          //
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    //  mapController = controller;

    final marker = Marker(
      markerId: const MarkerId('My Location'),
      position: LatLng(
        double.parse(widget.getData['message'].split(',')[0]),
        double.parse(widget.getData['message'].split(',')[1]),
      ),
      // icon: BitmapDescriptor.,
      infoWindow: InfoWindow(
        title: '',
        snippet: '',
      ),
    );

    setState(() {
      markers[MarkerId('place_name')] = marker;
    });
  }
}
