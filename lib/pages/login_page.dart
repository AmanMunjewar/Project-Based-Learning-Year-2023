import 'package:flutter/material.dart';
import 'package:mat_security/common/constants.dart';
import 'package:mat_security/services/auth.dart';
import '../common/loading_page.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final _formKey = GlobalKey<FormState>(); // GlobalKey for the form
  final AuthService _auth = AuthService() ;
  late String email = '';
  late String password = '';
  bool loading = false ;
  late String error = '' ;

  void nextPage() {
    Navigator.pushReplacementNamed(context, "/home") ;
  }

  @override
  Widget build(BuildContext context) {
    return loading ? const Loading() : Scaffold(
      backgroundColor: Colors.black45,
      body: Container(
        padding:const EdgeInsets.symmetric(horizontal: 40.0, vertical: 80.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 15.0),
              const Text(
                "MAT SECURITY" ,
                style: TextStyle(
                  letterSpacing: 1.5,
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 40.0),
              TextFormField(
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 20
                ),
                decoration: textInputDecoration.copyWith(hintText: "Email"),
                validator: (val) => val == null || val.isEmpty ? "Enter an Email" : null,
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              const SizedBox(height: 40.0),
              TextFormField(
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 20
                ),
                obscureText: true,
                decoration: textInputDecoration.copyWith(hintText: "Password"),
                validator: (val) => val == null || val.length < 6 ? "Enter a password 6+ characters long" : null,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(),
                      child: const Text(
                        'LOGIN',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                      onPressed: () async{
                        if(_formKey.currentState!.validate()){
                          setState(() => loading = true);
                          dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                          if(result == null){
                            setState(() {
                              loading = false ;
                              error = 'Could not sign in with those credentials' ;
                            });
                          }
                          else
                          {
                            nextPage();
                          }
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(),
                      onPressed: () async {
                        if(_formKey.currentState!.validate()){
                          setState(() => loading = true);
                          dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                          if(result == null){
                            setState(() {
                              loading = false ;
                              error = 'Please Enter Valid Email' ;
                            });
                          }
                          else
                          {
                            nextPage();
                          }
                        }
                      },
                      child: const Text(
                        'SIGN UP',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                error,
                style: const TextStyle(color: Colors.red, fontSize: 14.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}