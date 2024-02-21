import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeFeedSharedLocationScreen extends StatefulWidget {
  const HomeFeedSharedLocationScreen({super.key, this.getData});

  final getData;

  @override
  State<HomeFeedSharedLocationScreen> createState() =>
      _HomeFeedSharedLocationScreenState();
}

class _HomeFeedSharedLocationScreenState
    extends State<HomeFeedSharedLocationScreen> {
  //
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  var strUserLat = 0.0;
  var strUserLong = 0.0;
  //
  @override
  void initState() {
    //
    if (kDebugMode) {
      print('========== LOCATION ==============');
      print(widget.getData['share']);
      print('========================');
    }

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
          if (widget.getData['share']['message'].split('!@()')[3] == '')
            ...[]
          else ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.getData['share']['message'].split('!@()')[3],
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
                  double.parse(
                      widget.getData['share']['message'].split('!@()')[1]),
                  double.parse(
                      widget.getData['share']['message'].split('!@()')[2]),
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
        double.parse(widget.getData['share']['message'].split('!@()')[1]),
        double.parse(widget.getData['share']['message'].split('!@()')[2]),
      ),
      // icon: BitmapDescriptor.,
      infoWindow: const InfoWindow(
        title: '',
        snippet: '',
      ),
    );

    setState(() {
      markers[const MarkerId('place_name')] = marker;
    });
  }
}
