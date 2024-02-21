import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pludin/classes/controllers/profile/profile_gallery/photo_gallery_modal/photo_gallery_modal.dart';

import '../../database/database_helper.dart';

import 'package:easy_image_viewer/easy_image_viewer.dart';

class ProfileGalleryScreen extends StatefulWidget {
  const ProfileGalleryScreen({super.key, required this.strUserId, this.type});

  final type;
  final String strUserId;

  @override
  State<ProfileGalleryScreen> createState() => _ProfileGalleryScreenState();
}

class _ProfileGalleryScreenState extends State<ProfileGalleryScreen> {
  //
  late DataBase handler;
  //
  final userGalleryApiCall = UserGalleryModal();
  //
  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];
  //
  var arrImageList = [];
  //
  @override
  void initState() {
    super.initState();
    //
    userGalleryApiCall
        .userGallertWB(
          widget.strUserId.toString(),
          widget.type.toString(),
        )
        .then((value1) => {
              // print(value1),
              setState(() {
                arrImageList = value1;
                // print(arrImageList);
                // print(arrImageList.length);
              })
            });
    //
  }

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
      itemCount: arrImageList.length,
      itemBuilder: (BuildContext ctx, index) {
        return Container(
          margin: const EdgeInsets.only(
              // left: 10.0,
              // right: 10,
              ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(
              15,
            ),
            image: DecorationImage(
              image: NetworkImage(
                  //
                  arrImageList[index]['image'].toString()
                  //
                  ),
              fit: BoxFit.fitWidth,
            ),
          ),
          // child:
        );
      },
    );
  }

  // select multiple images
  void selectImages() async {
    //
    imageFileList!.clear();
    //
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    // imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }

    /*setState(() {
      str_user_profile_loader = '0';
    });*/

    print("Image List Length: =====> ${imageFileList!.last}");
    print("Image List Length: =====> ${imageFileList!.length}");

    // upload_image_to_server();
  }
  //
}

class CustomImageProvider extends EasyImageProvider {
  @override
  final int initialIndex;
  final List<String> imageUrls;

  CustomImageProvider({required this.imageUrls, this.initialIndex = 0})
      : super();

  @override
  ImageProvider<Object> imageBuilder(BuildContext context, int index) {
    return NetworkImage(imageUrls[index]);
  }

  @override
  int get imageCount => imageUrls.length;
}
