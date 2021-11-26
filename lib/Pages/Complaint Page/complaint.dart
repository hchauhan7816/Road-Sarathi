import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sadak/Config/constants.dart';
import 'package:sadak/Config/palette.dart';
import 'package:sadak/Modal/chat_messages.dart';
import 'package:sadak/Modal/chatroom_map.dart';
import 'package:sadak/Pages/Chat%20Screen/chat_screen.dart';
import 'package:sadak/Pages/On%20Boarding/on_boarding.dart';
import 'package:sadak/Services/Controllers/auth_controller.dart';
import 'package:sadak/Widgets/custom_scaffold.dart';
import 'package:uuid/uuid.dart';
import 'dart:developer' as dev;

import 'Widgets/appbar_complaint.dart';

class ComplaintPage extends StatelessWidget {
  const ComplaintPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        backgroundColor: Colors.blueGrey,
        body: ComplaintPageBody(),
        appBar: complaintPageAppBar(context));
  }
}

class ComplaintPageBody extends StatefulWidget {
  ComplaintPageBody({Key? key}) : super(key: key);

  @override
  State<ComplaintPageBody> createState() => _ComplaintPageBodyState();
}

class _ComplaintPageBodyState extends State<ComplaintPageBody> {
  FirebaseHelper firebaseHelper = Get.find<FirebaseHelper>();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  bool isUploading = false;
  File? imageFile;

  String? ImageUrl;

  @override
  void initState() {
    Constants.myEmail = firebaseHelper.auth.currentUser!.email!;

    super.initState();
  }

