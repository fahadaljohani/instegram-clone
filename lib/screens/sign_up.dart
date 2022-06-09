import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instegram_clone/main.dart';
import 'package:instegram_clone/resources/auth_methods.dart';
import 'package:instegram_clone/utils/colors.dart';
import 'package:instegram_clone/utils/utils.dart';
import 'package:instegram_clone/wedgets/text_field_input.dart';

import 'login_screen.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // - Properties
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool isLoading = false;
  // - Wedget State
  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  // - Methods
  void selectPhoto() async {
    Uint8List _file = await pickImage(ImageSource.gallery);
    setState(() {
      _image = _file;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              SvgPicture.asset(
                'assets/ic_instagram.svg',
                height: 64,
                color: primaryColor,
              ),
              // const Text(
              //   'Investivation',
              //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
              // ),
              const SizedBox(
                height: 64,
              ),
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : const CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(
                              'https://media.istockphoto.com/photos/businessman-silhouette-as-avatar-or-default-profile-picture-picture-id476085198'),
                        ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: () => selectPhoto(),
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                  hintText: 'Enter your username',
                  controller: _usernameController,
                  inputType: TextInputType.text),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                hintText: 'Enter your email',
                controller: _emailController,
                inputType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                hintText: 'Enter your password',
                controller: _passController,
                inputType: TextInputType.text,
                isSecure: true,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                hintText: 'Enter your bio',
                controller: _bioController,
                inputType: TextInputType.text,
              ),
              const SizedBox(
                height: 24,
              ),
              InkWell(
                onTap: () async {
                  if (_image == null) return;
                  setState(() {
                    isLoading = true;
                  });
                  final result = await AuthMethods().createUser(
                      username: _usernameController.text,
                      email: _emailController.text,
                      password: _passController.text,
                      bio: _bioController.text,
                      profilephoto: _image!);
                  setState(() {
                    isLoading = false;
                  });
                  if (result != "success") {
                    showSnackBar(context, result);
                  } else {
                    showSnackBar(context, 'Create account successfully.');
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const MyApp()));
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  width: double.infinity,
                  decoration: const ShapeDecoration(
                    color: blueColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                  ),
                  child: isLoading == true
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            SizedBox(
                              height: 17,
                              width: 17,
                              child: CircularProgressIndicator(
                                color: primaryColor,
                              ),
                            ),
                            // SizedBox(
                            //   width: 10,
                            // ),
                            // Text(
                            //   'Sign Up',
                            //   textAlign: TextAlign.center,
                            //   style: TextStyle(
                            //       color: primaryColor,
                            //       fontWeight: FontWeight.bold),
                            // ),
                          ],
                        )
                      : const Text(
                          'Sign Up',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: primaryColor, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text('Already have a account? '),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        'Log In',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
