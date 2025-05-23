import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sysbin/screens/home_.dart';
import 'package:sysbin/services/userauth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showPassword = false;
  // form Key
  final _formKey = GlobalKey<FormState>();
  // Editing Controllers

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Firebase
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
// Email Field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter your Email");
        }
        // Reg Exp For Email Validator
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ('Please Enter a Valid Email');
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        hintText: 'Email',
        prefixIcon: Icon(Icons.email),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
// Password Field
    final passwordField = TextFormField(
      obscureText: !showPassword,
      autofocus: false,
      controller: passwordController,
      validator: (value) {
        // RegExp regex = RegExp(r'^.{6,}$');
        RegExp regex = RegExp(
            r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,10}$");
        if (value!.isEmpty) {
          return ('Password is Required');
        }
        if (!regex.hasMatch(value)) {
          return ('Min. 6 Characters and Max 10 characters with Upper,Lowercase ,Number &  Special Characters');
        }
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        errorMaxLines: 3,
        hintText: 'Password',
        prefixIcon: Icon(Icons.key),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    final loginBtn = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.green[600],
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          signIn(emailController.text, passwordController.text);
        },
        child: const Text(
          'Login',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(35.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 200,
                    child: Image.asset(
                      'assets/app_icon.png',
                      // fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(
                    height: 45,
                  ),
                  emailField,
                  const SizedBox(
                    height: 25,
                  ),
                  passwordField,
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: TextButton(
                        onPressed: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                        child: Text('Hide/Show Password')),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  loginBtn
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }

// Sign In Function
  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) {
        UserHelper.saveUser(uid.user!);
        Fluttertoast.showToast(msg: 'Login SuccessFull');
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
      }).catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }
}

// Login Function
