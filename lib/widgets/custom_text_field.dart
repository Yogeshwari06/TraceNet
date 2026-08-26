import 'package:flutter/material.dart';
import '../constants/app_sizes.dart';

/// Custom Text Field Widget
/// Reusable input field with consistent styling
class CustomTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final int? maxLines;
  final int? minLines;
  final bool enabled;
  final TextInputAction? textInputAction;

  const CustomTextField({
    Key? key,
    required this.label,
    this.hint,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
    this.minLines,
    this.enabled = true,
    this.textInputAction,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: AppSizes.paddingSmall),
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: _isObscured,
          validator: widget.validator,
          onChanged: widget.onChanged,
          maxLines: _isObscured ? 1 : widget.maxLines,
          minLines: widget.minLines,
          enabled: widget.enabled,
          textInputAction: widget.textInputAction,
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon)
                : null,
            suffixIcon: widget.suffixIcon != null
                ? IconButton(
                    icon: Icon(widget.suffixIcon),
                    onPressed: widget.onSuffixIconPressed ??
                        (widget.obscureText
                            ? () {
                                setState(() {
                                  _isObscured = !_isObscured;
                                });
                              }
                            : null),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}

/// Phone Number Input Field
/// Specialized input for phone numbers
class PhoneNumberField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;

  const PhoneNumberField({
    Key? key,
    required this.label,
    this.controller,
    this.validator,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: label,
      controller: controller,
      keyboardType: TextInputType.phone,
      prefixIcon: Icons.phone,
      hint: '+1 (555) 123-4567',
      validator: validator,
      onChanged: onChanged,
    );
  }
}

/// Email Input Field
/// Specialized input for email addresses
class EmailField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;

  const EmailField({
    Key? key,
    required this.label,
    this.controller,
    this.validator,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: label,
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      prefixIcon: Icons.email,
      hint: 'example@email.com',
      validator: validator,
      onChanged: onChanged,
    );
  }
}

/// Password Input Field
/// Specialized input for passwords with visibility toggle
class PasswordField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;

  const PasswordField({
    Key? key,
    required this.label,
    this.controller,
    this.validator,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: label,
      controller: controller,
      obscureText: true,
      prefixIcon: Icons.lock,
      suffixIcon: Icons.visibility,
      hint: 'Enter your password',
      validator: validator,
      onChanged: onChanged,
    );
  }
}
