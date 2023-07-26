import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';

class HomeNewSimpleTextUIScreen extends StatefulWidget {
  const HomeNewSimpleTextUIScreen({super.key, this.getSimpleTextDataWithIndex});

  final getSimpleTextDataWithIndex;

  @override
  State<HomeNewSimpleTextUIScreen> createState() =>
      _HomeNewSimpleTextUIScreenState();
}

class _HomeNewSimpleTextUIScreenState extends State<HomeNewSimpleTextUIScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 40,
      width: MediaQuery.of(context).size.width,
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ReadMoreText(
          //
          widget.getSimpleTextDataWithIndex['message'].toString(),
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
    );
  }
}
