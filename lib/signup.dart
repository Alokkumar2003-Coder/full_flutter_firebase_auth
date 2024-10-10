import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:full_flutter_firebase_auth/home.dart';
import 'package:full_flutter_firebase_auth/login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String email = "", password = "", name = "";
  TextEditingController namecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController mailcontroller = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  registration() async {
    if (namecontroller.text != "" && mailcontroller.text != "") {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          "Registered Successfully",
          style: TextStyle(fontSize: 20.0),
        )));
        // ignore: use_build_context_synchronously
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Home()));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Password Provided is too Weak",
                style: TextStyle(fontSize: 18.0),
              )));
        } else if (e.code == "email-already-in-use") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Account Already exists",
                style: TextStyle(fontSize: 18.0),
              )));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    "images/car.PNG",
                    fit: BoxFit.cover,
                  )),
              const SizedBox(
                height: 30.0,
              ),
              Form(
                key: _formkey,
                child: Column(
                  children: [
                    // Name input field
                    buildInputField(
                      controller: namecontroller,
                      hintText: "Name",
                      validatorText: 'Please Enter Name',
                    ),
                    const SizedBox(height: 30.0),
                    // Email input field
                    buildInputField(
                      controller: mailcontroller,
                      hintText: "Email",
                      validatorText: 'Please Enter Email',
                    ),
                    const SizedBox(height: 30.0),
                    // Password input field
                    buildInputField(
                      controller: passwordcontroller,
                      hintText: "Password",
                      validatorText: 'Please Enter Password',
                      obscureText: true,
                    ),
                    const SizedBox(height: 30.0),
                    // Sign Up button
                    GestureDetector(
                      onTap: () {
                        if (_formkey.currentState!.validate()) {
                          setState(() {
                            email = mailcontroller.text;
                            name = namecontroller.text;
                            password = passwordcontroller.text;
                          });
                        }
                        registration();
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(
                              vertical: 13.0, horizontal: 30.0),
                          decoration: BoxDecoration(
                              color: const Color(0xFF273671),
                              borderRadius: BorderRadius.circular(30)),
                          child: const Center(
                              child: Text(
                            "Sign Up",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22.0,
                                fontWeight: FontWeight.w500),
                          ))),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40.0),
              // Additional text and icon buttons
              const Text(
                "or LogIn with",
                style: TextStyle(
                    color: Color(0xFF273671),
                    fontSize: 22.0,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "images/google.png",
                    height: 45,
                    width: 45,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 30.0),
                  Image.asset(
                    "images/apple1.png",
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
              const SizedBox(height: 40.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?",
                      style: TextStyle(
                          color: Color(0xFF8c8e98),
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(width: 5.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LogIn()));
                    },
                    child: const Text(
                      "LogIn",
                      style: TextStyle(
                          color: Color(0xFF273671),
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputField(
      {required TextEditingController controller,
      required String hintText,
      required String validatorText,
      bool obscureText = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 30.0),
      decoration: BoxDecoration(
          color: const Color(0xFFedf0f8), borderRadius: BorderRadius.circular(30)),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return validatorText;
          }
          return null;
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xFFb2b7bf), fontSize: 18.0),
        ),
      ),
    );
  }
}
