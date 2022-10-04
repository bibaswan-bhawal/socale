import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:animations/animations.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:socale/components/keyboard_safe_area.dart';
import 'package:socale/components/translucent_background/bottom_translucent_card.dart';
import 'package:socale/screens/settings/avatar_picker.dart';
import 'package:socale/utils/providers/providers.dart';
import 'package:socale/values/colors.dart';

class AccountPage extends ConsumerStatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  ConsumerState<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends ConsumerState<AccountPage> {
  File? profilePicture;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  String firstName = "";
  String lastName = "";
  String email = "";
  DateTime dob = DateTime(1900, 1);
  DateTime grad = DateTime(1900, 1);

  bool firstTime = true;

  String avatar = "";

  void onBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userState = ref.watch(userAsyncController);

    if (firstTime) {
      firstTime = false;

      firstName = userState.value!.firstName;
      lastName = userState.value!.lastName;
      email = userState.value!.email;
      dob = userState.value!.dateOfBirth.getDateTime();
      grad = userState.value!.graduationMonth.getDateTime();
      avatar = userState.value!.avatar;

      firstNameController.text = firstName;
      lastNameController.text = lastName;
      emailController.text = email;

      if (userState.value!.profilePicture != null && userState.value!.profilePicture!.isNotEmpty) {
        getProfilePicture(userState.value!.profilePicture!);
      }
    }
  }

  void _onBirthDateClickEventHandler() async {
    if (Platform.isAndroid) {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: dob,
        firstDate: DateTime(1900, 1),
        lastDate: DateTime.now(),
        confirmText: 'Select',
      );

      if (picked != null && picked != dob) {
        setState(() => dob = picked);
      }
    } else {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height * 0.25,
            color: Colors.white,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (value) {
                if (value != dob) {
                  setState(() => dob = value);
                }
              },
              initialDateTime: dob,
            ),
          );
        },
      );
    }
  }

  void _onGradDateClickEventHandler() async {
    if (Platform.isAndroid) {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: grad,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100, 1),
        confirmText: 'Select',
      );

      if (picked != null && picked != grad) {
        setState(() => grad = picked);
      }
    } else {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height * 0.25,
            color: Colors.white,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (value) {
                if (value != grad) {
                  setState(() => grad = value);
                }
              },
              initialDateTime: grad,
            ),
          );
        },
      );
    }
  }

  Future<void> uploadProfilePic(String? currentKey, String newKey) async {
    final file = profilePicture;

    if (currentKey != null && currentKey.isNotEmpty) {
      try {
        final result = await Amplify.Storage.remove(key: currentKey);
        print('Deleted file: ${result.key}');
      } on StorageException catch (e) {
        print('Error deleting file: $e');
      }
    }

    try {
      final UploadFileResult result = await Amplify.Storage.uploadFile(
        local: file,
        key: newKey,
      );
      print('Successfully uploaded image: ${result.key}');
      return;
    } on StorageException catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> getProfilePicture(String key) async {
    print("getting profile picture: $key");
    final documentsDir = await getApplicationDocumentsDirectory();
    final filepath = '${documentsDir.path}/$key.jpg';
    final file = File(filepath);

    try {
      await Amplify.Storage.downloadFile(
        key: key,
        local: file,
      );

      print('downloaded file: $key');
      setState(() => profilePicture = file);
    } on StorageException catch (e) {
      print('Error downloading file: $e');
    }
  }

  void saveData() async {
    print("Saving Data");
    final userState = ref.watch(userAsyncController);
    final userStateNotifier = ref.read(userAsyncController.notifier);
    final newProfileKey = "${userState.value!.id}-${DateTime.now()}";
    print("Profile picture changed: ${profilePicture != null}");

    if (profilePicture != null) {
      await uploadProfilePic(userState.value!.profilePicture, newProfileKey);
      userStateNotifier.changeUserValue(
        userState.value!.copyWith(
          profilePicture: newProfileKey,
          avatar: avatar,
          firstName: firstName,
          lastName: lastName,
          dateOfBirth: TemporalDate(dob),
          graduationMonth: TemporalDate(grad),
        ),
      );
    } else {
      userStateNotifier.changeUserValue(
        userState.value!.copyWith(
          avatar: avatar,
          firstName: firstName,
          lastName: lastName,
          dateOfBirth: TemporalDate(dob),
          graduationMonth: TemporalDate(grad),
        ),
      );
    }

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userAsyncController);

    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFF2D2D2D),
      body: Stack(
        children: [
          BottomTranslucentCard(),
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 120,
                  color: Color(0xFF363636),
                  child: KeyboardSafeArea(
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              onPressed: () => onBack(context),
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: ColorValues.textOnDark,
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Your Account",
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.3,
                                  color: ColorValues.textOnDark,
                                ),
                              ),
                              Text(
                                "${userState.value!.firstName} ${userState.value!.lastName}",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: -0.3,
                                  color: ColorValues.textOnDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              onPressed: saveData,
                              icon: const Icon(
                                Icons.check,
                                color: ColorValues.textOnDark,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                CarouselSlider(
                  options: CarouselOptions(
                    height: 250.0,
                    viewportFraction: 0.4,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    autoPlay: false,
                  ),
                  items: [
                    Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: CircleAvatar(
                            radius: 80,
                            child: Image.asset('assets/images/avatars/$avatar'),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 50,
                          child: Material(
                            elevation: 5,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Color(0xFF494949),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: GestureDetector(
                                onTap: () async {
                                  final result = await Navigator.of(context).push(
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) => AvatarPicker(
                                        initial: avatar,
                                      ),
                                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                        return SharedAxisTransition(
                                          animation: animation,
                                          secondaryAnimation: secondaryAnimation,
                                          transitionType: SharedAxisTransitionType.horizontal,
                                          child: child,
                                        );
                                      },
                                    ),
                                  ) as String;

                                  if (result.isNotEmpty) {
                                    setState(() => avatar = result);
                                  }
                                },
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 1, bottom: 0.5),
                                    child: SvgPicture.asset('assets/icons/pencil_icon.svg'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    GestureDetector(
                      onTap: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image = await picker.pickImage(source: ImageSource.gallery);

                        if (image != null) {
                          print("edit image: ${image.path}");

                          CroppedFile? croppedFile = await ImageCropper().cropImage(
                            cropStyle: CropStyle.circle,
                            compressQuality: 50,
                            aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
                            sourcePath: image.path,
                            aspectRatioPresets: [
                              CropAspectRatioPreset.square,
                            ],
                            uiSettings: [
                              AndroidUiSettings(
                                toolbarTitle: 'Cropper',
                                toolbarColor: ColorValues.socaleDarkOrange,
                                initAspectRatio: CropAspectRatioPreset.square,
                                lockAspectRatio: true,
                              ),
                              IOSUiSettings(
                                title: 'Cropper',
                              ),
                              WebUiSettings(
                                context: context,
                              ),
                            ],
                          );

                          if (croppedFile != null) {
                            setState(() => profilePicture = File(croppedFile.path));
                          }
                        }
                      },
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 40),
                            child: CircleAvatar(
                              radius: 80,
                              backgroundColor: Color(0xFF494949),
                              child: ClipOval(
                                child: profilePicture != null ? Image.file(profilePicture!) : SvgPicture.asset('assets/icons/add_picture_icon.svg'),
                              ),
                            ),
                          ),
                          if (profilePicture != null)
                            Positioned(
                              right: 0,
                              top: 50,
                              child: Material(
                                elevation: 5,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF494949),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 1, bottom: 0.5),
                                        child: SvgPicture.asset('assets/icons/pencil_icon.svg'),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  width: size.width,
                  height: 50,
                  margin: EdgeInsets.only(right: 15, left: 15),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "First name",
                            style: GoogleFonts.poppins(
                              color: ColorValues.textOnDark,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: firstNameController,
                              textAlign: TextAlign.end,
                              onChanged: (value) {
                                setState(() => firstName = value);
                              },
                              style: GoogleFonts.roboto(color: Color(0xFF479CFF)),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 1,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
                Container(
                  width: size.width,
                  height: 50,
                  margin: EdgeInsets.only(right: 15, left: 15),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Last name",
                            style: GoogleFonts.poppins(
                              color: ColorValues.textOnDark,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: lastNameController,
                              textAlign: TextAlign.end,
                              onChanged: (value) {
                                setState(() => lastName = value);
                              },
                              style: GoogleFonts.roboto(color: Color(0xFF479CFF)),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 1,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
                // Container(
                //   width: size.width,
                //   height: 50,
                //   margin: EdgeInsets.only(right: 15, left: 15),
                //   child: Column(
                //     children: [
                //       Row(
                //         children: [
                //           Text(
                //             "Email",
                //             style: GoogleFonts.poppins(
                //               color: ColorValues.textOnDark,
                //               fontWeight: FontWeight.w600,
                //             ),
                //           ),
                //           Expanded(
                //             child: TextField(
                //               controller: emailController,
                //               textAlign: TextAlign.end,
                //               onChanged: (value) {
                //                 setState(() => email = value);
                //               },
                //               style: GoogleFonts.roboto(
                //                 color: Color(0xFF479CFF),
                //               ),
                //               decoration: InputDecoration(
                //                 contentPadding: EdgeInsets.zero,
                //                 border: InputBorder.none,
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                //       Container(
                //         height: 1,
                //         color: Colors.white,
                //       )
                //     ],
                //   ),
                // ),
                GestureDetector(
                  onTap: _onBirthDateClickEventHandler,
                  child: Container(
                    width: size.width,
                    height: 50,
                    margin: EdgeInsets.only(right: 15, left: 15),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: Row(
                            children: [
                              Text(
                                "Date of Birth",
                                style: GoogleFonts.poppins(
                                  color: ColorValues.textOnDark,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  DateFormat('MM/dd/yyyy').format(dob),
                                  textAlign: TextAlign.end,
                                  style: GoogleFonts.poppins(
                                    color: Color(0xFF479CFF),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 1,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _onGradDateClickEventHandler,
                  child: Container(
                    width: size.width,
                    height: 50,
                    margin: EdgeInsets.only(right: 15, left: 15),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: Row(
                            children: [
                              Text(
                                "Graduation year",
                                style: GoogleFonts.poppins(
                                  color: ColorValues.textOnDark,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  DateFormat('MM/yyyy').format(grad),
                                  textAlign: TextAlign.end,
                                  style: GoogleFonts.poppins(
                                    color: Color(0xFF479CFF),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 1,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
