import 'package:elogix_fullfillment_app/modules/auth/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final LoginController controller;
  final AuthController authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();

    controller = LoginController();
    controller.addListener(_refresh);
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    controller.removeListener(_refresh);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final bool isTablet = width >= 600;

    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? width * 0.18 : width * 0.06,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ------------------------------------------------
                    // eLogix Logo
                    // ------------------------------------------------
                    Center(
                      child: Image.asset(
                        'assets/images/elogix.png',
                        width: isTablet ? width * 0.42 : width * 0.58,
                        fit: BoxFit.contain,
                      ),
                    ),

                    SizedBox(height: height * 0.055),

                    // ------------------------------------------------
                    // Welcome
                    // ------------------------------------------------
                    const Text(
                      'Welcome Back',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      'Access your fulfillment dashboard',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),

                    SizedBox(height: height * 0.035),

                    // ------------------------------------------------
                    // Email / Username
                    // ------------------------------------------------
                    _buildInputField(
                      controller: controller.usernameController,
                      hintText: 'Email / Username',
                      prefixIcon: Icons.person_outline,
                    ),

                    const SizedBox(height: 12),

                    // ------------------------------------------------
                    // Password
                    // ------------------------------------------------
                    _buildInputField(
                      controller: controller.passwordController,
                      hintText: 'Password',
                      prefixIcon: Icons.lock_outline,
                      obscureText: controller.obscurePassword,
                      suffixIcon: IconButton(
                        onPressed: controller.togglePasswordVisibility,
                        icon: Icon(
                          controller.obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.white70,
                          size: 20,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // ------------------------------------------------
                    // Remember Me + Forgot Password
                    // ------------------------------------------------
                    Row(
                      children: [
                        SizedBox(
                          width: 22,
                          height: 22,
                          child: Checkbox(
                            value: controller.rememberMe,
                            onChanged: (value) {
                              controller.toggleRememberMe(value ?? false);
                            },
                            activeColor: const Color(0xFFFF7800),
                            checkColor: Colors.black,
                            side: const BorderSide(
                              color: Colors.white70,
                              width: 1.5,
                            ),
                          ),
                        ),

                        const SizedBox(width: 6),

                        const Text(
                          'Remember me',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),

                        const Spacer(),

                        TextButton(
                          onPressed: () {
                            // Forgot password
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'Forgot password?',
                            style: TextStyle(
                              color: Color(0xFFFF7800),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: height * 0.035),

                    // ------------------------------------------------
                    // Login Button
                    // ------------------------------------------------
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed:
                              authController.isLoading.value
                                  ? null
                                  : () {
                                    authController.login(
                                      username:
                                          controller.usernameController.text,
                                      password:
                                          controller.passwordController.text,
                                    );
                                  },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF7800),
                            foregroundColor: Colors.black,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9),
                            ),
                          ),
                          child:
                              authController.isLoading.value
                                  ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.black,
                                    ),
                                  )
                                  : const Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                        ),
                      ),
                    ),

                    SizedBox(height: height * 0.035),

                    // ------------------------------------------------
                    // Contact Us
                    // ------------------------------------------------
                    Center(
                      child: RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: "Don't have an account?  ",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            TextSpan(
                              text: 'Contact us',
                              style: TextStyle(
                                color: Color(0xFFFF7800),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: height * 0.025),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------
  // Input Field
  // ------------------------------------------------

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white, fontSize: 13),
      cursorColor: const Color(0xFFFF7800),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white54, fontSize: 13),
        prefixIcon: Icon(prefixIcon, color: Colors.white70, size: 21),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFF101417),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: const BorderSide(color: Color(0xFF292D30), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: const BorderSide(color: Color(0xFFFF7800), width: 1),
        ),
      ),
    );
  }
}