  Future getImage() async {
    ImagePicker _picker = ImagePicker();
    await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage();
      }
    });
  }

  Future uploadImage() async {
    setState(() {
      isUploading = true;
    });

    String fileName = Uuid().v1();

    var ref = FirebaseStorage.instance.ref().child('images').child('$fileName');

    var uploadTask = await ref.putFile(imageFile!);

    ImageUrl = await uploadTask.ref.getDownloadURL();

    setState(() {
      isUploading = false;
    });
  }

  void sendDetails() {
    int val = DateTime.now().millisecondsSinceEpoch;

    if (ImageUrl != null && ImageUrl!.isNotEmpty) {
      var chatroomId = firebaseHelper.getChatroomId(
          userEmail1: Constants.myEmail,
          userEmail2: "localauthority@gmail.com",
          val: val);

      var chatroomMap = ChatroomModal(
          users: Constants.myEmail,
          authority:
              "localauthority@gmail.com", // saved place dont delete this comment
          chatroomId: chatroomId,
          isWithHigher: false,
          title: _titleController.text,
          location: _locationController.text,
          completed: false,
          dueDate: DateTime.now().add(const Duration(days: 60)));

      firebaseHelper.createChatRooms(
          userEmail1: Constants.myEmail,
          userEmail2:
              "localauthority@gmail.com", // saved place dont delete this comment
          chatroomId: chatroomId,
          chatroomMap: chatroomMap.toJson());

      firebaseHelper.setConversationMessages(
          chatroomId: chatroomId,
          messageMap: ModalChatMessages(
                  message: ImageUrl!,
                  sendBy: Constants.myEmail,
                  text: false,
                  isLocation: false,
                  time: DateTime.now().millisecondsSinceEpoch)
              .toJson());

      firebaseHelper.setConversationMessages(
          chatroomId: chatroomId,
          messageMap: ModalChatMessages(
                  message: "",
                  sendBy: Constants.myEmail,
                  text: false,
                  isLocation: true,
                  latitude: 24.234,
                  longitude: 73.283,
                  time: DateTime.now().millisecondsSinceEpoch)
              .toJson());

      Get.off(() => ChatScreen(
          isWithHigher: false,
          completed: false,
          chatroomId: chatroomId,
          userEmail: Constants.myEmail));
    } else {
      // Todo
      Get.snackbar("Unable to Proceed", "Image not Uploaded");
    }
  }

  Widget _imageBuilder(File? imageFile) {
    bool isLastItem = imageFile == null;

    return GestureDetector(
      onTap: () {
        if (isLastItem) {
          getImage();
        }
        // isLastItem ? _pickImage() : _viewOrDeleteImage(imageFile);
      },
      child: Container(
        // constraints: BoxConstraints(maxWidth: 10),
        //   width: 100,
        child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide.none,
            borderRadius: BorderRadius.circular(15),
          ),
          color: Palette.orange,
          child: isLastItem
              ? Icon(Icons.camera_alt,
                  size: 40,
                  color: Colors
                      .white //isDarkMode(context) ? Colors.black : Colors.white,
                  )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    imageFile,
                    // fit: BoxFit.cover,
                  ),
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isUploading
        ? Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: Colors.amber,
                ),
                SizedBox(
                  height: 50,
                ),
                Text(
                  "Uploading Image",
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w300,
                      color: Colors.white70),
                ),
              ],
            ),
          )
        : ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            child: //Conversation(user: widget.user),
                Container(
              padding: EdgeInsets.only(top: 20),
              color: Colors.white,
              child: Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Title",
                                  style: TextStyle(
                                      fontSize: 70.sp,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black87),
                                ),
                                SizedBox(
                                  height: 15.h,
                                ),
                                TextField(
                                  autocorrect: true,
                                  controller: _titleController,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    hintText: 'Enter Title',
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 40.h, horizontal: 30.w),
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30.h,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Location",
                                  style: TextStyle(
                                      fontSize: 70.sp,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black87),
                                ),
                                SizedBox(
                                  height: 15.h,
                                ),
                                TextField(
                                  autocorrect: true,
                                  controller: _locationController,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    hintText: 'Enter Location',
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 40.h, horizontal: 30.w),
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30.h,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Material(
                            color: Colors.white,
                            // color: isDarkMode(context) ? Colors.black12 : Colors.white,
                            // elevation: 2,
                            child: ListView(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              children: <Widget>[
                                // ListTile(
                                //   dense: true,
                                //   title: Text(
                                //     'Filters',
                                //     style: TextStyle(fontSize: 20),
                                //   ),
                                // trailing: Text(_filters?.isEmpty ?? true
                                //     ? 'Set Filters'
                                //     : 'Edit Filters'),
                                // onTap: () async {
                                //   _filters = await showModalBottomSheet(
                                //     isScrollControlled: true,
                                //     context: context,
                                //     shape: RoundedRectangleBorder(
                                //       borderRadius: BorderRadius.vertical(
                                //         top: Radius.circular(20),
                                //       ),
                                //     ),
                                //     builder: (context) {
                                //       return FiltersScreen(
                                //           filtersValue: _filters ?? {});
                                //     },
                                //   );
                                //   if (_filters == null) _filters = Map();
                                //   setState(() {});
                                //   print('${_filters.toString()}'.tr());
                                // },
                                // ),
                                // ListTile(
                                //   title: Text(
                                //     'Location',
                                //     style: TextStyle(fontSize: 20),
                                //   ),
                                //   // trailing: Container(
                                //   width: MediaQuery.of(context).size.width / 2,
                                //   child: Text(
                                //     _placeDetail != null
                                //         ? '${_placeDetail!.result.formattedAddress}'
                                //             .tr()
                                //         : 'Select Place'.tr(),
                                //     textAlign: TextAlign.end,
                                //   ),
                                // ),
                                // onTap: () async {
                                //   Prediction? p = await PlacesAutocomplete.show(
                                //     context: context,
                                //     apiKey: GOOGLE_API_KEY,
                                //     mode: Mode.fullscreen,
                                //     language: 'en',
                                //   );
                                //   if (p != null)
                                //     _placeDetail = await _places
                                //         .getDetailsByPlaceId(p.placeId ?? '');
                                //   setState(() {});
                                // },
                                // ),

                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 16),
                                  child: Text(
                                    "Add Photos",
                                    style: TextStyle(
                                        fontSize: 70.sp,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black87),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          MediaQuery.of(context).size.width /
                                              3.5),
                                  child: Container(
                                      //     // color: Colors.pinkAccent,
                                      height: 150,
                                      width: 150,
                                      //     // child: ListView.builder(
                                      //     shrinkWrap: true,
                                      //     itemCount: _images.length,
                                      //     scrollDirection: Axis.horizontal,
                                      //     itemBuilder: (context, index) {
                                      // File? image =_images[index];
                                      child: _imageBuilder(
                                          imageFile) //;     return
                                      //     }),
                                      ),
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.only(bottom: 8.0),
                                //   child: GestureDetector(
                                //     child: SizedBox(
                                //       height: 100,
                                //       child: Container(
                                //           color: Colors.amber,
                                //           child:
                                //               Center(child: Icon(Icons.add_a_photo))),
                                //     ),
                                //     onTap: () {
                                //       getImage();
                                //     },
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 24),
                          primary: Palette.orange,
                          shape: RoundedRectangleBorder(
                            side: BorderSide.none,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: Text(
                          'Post Listing',
                          style: TextStyle(
                              // color: isDarkMode(context)
                              //     ? Colors.black
                              color: Colors.white,
                              fontSize: 20),
                        ),
                        onPressed: () {
                          if (!isUploading) {
                            sendDetails();
                          }
                        }, // => _postListing()),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
