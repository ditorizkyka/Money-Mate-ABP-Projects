import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:frontend/app/widget/authfield.dart';
import 'package:frontend/app/widget/buttonApp.dart';
import 'package:frontend/constant/constant.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/signin_controller.dart';

class SigninView extends GetView<SigninController> {
  const SigninView({super.key});
  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    // Get.lazyPut(() => SigninController());

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: Row(
        children: [
          // Left side with blue background
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.black,
                      ColorApp.mainColor,
                      const Color.fromARGB(255, 107, 153, 238),
                    ],
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 70,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          "assets/images/lastlogo-bg.png",
                          width: 40,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          "Welcome to Money Mate",
                          style: TextStyle(
                            fontSize: 17,
                            // fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Track your expenses and manage your finances effortlessly.",
                          textAlign: TextAlign.left,
                          style: GoogleFonts.poppins(
                            fontSize: 55,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Money Mate is an application used for recording daily expenses to help users track their spending statistics and identify areas for improvement in their day-to-day purchases.",
                          textAlign: TextAlign.left,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // User testimonials section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _buildUserAvatar(
                              name: "Andito R.",
                              imageUrl: "assets/images/user1.png",
                            ),
                            _buildUserAvatar(
                              name: "Hilal A.",
                              imageUrl: "assets/images/user2.png",
                            ),
                            _buildUserAvatar(
                              name: "Naila A.",
                              imageUrl: "assets/images/user3.png",
                            ),
                            _buildUserAvatar(
                              name: "Widya H.",
                              imageUrl: "assets/images/user4.png",
                            ),
                            _buildUserAvatar(
                              name: "Fariz R.",
                              imageUrl: "assets/images/user4.png",
                            ),
                            _buildUserAvatar(
                              name: "Imam W.",
                              imageUrl: "assets/images/user4.png",
                            ),
                          ],
                        ),
                        // User avatars grid
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            flex: 1,
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 600),

                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical:
                        24, // bisa ditambahkan agar isi tidak terlalu mepet atas-bawah
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white, // background putih
                    borderRadius: BorderRadius.circular(16), // sudut melengkung
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12,
                        offset: Offset(0, 4), // efek bayangan lembut
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("assets/images/lastlogo-bg.png", width: 50),
                      Gap.h12,
                      Text(
                        'Hello Momates!',
                        style: TypographyApp.headline1.copyWith(fontSize: 28),
                      ),
                      Gap.h4,
                      Text(
                        'Sign In to your account',
                        style: TypographyApp.text1.copyWith(fontSize: 14),
                      ),
                      Gap.h32,
                      AuthTextField(
                        title: "Masukan Email Anda",
                        controller: emailController,
                      ),
                      Gap.h12,
                      AuthTextField(
                        title: "Password",
                        controller: passwordController,
                        isObsecure: true,
                      ),
                      Gap.h12,
                      ButtonApp(
                        action: "Sign In",
                        onTap: () {
                          controller.signin(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          );
                        },
                      ),
                      Gap.h8,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account?',
                            style: TextStyle(fontSize: 14),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.toNamed('/signup');
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                            ),
                            child: Text(
                              'Sign up',
                              style: TypographyApp.text1.copyWith(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserAvatar({required String name, required String imageUrl}) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white.withOpacity(0.2),
            // For placeholder with initials if image doesn't exist
            child: ClipOval(
              child: Image.asset(
                imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to initials if image doesn't exist
                  return Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.3),
                          Colors.white.withOpacity(0.1),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _getInitials(name),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          name,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // Helper method to get initials from name
  String _getInitials(String name) {
    List<String> nameParts = name.split(' ');
    if (nameParts.length >= 2) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    } else if (nameParts.isNotEmpty) {
      return nameParts[0][0].toUpperCase();
    }
    return 'U';
  }

  // Custom compact auth field
}
