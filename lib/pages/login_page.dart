import 'package:authentification/services/firebase/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  bool _isLoading = false;
  bool _forLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_forLogin ? widget.title : "S'inscrire"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer votre email";
                  } else {
                    return null;
                  }
                },
              ),

              SizedBox(height: 20),

              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer votre Password";
                  } else {
                    return null;
                  }
                },
              ),

              SizedBox(height: 20),

              if (!_forLogin)
                TextFormField(
                  controller: _passwordConfirmController,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: "Confirmer votrer mot de passe",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Le mot de passe de confirmation est requis";
                    } else if (value != _passwordController.text) {
                      return "Les deux mots de passe ne correspondent pas";
                    } else {
                      return null;
                    }
                  },
                ),
              Container(
                margin: EdgeInsets.only(top: 30, bottom: 20),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;
                            });
                            // Login
                            try {
                              if (_forLogin) {
                                await Auth().loginWithEmailAndPassword(
                                  _emailController.text,
                                  _passwordController.text,
                                );
                              } else {
                                await Auth().createUserWithEmailAndPassword(
                                  _emailController.text,
                                  _passwordController.text,
                                );
                              }
                              setState(() {
                                _isLoading = false;
                              });
                            } on FirebaseAuthException catch (e) {
                              setState(() {
                                _isLoading = false;
                              });
                              // Afficher une erreur
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("${e.message}"),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.red,
                                  showCloseIcon: true,
                                ),
                              );
                            }
                          }
                        },
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : Text(_forLogin ? "Se connecter" : "S'inscrire"),
                ),
              ),

              SizedBox(
                child: TextButton(
                  onPressed: () {
                    _emailController.text = "";
                    _passwordController.text = "";
                    _passwordConfirmController.text = "";
                    setState(() {
                      _forLogin = !_forLogin;
                    });
                  },
                  child: Text(
                    _forLogin
                        ? "Je n'ai pas de compte, s'inscrire"
                        : "J'ai déjà un compte, se connecter",
                  ),
                ),
              ),
              Divider(),

              ElevatedButton.icon(
                onPressed: () {
                  Auth().signInWithGoogle();
                },
                icon: Image.asset("assets/images/google.png", height: 30),
                label: Text("Continuez avec Google"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
