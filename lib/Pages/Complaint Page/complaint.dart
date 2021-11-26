import 'dart:io';
import 'package:flutter_dropdown_x/flutter_dropdown_x.dart';
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

  String _selected = "";
  TextEditingController _titleController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
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
                      height: 1.2,
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
                                vertical: 8.0, horizontal: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    "Title",
                                    style: TextStyle(
                                        height: 1.2,
                                        fontSize: 70.sp,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black87),
                                  ),
                                ),
                                SizedBox(
                                  height: 15.h,
                                ),
                                Container(
                                  // color: Colors.amber,
                                  // padding: EdgeInsets.all(0),
                                  //padding:
                                  //  EdgeInsets.symmetric(horizontal: 10.0),
                                  // decoration: BoxDecoration(
                                  //   borderRadius: BorderRadius.circular(3.0),
                                  //   border: Border.all(
                                  //       color: Colors.grey,
                                  //       style: BorderStyle.solid,
                                  //       width: 0.90),
                                  // ),
                                  // child: DropDownField(
                                  //   //autocorrect: true,
                                  //   controller: _titleController,
                                  //   //textInputAction: TextInputAction.next,
                                  //   //decoration: InputDecoration(
                                  //   hintText: 'Select Title Tags*',
                                  //   enabled: true,
                                  //   itemsVisibleInDropdown: 3,
                                  //   items: problem,
                                  //   onValueChanged: (value) {
                                  //     setState(() {
                                  //       selectproblem = value;
                                  //     });
                                  //   },
                                  // ),

                                  child: DropDownField(
                                    hintText: 'Enter Title Tag*',
                                    value: _selected,
                                    onChanged: (v) {
                                      setState(() {
                                        _selected = v;
                                      });
                                    },
                                    dataSource: const [
                                      {
                                        "display": "Potholes",
                                        "value": "1",
                                      },
                                      {
                                        "display": "Water Logging",
                                        "value": "2",
                                      },
                                      {
                                        "display": "Unauthorized Median Cut",
                                        "value": "3",
                                      },
                                    ],
                                    textField: 'display',
                                    valueField: 'value',
                                  ),
                                ),
                                /* SizedBox(
                                  height: 5.h,
                                )*/
                              ],
                            ),
                          ),
                          /* SizedBox(
                            height: 25,
                          ),*/
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Location",
                                  style: TextStyle(
                                      height: 1.2,
                                      fontSize: 70.sp,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black87),
                                ),
                                SizedBox(
                                  height: 30.h,
                                ),
                                TextField(
                                  autocorrect: true,
                                  controller: _locationController,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    hintText: 'Enter Location*',
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
                                /*SizedBox(
                                  height: 30.h,
                                )*/
                              ],
                            ),
                          ),
                          /* SizedBox(
                            height: 25,
                          ),*/
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Description",
                                  style: TextStyle(
                                      height: 1.2,
                                      fontSize: 70.sp,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black87),
                                ),
                                SizedBox(
                                  height: 30.h,
                                ),
                                TextField(
                                  autocorrect: true,
                                  controller: _descriptionController,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    hintText: 'Fill in your complaint here*',
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
                              ],
                            ),
                          ),
                          Material(
                            color: Colors.white,
                            child: ListView(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 16),
                                  child: Text(
                                    "Add Photos",
                                    style: TextStyle(
                                        height: 1.2,
                                        fontSize: 70.sp,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black87),
                                  ),
                                ),
                                /*SizedBox(
                                  height: 20,
                                ),*/
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          MediaQuery.of(context).size.width /
                                              3.5),
                                  child: Container(
                                      //     // color: Colors.pinkAccent,
                                      height: 150,
                                      width: 100,
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
                          SizedBox(height: 20.h),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 300.h),
                                primary: Palette.orange,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide.none,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: Text(
                                'Post Listing',
                                style: TextStyle(
                                    height: 1.2,
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
