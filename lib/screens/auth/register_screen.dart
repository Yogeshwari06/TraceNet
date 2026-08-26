import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_strings.dart';
import '../../providers/auth_provider.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

/// Register Screen
/// New user registration screen
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _bloodGroupController = TextEditingController();
  final _medicalInfoController = TextEditingController();
  final _emergencyContact1Controller = TextEditingController();
  final _emergencyContact2Controller = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bloodGroupController.dispose();
    _medicalInfoController.dispose();
    _emergencyContact1Controller.dispose();
    _emergencyContact2Controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = context.read<AuthProvider>();
    try {
      await authProvider.register(
        email: _emailController.text,
        password: _passwordController.text,
        name: _nameController.text,
        phone: _phoneController.text,
        bloodGroup: _bloodGroupController.text,
        medicalInfo: _medicalInfoController.text,
        emergencyContacts: [
          _emergencyContact1Controller.text,
          _emergencyContact2Controller.text,
        ],
      );

      if (!mounted) {
        return;
      }

      if (authProvider.isAuthenticated) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.dashboard,
          (route) => false,
        );
      }
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authProvider.errorMessage ?? 'Unable to create your account.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.registerTitle),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Create your account',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    CustomTextField(
                      label: AppStrings.name,
                      controller: _nameController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Name is required.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    PhoneNumberField(
                      label: AppStrings.phone,
                      controller: _phoneController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Phone number is required.';
                        }
                        final phoneRegex = RegExp(r'^[+]?[(\d\s)-]{7,15}$');
                        if (!phoneRegex.hasMatch(value.trim())) {
                          return 'Enter a valid phone number.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    EmailField(
                      label: AppStrings.email,
                      controller: _emailController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Email is required.';
                        }
                        final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                        if (!emailRegex.hasMatch(value.trim())) {
                          return 'Enter a valid email address.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    PasswordField(
                      label: AppStrings.password,
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Password is required.';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: AppStrings.bloodGroup,
                      controller: _bloodGroupController,
                      hint: 'Optional',
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: AppStrings.medicalInfo,
                      controller: _medicalInfoController,
                      hint: 'Optional',
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    PhoneNumberField(
                      label: 'Emergency Contact 1',
                      controller: _emergencyContact1Controller,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Emergency Contact 1 is required.';
                        }
                        final phoneRegex = RegExp(r'^[+]?[(\d\s)-]{7,15}$');
                        if (!phoneRegex.hasMatch(value.trim())) {
                          return 'Enter a valid emergency contact.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    PhoneNumberField(
                      label: 'Emergency Contact 2',
                      controller: _emergencyContact2Controller,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Emergency Contact 2 is required.';
                        }
                        final phoneRegex = RegExp(r'^[+]?[(\d\s)-]{7,15}$');
                        if (!phoneRegex.hasMatch(value.trim())) {
                          return 'Enter a valid emergency contact.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      label: AppStrings.register,
                      onPressed: _submit,
                      isLoading: authProvider.isLoading,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
