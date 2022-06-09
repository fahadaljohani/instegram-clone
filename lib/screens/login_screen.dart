import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instegram_clone/main.dart';
import 'package:instegram_clone/resources/auth_methods.dart';
import 'package:instegram_clone/responsive_layout/mobile_layout_screen.dart';
import 'package:instegram_clone/screens/sign_up.dart';
import 'package:instegram_clone/utils/colors.dart';
import 'package:instegram_clone/utils/utils.dart';
import 'package:instegram_clone/wedgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
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
              TextFieldInput(
                  hintText: 'Enter your email',
                  controller: _emailController,
                  inputType: TextInputType.emailAddress),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                hintText: 'Enter your password ?',
                controller: _passController,
                inputType: TextInputType.text,
                isSecure: true,
              ),
              const SizedBox(
                height: 24,
              ),
              InkWell(
                onTap: () async {
                  setState(() {
                    isLoading = true;
                  });
                  final result = await AuthMethods().loginUser(
                      email: _emailController.text,
                      password: _passController.text);
                  if (result != "success") {
                    showSnackBar(context, result);
                  } else {
                    showSnackBar(context, "Login Successfully");
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MobileScreenLayouts(),
                      ),
                    );
                  }
                  setState(() {
                    isLoading = false;
                  });
                },
                child: Container(
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
                              width: 17,
                              height: 17,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                            // SizedBox(
                            //   width: 10,
                            // ),
                            // Text(
                            //   'Log in',
                            //   style: TextStyle(
                            //       color: primaryColor,
                            //       fontWeight: FontWeight.bold),
                            // )
                          ],
                        )
                      : const Text(
                          'Log in',
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
                    child: const Text('Don\'have a acount? '),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUp(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        'Sign Up',
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
