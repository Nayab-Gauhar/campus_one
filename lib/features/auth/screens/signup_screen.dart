import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:campus_one/services/auth_service.dart';
import 'package:campus_one/core/theme/app_theme.dart';
import 'package:campus_one/widgets/animations/animated_widgets.dart';
import 'package:campus_one/features/dashboard/screens/home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _deptController = TextEditingController();
  bool _isLoading = false;
  bool _agreeToTerms = false;

  Future<void> _handleSignup() async {
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to the Terms and Privacy Policy')),
      );
      return;
    }

    setState(() => _isLoading = true);
    final success = await context.read<AuthService>().register(
      _nameController.text,
      _emailController.text,
      _passwordController.text,
      _deptController.text,
    );
    setState(() => _isLoading = false);
    
    if (success && mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    } else if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration failed. Please use student@haldia.edu')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Dark Header Background
          Container(
            height: 280,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  // Header Content
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FadeSlideEntrance(
                        child: Text(
                          'Registration in to your\nAccount',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      FadeSlideEntrance(
                        delay: const Duration(milliseconds: 200),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            'Effortlessly register, access your account, and enjoy seamless convenience!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // White Card
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Full Name'),
                        _buildTextField(_nameController, Icons.person_outline_rounded, 'Full Name'),
                        
                        const SizedBox(height: 20),
                        _buildLabel('Email Address'),
                        _buildTextField(_emailController, Icons.alternate_email_rounded, 'Email'),
                        
                        const SizedBox(height: 20),
                        _buildLabel('Password'),
                        _buildTextField(_passwordController, Icons.lock_outline_rounded, 'Password', isPassword: true),
                        
                        const SizedBox(height: 20),
                        _buildLabel('Department / Year'),
                        _buildTextField(_deptController, Icons.school_outlined, 'Department (e.g. CSE-4)'),
                        
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Checkbox(
                                value: _agreeToTerms,
                                onChanged: (v) => setState(() => _agreeToTerms = v ?? false),
                                activeColor: AppTheme.accentColor,
                                checkColor: AppTheme.primaryColor,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text.rich(
                                TextSpan(
                                  text: 'I agree to ',
                                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w500),
                                  children: [
                                    TextSpan(
                                      text: 'Terms ',
                                      style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.w900),
                                    ),
                                    const TextSpan(text: 'and '),
                                    TextSpan(
                                      text: 'Privacy Policy.',
                                      style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.w900),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 40),
                        _AuthPrimaryButton(
                          label: 'Registration',
                          isLoading: _isLoading,
                          onTap: _handleSignup,
                        ),
                        
                        const SizedBox(height: 24),
                        Center(
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Text.rich(
                              TextSpan(
                                text: 'Already have an account? ',
                                style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w500),
                                children: [
                                  TextSpan(
                                    text: 'Sign In',
                                    style: TextStyle(color: AppTheme.accentColor.withBlue(100), fontWeight: FontWeight.w900),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        label,
        style: TextStyle(
          color: AppTheme.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, IconData icon, String hint, {bool isPassword = false}) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.05)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.primaryColor.withValues(alpha: 0.4)),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: isPassword,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppTheme.textPrimary),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(color: AppTheme.textSecondary.withValues(alpha: 0.4), fontSize: 14, fontWeight: FontWeight.w500),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          if (isPassword)
             Icon(Icons.visibility_off_outlined, size: 18, color: AppTheme.primaryColor.withValues(alpha: 0.4)),
        ],
      ),
    );
  }
}

class _AuthPrimaryButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback onTap;

  const _AuthPrimaryButton({
    required this.label,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleOnTap(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: AppTheme.accentColor,
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: AppTheme.accentColor.withValues(alpha: 0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: isLoading 
              ? const CupertinoActivityIndicator(color: AppTheme.primaryColor)
              : Text(
                  label,
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    letterSpacing: 0.5,
                  ),
                ),
        ),
      ),
    );
  }
}
