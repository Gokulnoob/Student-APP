import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../blocs/auth_bloc/auth_bloc.dart';
import '../blocs/auth_bloc/auth_event.dart';
import '../blocs/auth_bloc/auth_state.dart';
import '../widgets/theme.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Lottie Logo
                Lottie.network(
                  'https://assets8.lottiefiles.com/packages/lf20_jcikwtux.json',
                  height: 180,
                  repeat: true,
                ),
                SizedBox(height: 10),

                // Login Text
                Text(
                  "Welcome Back!",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: 5),

                Text(
                  "Login to continue",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: 30),

                // Email Field
                _buildTextField(
                    context, emailController, "Email", Icons.email, false),
                SizedBox(height: 20),

                // Password Field
                _buildTextField(
                    context, passwordController, "Password", Icons.lock, true),
                SizedBox(height: 25),

                // Login Button with Bloc
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    } else if (state is Authenticated) {
                      Navigator.pushReplacementNamed(context, '/home');
                    }
                  },
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return CircularProgressIndicator();
                    }

                    return ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<AuthBloc>(context).add(AuthLogin(
                          email: emailController.text,
                          password: passwordController.text,
                        ));
                      },
                      child: Text(
                        "Login",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.white),
                      ),
                    );
                  },
                ),

                SizedBox(height: 15),

                // Sign Up Navigation
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/signup'),
                  child: Text(
                    "Don't have an account? Sign up",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppTheme.buttonColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Reusable TextField Widget
  Widget _buildTextField(BuildContext context, TextEditingController controller,
      String label, IconData icon, bool isPassword) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppTheme.buttonColor),
        labelText: label,
        labelStyle: TextStyle(color: AppTheme.buttonColor),
        filled: true,
        fillColor: AppTheme.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppTheme.buttonColor, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[400]!),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
