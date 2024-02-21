import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';

import '../../controllers/profile/profile_gallery/profile_gallery.dart';

class UserNewProfileImagesScreen extends StatefulWidget {
  const UserNewProfileImagesScreen({super.key, this.getImageFullArray});

  final getImageFullArray;

  @override
  State<UserNewProfileImagesScreen> createState() =>
      _UserNewProfileImagesScreenState();
}

class _UserNewProfileImagesScreenState
    extends State<UserNewProfileImagesScreen> {
  //
  List<String> arr_scroll_multiple_images = [];
  //
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(6),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        // maxCrossAxisExtent: 300,
        childAspectRatio: 6 / 6,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15, crossAxisCount: 3,
      ),
      itemCount: widget.getImageFullArray.length,
      itemBuilder: (BuildContext ctx, index) {
        return GestureDetector(
          onTap: () {
            CustomImageProvider customImageProvider = CustomImageProvider(
                //
                imageUrls: arr_scroll_multiple_images.toList(),

                //
                initialIndex: index);
            showImageViewerPager(context, customImageProvider,
                doubleTapZoomable: true, onPageChanged: (page) {
              // print("Page changed to $page");
            }, onViewerDismissed: (page) {
              // print("Dismissed while on page $page");
            });
          },
          child: Container(
            margin: const EdgeInsets.only(
                // left: 10.0,
                // right: 10,
                ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(
                240,
                240,
                240,
                1,
              ),
              borderRadius: BorderRadius.circular(
                15,
              ),
              image: DecorationImage(
                image: NetworkImage(
                    //
                    widget.getImageFullArray[index]['image'].toString()
                    //
                    ),
                fit: BoxFit.cover,
              ),
            ),
            // child:
          ),
        );
      },
    );
  }
}
