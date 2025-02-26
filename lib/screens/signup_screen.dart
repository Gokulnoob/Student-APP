import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:student_event_management/blocs/auth_bloc/auth_bloc.dart';
import 'package:student_event_management/blocs/auth_bloc/auth_event.dart';
import 'package:student_event_management/blocs/auth_bloc/auth_state.dart';
import 'package:student_event_management/widgets/theme.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Lottie animation at the top
              Lottie.network(
                'https://assets5.lottiefiles.com/packages/lf20_jcikwtux.json',
                height: 180,
                repeat: true,
              ),
              SizedBox(height: 20),

              // Sign Up Title
              Text(
                "Create Account",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 10),
              Text(
                "Sign up to continue",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 30),

              // Email Field
              _buildTextField(context, emailController, "Email",
                  Icons.email_outlined, false),
              SizedBox(height: 16),

              // Password Field
              _buildTextField(context, passwordController, "Password",
                  Icons.lock_outline, true),
              SizedBox(height: 30),

              // Sign Up Button
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
                    return Center(child: CircularProgressIndicator());
                  }
                  return SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<AuthBloc>(context).add(AuthSignUp(
                          email: emailController.text,
                          password: passwordController.text,
                        ));
                      },
                      child: Text(
                        'Sign Up',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),

              // Already have an account? Login
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/login'),
                child: Text(
                  "Already have an account? Login",
                  textAlign: TextAlign.center,
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
        labelStyle: TextStyle(color: AppTheme.grey),
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
          borderSide: BorderSide(color: AppTheme.grey.withOpacity(0.4)),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
