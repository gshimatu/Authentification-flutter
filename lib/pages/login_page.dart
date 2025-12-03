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
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      // On utilise un Stack pour mettre une décoration en arrière-plan
      body: Stack(
        children: [
          // DÉCORATION D'ARRIÈRE-PLAN
          Container(
            height: double.infinity,
            width: double.infinity,
            color: theme.scaffoldBackgroundColor,
          ),
          // Forme colorée en haut
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 300,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    primaryColor.withOpacity(0.8),
                    primaryColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
            ),
          ),

          // CONTENU PRINCIPAL
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: Column(
                  children: [
                    // Carte flottante
                    Card(
                      elevation: 10,
                      shadowColor: Colors.black26,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 40,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              // Logo et Titre centrés
                              Center(
                                child: Image.asset(
                                  'assets/images/Gs.png',
                                  height: 56, 
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                _forLogin ? "Bon retour !" : "Rejoignez-nous",
                                textAlign: TextAlign.center,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _forLogin
                                    ? "Connectez-vous pour continuer"
                                    : "Créez votre compte en quelques secondes",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),

                              const SizedBox(height: 32),

                              // Email
                              _buildModernTextField(
                                controller: _emailController,
                                label: 'Email',
                                icon: Icons.email_rounded,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez entrer votre email';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 16),

                              // Password
                              _buildModernTextField(
                                controller: _passwordController,
                                label: 'Mot de passe',
                                icon: Icons.lock_rounded,
                                obscureText: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez entrer votre mot de passe';
                                  }
                                  return null;
                                },
                              ),

                              // Confirm Password (si inscription)
                              if (!_forLogin) ...[
                                const SizedBox(height: 16),
                                _buildModernTextField(
                                  controller: _passwordConfirmController,
                                  label: 'Confirmer le mot de passe',
                                  icon: Icons.lock_outline_rounded,
                                  obscureText: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Le mot de passe de confirmation est requis';
                                    } else if (value !=
                                        _passwordController.text) {
                                      return 'Les deux mots de passe ne correspondent pas';
                                    }
                                    return null;
                                  },
                                ),
                              ],

                              const SizedBox(height: 32),

                              // Primary action Button
                              SizedBox(
                                height: 56, // Bouton plus haut
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 4,
                                    backgroundColor: primaryColor,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    textStyle: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed:
                                      _isLoading
                                          ? null
                                          : () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              setState(() {
                                                _isLoading = true;
                                              });
                                              // Login Logic preserved
                                              try {
                                                if (_forLogin) {
                                                  await Auth()
                                                      .loginWithEmailAndPassword(
                                                        _emailController.text,
                                                        _passwordController
                                                            .text,
                                                      );
                                                } else {
                                                  await Auth()
                                                      .createUserWithEmailAndPassword(
                                                        _emailController.text,
                                                        _passwordController
                                                            .text,
                                                      );
                                                }
                                                setState(() {
                                                  _isLoading = false;
                                                });
                                              } on FirebaseAuthException catch (e) {
                                                setState(() {
                                                  _isLoading = false;
                                                });
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      '${e.message}',
                                                    ),
                                                    behavior:
                                                        SnackBarBehavior.floating,
                                                    backgroundColor: Colors.red,
                                                    showCloseIcon: true,
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                  child:
                                      _isLoading
                                          ? const SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.5,
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                    Colors.white,
                                                  ),
                                            ),
                                          )
                                          : Text(
                                            _forLogin
                                                ? 'Se connecter'
                                                : "S'inscrire",
                                          ),
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Switch Login/Register
                              TextButton(
                                onPressed: () {
                                  _emailController.text = '';
                                  _passwordController.text = '';
                                  _passwordConfirmController.text = '';
                                  setState(() {
                                    _forLogin = !_forLogin;
                                  });
                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 15,
                                    ),
                                    children: [
                                      TextSpan(
                                        text:
                                            _forLogin
                                                ? "Pas encore de compte ? "
                                                : "Déjà membre ? ",
                                      ),
                                      TextSpan(
                                        text:
                                            _forLogin
                                                ? "Créer un compte"
                                                : "Se connecter",
                                        style: TextStyle(
                                          color: primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Divider OU
                              Row(
                                children: [
                                  Expanded(
                                    child: Divider(color: Colors.grey[300]),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                    ),
                                    child: Text(
                                      'OU',
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(color: Colors.grey[300]),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 24),

                              // Google Button
                              SizedBox(
                                height: 56,
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    side: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                    backgroundColor: Colors.white,
                                    elevation: 0,
                                  ),
                                  onPressed: () {
                                    Auth().signInWithGoogle();
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/google.png',
                                        height: 24,
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        'Continuer avec Google',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget utilitaire pour éviter la répétition du style des champs
  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 22, color: Colors.grey[600]),
        filled: true,
        fillColor: Colors.grey[50], // Gris très clair pour le fond du champ
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none, // Pas de bordure par défaut
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
      ),
    );
  }
}