import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sadak/Config/constants.dart';
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
        body: ComplaintPageBody(), appBar: complaintPageAppBar(context));
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
    // Todo wait till is uploading

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
    // dev.log("Here  ${ImageUrl}");
    int val = DateTime.now().millisecondsSinceEpoch;

    if (ImageUrl != null && ImageUrl!.isNotEmpty) {
      var chatroomId = firebaseHelper.getChatroomId(
          userEmail1: Constants.myEmail,
          userEmail2: "localauthority@gmail.com",
          val: val);

      // dev.log("Done CreateChatroomAndStartConversation");
      // Map<String, dynamic> chatroomMap = {
      //   "users": Constants.myEmail,
      //   "authority": "localauthority@gmail.com",
      //   "chatroomId": chatroomId,
      //   "title": _titleController.text,
      //   "location": _locationController.text,
      //   "completed": false,
      //   "dueDate": DateTime.now().add(const Duration(days: 60)),
      // };

      var chatroomMap = ChatroomModal(
          users: Constants.myEmail,
          authority: "higherauthority@gmail.com", // todo change
          chatroomId: chatroomId,
          title: _titleController.text,
          location: _locationController.text,
          completed: false,
          dueDate: DateTime.now().add(const Duration(days: 60)));

      firebaseHelper.createChatRooms(
          userEmail1: Constants.myEmail,
          userEmail2: "higherauthority@gmail.com", // todo change
          chatroomId: chatroomId,
          chatroomMap: chatroomMap.toJson());

      firebaseHelper.setConversationMessages(
          chatroomId: chatroomId,
          messageMap: ModalChatMessages(
                  message: ImageUrl!,
                  sendby: Constants.myEmail,
                  text: false,
                  time: DateTime.now().millisecondsSinceEpoch)
              .toJson());

      Get.to(() =>
          ChatScreen(chatroomId: chatroomId, userEmail: Constants.myEmail));
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
        width: 100,
        child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide.none,
            borderRadius: BorderRadius.circular(12),
          ),
          color: Colors.amber,
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
                    fit: BoxFit.cover,
                  ),
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Register Complaint'),
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                children: <Widget>[
                  Material(
                    // color: isDarkMode(context) ? Colors.black12 : Colors.white,
                    type: MaterialType.canvas,
                    elevation: 2,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16.0, left: 16.0, right: 16.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Title',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _titleController,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              hintText: 'Start typing',
                              isDense: true,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Material(
                      // color:
                      //     isDarkMode(context) ? Colors.black12 : Colors.white,
                      elevation: 2,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, right: 16, top: 16),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Location',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              keyboardType: TextInputType.multiline,
                              controller: _locationController,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                isDense: true,
                                hintText: 'Start typing',
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Material(
                    // color: isDarkMode(context) ? Colors.black12 : Colors.white,
                    elevation: 2,
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
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Add Photos',
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: SizedBox(
                              height: 100,
                              // child: ListView.builder(
                              //     shrinkWrap: true,
                              //     itemCount: _images.length,
                              //     scrollDirection: Axis.horizontal,
                              //     itemBuilder: (context, index) {
                              // File? image =_images[index];
                              child: _imageBuilder(imageFile) //;     return
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
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  primary: Colors.amber,
                  shape: RoundedRectangleBorder(
                    side: BorderSide.none,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: isUploading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : Text(
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
    );
  }
}
