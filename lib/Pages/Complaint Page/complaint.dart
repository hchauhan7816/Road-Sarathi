import 'dart:io';
import 'package:flutter_dropdown_x/flutter_dropdown_x.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sadak/Config/constants.dart';
import 'package:sadak/Config/palette.dart';
import 'package:sadak/Modal/chat_messages.dart';
import 'package:sadak/Modal/chatroom_map.dart';
import 'package:sadak/Pages/Chat%20Screen/chat_screen.dart';
import 'package:sadak/Services/Controllers/auth_controller.dart';
import 'package:sadak/Widgets/custom_scaffold.dart';
import 'package:uuid/uuid.dart';

import 'Widgets/appbar_complaint.dart';

class ComplaintPage extends StatelessWidget {
  const ComplaintPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: Palette.peach,
      body: ComplaintPageBody(),
      appBar: complaintPageAppBar(context),
    );
  }
}

class ComplaintPageBody extends StatefulWidget {
  const ComplaintPageBody({Key? key}) : super(key: key);

  @override
  State<ComplaintPageBody> createState() => _ComplaintPageBodyState();
}

class _ComplaintPageBodyState extends State<ComplaintPageBody> {
  FirebaseHelper firebaseHelper = Get.find<FirebaseHelper>();

  String? _selected;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  double? latitude, longitude;
  String? userAddress;
  bool locationRecieved = false;
  bool changeButton = false;
  bool isLoading = false;
  AnimationController? rotationController;

  LatLng? position;

  bool isUploading = false;
  File? imageFile;

  // ignore: non_constant_identifier_names
  String? ImageUrl;

  @override
  void initState() {
    Constants.myEmail = firebaseHelper.auth.currentUser!.email!;

    super.initState();
  }

  setLocation({required lat, required lon}) async {
    latitude = lat;
    longitude = lon;

    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
    Placemark place = placemarks[0];

    setState(() {
      position = LatLng(lat, lon);
      locationRecieved = true;
      changeButton = true;

      userAddress =
          "${place.subThoroughfare}, ${place.thoroughfare} , ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}";

      _locationController.text = userAddress!;
    });
  }

