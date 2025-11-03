import 'package:avatar_ai/core/routes/app_routes.dart';
import 'package:avatar_ai/core/utils/utils.dart';
import 'package:avatar_ai/features/auth/model/user_model.dart';
import 'package:avatar_ai/features/auth/viewmodel/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen>
    with SingleTickerProviderStateMixin {
  bool isSignIn = true;
  late TabController _tabController;
  final _signInEmailController = TextEditingController();
  final _signInPasswordController = TextEditingController();
  final _signUpNameController = TextEditingController();
  final _signUpEmailController = TextEditingController();
  final _signUpPasswordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _signInEmailController.dispose();
    _signInPasswordController.dispose();
    _signUpNameController.dispose();
    _signUpEmailController.dispose();
    _signUpPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authViewModelProvider, (prev, next) {
      next.when(
        data: (UserModel? data) {
          context.pushReplacementNamed(AppRoutes.mainScreen);
          showSnackBar(
            message: 'Welcome back ${data?.email}',
            context: context,
            type: SnackBarType.success,
          );
        },
        error: (Object error, StackTrace stack) {
          showSnackBar(
            message: error.toString(),
            context: context,
            type: SnackBarType.failure,
          );
        },
        loading: () {},
      );
    });

    final bool isLoading = ref.watch(authViewModelProvider).isLoading;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0A0A0A),
              const Color(0xFF1A1A2E),
              const Color(0xFF16213E),
            ],
          ),
        ),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF6C63FF),
                                const Color(0xFF00D9FF),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF6C63FF).withOpacity(0.3),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.chat_bubble_outline_rounded,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 30),
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [
                              const Color(0xFF6C63FF),
                              const Color(0xFF00D9FF),
                            ],
                          ).createShader(bounds),
                          child: const Text(
                            'Avatar AI',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Chat with intelligent characters\n or create your own characters.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[400],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        Container(
                          constraints: const BoxConstraints(maxWidth: 450),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1A1A).withOpacity(0.6),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0A0A0A),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: TabBar(
                                  controller: _tabController,
                                  indicator: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        const Color(0xFF6C63FF),
                                        const Color(0xFF00D9FF),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  dividerColor: Colors.transparent,
                                  labelColor: Colors.white,
                                  unselectedLabelColor: Colors.grey[500],
                                  labelStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  tabs: const [
                                    Tab(text: 'Sign In'),
                                    Tab(text: 'Sign Up'),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                child: TabBarView(
                                  controller: _tabController,
                                  children: [
                                    _buildSignInForm(),
                                    _buildSignUpForm(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Or continue with',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildSocialButton(Icons.g_mobiledata, 'Google'),
                            const SizedBox(width: 16),
                            _buildSocialButton(Icons.apple, 'Apple'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildSignInForm() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 10),
          _buildTextField(
            controller: _signInEmailController,
            label: 'Email',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _signInPasswordController,
            label: 'Password',
            icon: Icons.lock_outline,
            isPassword: true,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => context.pushNamed(AppRoutes.forgotPass),
              child: const Text(
                'Forgot Password?',
                style: TextStyle(color: Color(0xFF6C63FF)),
              ),
            ),
          ),
          const SizedBox(height: 8),
          _buildGradientButton('Sign In', () {
            if (_signInEmailController.text.trim().isEmpty) {
              showSnackBar(
                message: "Email is required",
                context: context,
                type: SnackBarType.info,
              );
              return;
            }
            ref
                .read(authViewModelProvider.notifier)
                .signInViaEmailAndPass(
                  email: _signInEmailController.text.trim(),
                  password: _signInPasswordController.text.trim(),
                );
          }),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSignUpForm() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 10),
          _buildTextField(
            controller: _signUpNameController,
            label: 'Full Name',
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _signUpEmailController,
            label: 'Email',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _signUpPasswordController,
            label: 'Password',
            icon: Icons.lock_outline,
            isPassword: true,
          ),
          const SizedBox(height: 24),
          _buildGradientButton(
            'Sign Up',
            () => ref
                .read(authViewModelProvider.notifier)
                .signUpViaEmailAndPass(
                  name: _signUpNameController.text.trim(),
                  email: _signUpEmailController.text.trim(),
                  password: _signUpPasswordController.text.trim(),
                ),
          ),
          const SizedBox(height: 16),
          Text(
            'By signing up, you agree to our Terms & Privacy Policy',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0A).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword && _obscurePassword,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[500]),
          prefixIcon: Icon(icon, color: const Color(0xFF6C63FF)),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey[500],
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildGradientButton(String text, VoidCallback ontap) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF00D9FF)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: ontap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, String label) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A).withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: IconButton(
        icon: Icon(icon, size: 30, color: Colors.white),
        onPressed: () async {
          await ref.read(authViewModelProvider.notifier).signUpViaGoogle();
        },
      ),
    );
  }
}
