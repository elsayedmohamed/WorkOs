import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:workos/screens/auth/login.dart';
import 'package:workos/user_state.dart';

import '../../constants.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController positionCPController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode fullNameFocusNode = FocusNode();
  FocusNode positionFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();

  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = false;
  bool _obsecured = true;

  File? imageFile;

  final formKey = GlobalKey<FormState>();

  Future<UserCredential> signUpByEmail() async {
    return await auth.createUserWithEmailAndPassword(
      email: emailController.text.toLowerCase().trim(),
      password: passController.text.trim(),
    );
  }

  void validSignUpForm() async {
    final isValid = formKey.currentState!.validate();
    if (imageFile != null) {
      if (isValid) {
        setState(() {
          isLoading = true;
        });

        await signUpByEmail().then((value) {
          saveUserSignUpData();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: ((context) => const UserStateScreen())),
              (route) => false);
        }).catchError((e) {
          setState(() {
            isLoading = false;
            showSnakError(e.toString());
          });
        });
      }
    } else {
      showSnakError('Image is required');
    }
    setState(() {
      isLoading = false;
    });
  }

  String? url;
  Future<void> saveUserSignUpData() async {
    FirebaseStorage storage = FirebaseStorage.instance;

    final ref = FirebaseStorage.instance
        .ref()
        .child('userImages')
        .child('${auth.currentUser!.uid}.jpg');

    await ref.putFile(imageFile!);
    url = await ref.getDownloadURL();

    FirebaseFirestore store = FirebaseFirestore.instance;
    await store.collection('users').doc(auth.currentUser!.uid).set({
      'name': fullNameController.text,
      'email': emailController.text,
      'phone': phoneController.text,
      'position': positionCPController.text,
      'date': Timestamp.now(),
      'image': '$url',
      'id':auth.currentUser!.uid,
    });
  }

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 20));
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((animationStatus) {
        if (animationStatus == AnimationStatus.completed) {
          _animationController.reset();
          _animationController.forward();
        }
      });
    _animationController.forward();

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    emailController.dispose();
    passController.dispose();
    fullNameController.dispose();
    positionCPController.dispose();
    // passController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    fullNameFocusNode.dispose();
    positionFocusNode.dispose();
    phoneFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl:
                'https://media.istockphoto.com/photos/businesswoman-using-computer-in-dark-office-picture-id557608443?k=6&m=557608443&s=612x612&w=0&h=fWWESl6nk7T6ufo4sRjRBSeSiaiVYAzVrY-CLlfMptM=',
            placeholder: (context, url) => Image.asset(
              'assets/images/wallpaper.jpg',
              fit: BoxFit.cover,
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fit: BoxFit.cover,
            // width: double.infinity,
            height: double.infinity,
            alignment: FractionalOffset(_animation.value, 0),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(children: [
              SizedBox(
                height: size.height * 0.1,
              ),
              const Text(
                'SignUp',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Do you have an account ?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen())),
                      text: ' Login',
                      style: TextStyle(
                        color: Colors.blue.shade100,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          flex: 2,
                          child: TextFormField(
                            focusNode: fullNameFocusNode,
                            textInputAction: TextInputAction.next,
                            onEditingComplete: (() => FocusScope.of(context)
                                .requestFocus(emailFocusNode)),
                            validator: ((value) {
                              if (value!.isEmpty) {
                                return 'Please enter a valid name';
                              }
                              return null;
                            }),
                            controller: fullNameController,
                            keyboardType: TextInputType.text,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Full name',
                              hintStyle: const TextStyle(
                                color: Colors.white,
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.pink.shade700,
                                ),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red.shade700,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  width: size.width * 0.24,
                                  height: size.width * 0.24,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.red,
                                    ),
                                  ),
                                  child: imageFile == null
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.network(
                                            'https://cdn-icons-png.flaticon.com/512/1077/1077012.png',
                                            fit: BoxFit.fill,
                                          ),
                                        )
                                      : Image.file(
                                          imageFile!,
                                          fit: BoxFit.fill,
                                        ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: InkWell(
                                  onTap: (() {
                                    showPhotoChooseDialog(context);
                                  }),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.pink,
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.white,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        imageFile == null
                                            ? Icons.add_a_photo
                                            : Icons.edit,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    TextFormField(
                      validator: ((value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Please enter a valid email adress';
                        }
                        return null;
                      }),
                      focusNode: emailFocusNode,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () => FocusScope.of(context)
                          .requestFocus(passwordFocusNode),
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: const TextStyle(
                          color: Colors.white,
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.pink.shade700,
                          ),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red.shade700,
                          ),
                        ),
                      ),
                    ),
                    // password ======================================================
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: ((value) {
                        if (value!.isEmpty || value.length < 6) {
                          return 'Please enter a valid password';
                        }
                        return null;
                      }),
                      focusNode: passwordFocusNode,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () =>
                          FocusScope.of(context).requestFocus(phoneFocusNode),
                      obscureText: _obsecured,
                      controller: passController,
                      keyboardType: TextInputType.visiblePassword,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          onTap: (() {
                            _obsecured = !_obsecured;
                          }),
                          child: Icon(
                            _obsecured
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white,
                          ),
                        ),
                        hintText: 'password',
                        hintStyle: const TextStyle(
                          color: Colors.white,
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.pink.shade700,
                          ),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red.shade700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: ((value) {
                        if (value!.isEmpty || value.length < 6) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      }),
                      focusNode: phoneFocusNode,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () => FocusScope.of(context)
                          .requestFocus(positionFocusNode),
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Phone',
                        hintStyle: const TextStyle(
                          color: Colors.white,
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.pink.shade700,
                          ),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red.shade700,
                          ),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        showCategoriesDialog(context);
                        setState(() {});
                      },
                      child: TextFormField(
                        validator: ((value) {
                          if (value!.isEmpty) {
                            return 'Please enter a valid position';
                          }
                          return null;
                        }),
                        focusNode: positionFocusNode,
                        textInputAction: TextInputAction.done,
                        controller: positionCPController,
                        keyboardType: TextInputType.text,
                        enabled: false,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Position in the company',
                          hintStyle: const TextStyle(
                            color: Colors.white,
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.pink.shade700,
                            ),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red.shade700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                      color: Colors.pink,
                    ))
                  : MaterialButton(
                      height: 55,
                      color: Colors.pink.shade600,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                        side: BorderSide.none,
                      ),
                      onPressed: validSignUpForm,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'SignUp',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.person_add,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
            ]),
          ),
        ],
      ),
    );
  }

  void pickedImagefromCamera() async {
    XFile? pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, maxWidth: 1080, maxHeight: 1080);
    setState(() {
      // imageFile = File(pickedFile!.path);
      imageCropper(pickedFile!.path);
    });
    // Navigator.pop(context);
  }

  void pickedImagefromGallarey() async {
    XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery, maxWidth: 1080, maxHeight: 1080);
    setState(() {
      // imageFile = File(pickedFile!.path);
      imageCropper(pickedFile!.path);
    });
    // Navigator.pop(context);
  }

  void imageCropper(filePathe) async {
    CroppedFile? imagecrop = await ImageCropper()
        .cropImage(sourcePath: filePathe, maxHeight: 1080, maxWidth: 1080);

    if (imagecrop != null) {
      imageFile = File(imagecrop.path);
      Navigator.pop(context);
    }
  }

  Future<dynamic> showPhotoChooseDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            titlePadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            title: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Please choose an option'),
                ),
                Divider(
                  thickness: 1,
                  color: Colors.grey,
                ),
              ],
            ),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              InkWell(
                onTap: pickedImagefromCamera,
                child: Row(
                  children: const [
                    Icon(
                      Icons.camera,
                      color: Colors.pink,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Camera',
                      style: TextStyle(
                        color: Colors.pink,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: pickedImagefromGallarey,
                child: Row(
                  children: const [
                    Icon(
                      Icons.photo,
                      color: Colors.pink,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Gallary',
                      style: TextStyle(
                        color: Colors.pink,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          );
        }));
  }

  Future<dynamic> showCategoriesDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Task category',
              style: TextStyle(color: Colors.pink.shade800),
            ),
            content: SizedBox(
              height: 200,
              width: 50,
              child: ListView.builder(
                //shrinkWrap: true,
                itemCount: AppConstants.jobsList.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: ((context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {});
                      positionCPController.text = AppConstants.jobsList[index];
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          color: Colors.red[200],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(AppConstants.jobsList[index]),
                      ],
                    ),
                  );
                }),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: const Text('Close'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: const Text('Cancel filter'),
              ),
            ],
          );
        });
  }

  void showSnakError(error) {
    final myErrorSnack = SnackBar(
      content: Text(error),
      duration: const Duration(
        seconds: 3,
      ),
      backgroundColor: Colors.pink,
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      width: double.infinity,
      behavior: SnackBarBehavior.floating,
      elevation: 10,
    );

    ScaffoldMessenger.of(context).showSnackBar(myErrorSnack);
  }
}