  void getUserLocation() async {
    setState(() {
      isLoading = true;
    });

    LocationPermission permission = await Geolocator.checkPermission();
    bool serviceEnabled;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location Service Disabled');
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      LocationPermission asked = await Geolocator.requestPermission();

      if (asked == LocationPermission.whileInUse ||
          asked == LocationPermission.always) {
        Position currentPosition = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best);

        setLocation(
            lat: currentPosition.latitude, lon: currentPosition.longitude);
      }
    } else {
      Position currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);

      setLocation(
          lat: currentPosition.latitude, lon: currentPosition.longitude);
    }

    setState(() {
      isLoading = false;
    });
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

    String fileName = const Uuid().v1();

    var ref = FirebaseStorage.instance.ref().child('images').child(fileName);

    var uploadTask = await ref.putFile(imageFile!);

    ImageUrl = await uploadTask.ref.getDownloadURL();

    setState(() {
      isUploading = false;
    });
  }

  void sendDetails() {
    int val = DateTime.now().millisecondsSinceEpoch;

    if (ImageUrl != null &&
        ImageUrl!.isNotEmpty &&
        _selected != null &&
        locationRecieved) {
      var chatroomId = firebaseHelper.getChatroomId(
        userEmail1: Constants.myEmail,
        userEmail2: "localauthority@gmail.com",
        val: val,
      );

      var chatroomMap = ChatroomModal(
        users: Constants.myEmail,
        authority: "localauthority@gmail.com",
        chatroomId: chatroomId,
        isWithHigher: false,
        title: _selected!,
        completed: false,
        dueDate: DateTime.now().add(const Duration(days: 60)),
      );

      firebaseHelper.createChatRooms(
        userEmail1: Constants.myEmail,
        userEmail2: "localauthority@gmail.com",
        chatroomId: chatroomId,
        chatroomMap: chatroomMap.toJson(),
      );

      firebaseHelper.setConversationMessages(
        chatroomId: chatroomId,
        messageMap: ModalChatMessages(
          message: ImageUrl!,
          sendBy: Constants.myEmail,
          text: false,
          isLocation: false,
          time: DateTime.now().millisecondsSinceEpoch,
        ).toJson(),
      );

      firebaseHelper.setConversationMessages(
        chatroomId: chatroomId,
        messageMap: ModalChatMessages(
                message: _descriptionController.text,
                sendBy: Constants.myEmail,
                text: true,
                isLocation: false,
                time: DateTime.now().millisecondsSinceEpoch)
            .toJson(),
      );

      firebaseHelper.setConversationMessages(
        chatroomId: chatroomId,
        messageMap: ModalChatMessages(
                message: "",
                sendBy: Constants.myEmail,
                text: false,
                isLocation: true,
                latitude: latitude!,
                longitude: longitude!,
                time: DateTime.now().millisecondsSinceEpoch)
            .toJson(),
      );

      Get.off(
        () => ChatScreen(
          isWithHigher: false,
          completed: false,
          chatroomId: chatroomId,
          userEmail: Constants.myEmail,
        ),
      );
    } else {
      Get.snackbar("Unable to Proceed", "Some data is still missing");
    }
  }

  Widget _imageBuilder(File? imageFile) {
    bool isLastItem = imageFile == null;

    return GestureDetector(
      onTap: () {
        if (isLastItem) {
          getImage();
        }
      },
      child: Container(
        child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide.none,
            borderRadius: BorderRadius.circular(15),
          ),
          color: Palette.peach,
          child: isLastItem
              ? Icon(Icons.camera_alt, size: 40, color: Colors.black)
              : ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    imageFile,
                  ),
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isUploading
        ? SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(
                  color: Colors.black,
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
                      color: Colors.black87),
                ),
              ],
            ),
          )
        : ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            child: Container(
              padding: const EdgeInsets.only(top: 20),
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
                                        "value": "Potholes",
                                      },
                                      {
                                        "display": "Water Logging",
                                        "value": "Water Logging",
                                      },
                                      {
                                        "display": "Unauthorized Median Cut",
                                        "value": "Unauthorized Median Cut",
                                      },
                                    ],
                                    textField: 'display',
                                    valueField: 'value',
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                                  minLines: 1,
                                  maxLines: 4,
                                  autocorrect: true,
                                  controller: _locationController,
                                  textInputAction: TextInputAction.next,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    hintText: 'Please provide your location*',
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 40.h, horizontal: 30.w),
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    border: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20.h),
                                Row(
                                  children: [
                                    const Spacer(),
                                    Material(
                                      color: Colors.orange[300],
                                      borderRadius: BorderRadius.circular(
                                          changeButton ? 50 : 8),
                                      child: InkWell(
                                        onTap: () {
                                          getUserLocation();
                                        },
                                        child: AnimatedContainer(
                                          duration: const Duration(seconds: 1),
                                          width: changeButton ? 50 : 200,
                                          height: 50,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                changeButton ? 50 : 8),
                                          ),
                                          child: isLoading
                                              ? const CircularProgressIndicator(
                                                  color: Colors.black54,
                                                )
                                              : changeButton
                                                  ? const Icon(Icons.refresh)
                                                  : const Text(
                                                      "Provide Location",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                              ],
                            ),
                          ),
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
                                    border: const OutlineInputBorder(
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
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 16),
                                  child: Text(
                                    "Add Photos",
                                    style: TextStyle(
                                      height: 1.2,
                                      fontSize: 70.sp,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          MediaQuery.of(context).size.width /
                                              3.5),
                                  child: SizedBox(
                                      height: 150,
                                      width: 100,
                                      child: _imageBuilder(imageFile)),
                                ),
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
                                    vertical: 16, horizontal: 250.w),
                                primary: Palette.peach,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide.none,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: const Text(
                                'Register Complaint',
                                style: TextStyle(
                                  height: 1.2,
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                              onPressed: () {
                                if (!isUploading) {
                                  sendDetails();
                                }
                              },
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
