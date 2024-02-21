// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:readmore/readmore.dart';

import '../../header/utils.dart';
import 'package:timeago/timeago.dart' as timeago;

class HomeNewSharedMapUIScreen extends StatefulWidget {
  const HomeNewSharedMapUIScreen({super.key, this.getDataSharedMapUIWithIndex});

  final getDataSharedMapUIWithIndex;

  @override
  State<HomeNewSharedMapUIScreen> createState() =>
      _HomeNewSharedMapUIScreenState();
}

class _HomeNewSharedMapUIScreenState extends State<HomeNewSharedMapUIScreen> {
  // map
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  var strUserLat = 0.0;
  var strUserLong = 0.0;
  //
  @override
  void dispose() {
    //...
    // markers.dispose();
    super.dispose();
    //...
  }

  @override
  Widget build(BuildContext context) {
    return //
        Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        // height: 140,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            12.0,
          ),
          border: Border.all(
            width: 0.4,
          ),
          color: Colors.transparent,
        ),
        child: Column(
          children: [
            Container(
              height: 80,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Row(
                children: [
                  if (widget.getDataSharedMapUIWithIndex['share']['userImage']
                          .toString() ==
                      '')
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/icons/avatar.png',
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          30.0,
                        ),
                        child: Container(
                          height: 60,
                          width: 60,
                          color: Colors.transparent,
                          child: Image.network(
                            //
                            widget.getDataSharedMapUIWithIndex['share']
                                    ['userImage']
                                .toString(),
                            fit: BoxFit.cover,
                            //
                          ),
                        ),
                      ),
                    ),
                  //
                  Expanded(
                    child: Container(
                      // width: 40,
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: widget
                                        .getDataSharedMapUIWithIndex['share']
                                            ['userName']
                                        .toString(),
                                    style: GoogleFonts.montserrat(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  //
                                  // tag line
                                  TextSpan(
                                    text: ' shared location'.toString(),
                                    style: GoogleFonts.montserrat(
                                      color: Colors.black,
                                      fontSize: 14.0,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  //
                                ],
                              ),
                            ),
                          ),
                          //
                          // created time show
                          Align(
                            alignment: Alignment.centerLeft,
                            child: textWithRegularStyle(
                              timeago.format(
                                DateTime.parse(
                                  widget.getDataSharedMapUIWithIndex['share']
                                          ['created']
                                      .toString(),
                                ),
                              ),
                              Colors.black,
                              14.0,
                            ),
                          ),
                          //
                        ],
                      ),
                    ),
                  ),

                  //
                ],
              ),
            ),
            //
            Container(
              // height: 350,
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent,
              child: Column(
                children: [
                  if (widget.getDataSharedMapUIWithIndex['share']['message']
                          .split(',')[2] ==
                      '')
                    ...[]
                  else ...[
                    // Padding(
                    //   padding: const EdgeInsets.all(12.0),
                    //   child: Align(
                    //     alignment: Alignment.centerLeft,
                    //     child: Text(
                    //       widget.getDataSharedMapUIWithIndex['share']['message']
                    //           .split(',')[2],
                    //     ),
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: ReadMoreText(
                          //
                          widget.getDataSharedMapUIWithIndex['share']['message']
                              .split(',')[2],
                          //
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            // fontWeight: FontWeight.bold,
                          ),
                          //
                          trimLines: 3,
                          colorClickableText: Colors.black,
                          lessStyle: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          trimMode: TrimMode.Line,
                          trimCollapsedText: '...Show more',
                          trimExpandedText: '...Show less',
                          moreStyle: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],

                  Container(
                    // margin: const EdgeInsets.all(10.0),
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width,
                    height: 180,
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          double.parse(widget
                              .getDataSharedMapUIWithIndex['share']['message']
                              .split(',')[0]),
                          double.parse(widget
                              .getDataSharedMapUIWithIndex['share']['message']
                              .split(',')[1]),
                        ),
                        zoom: 14.0,
                      ),
                      markers: markers.values.toSet(),
                    ),
                  ),
                  //
                ],
              ),
            )
            //
          ],
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    //  mapController = controller;

    final marker = Marker(
      markerId: const MarkerId('My Location'),
      position: LatLng(
        double.parse(
            widget.getDataSharedMapUIWithIndex[0]['message'].split(',')[0]),
        double.parse(
            widget.getDataSharedMapUIWithIndex[0]['message'].split(',')[1]),
      ),
      // icon: BitmapDescriptor.,
      infoWindow: const InfoWindow(
        title: '',
        snippet: '',
      ),
    );

    setState(() {
      markers[MarkerId('place_name')] = marker;
    });
  }
}
