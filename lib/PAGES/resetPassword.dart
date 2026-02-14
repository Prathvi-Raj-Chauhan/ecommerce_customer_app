import 'package:dio/dio.dart';
import 'package:ecommerce_customer/SERVICES/dioclient.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;
  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<bool> _resetPassword() async {
    try {
      final response = await Dioclient.dio.post(
        '/reset-pass',
        data: {
          'oldPassword': _currentPasswordController.text,
          'newPassword': _newPasswordController.text,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      if(response.statusCode == 401){
        _showErrorDialog('Entered wrong old password');
      }
      return false;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Current password is incorrect');
      } else if (e.response?.statusCode == 400) {
        throw Exception('Invalid password format');
      }
      throw Exception('Failed to reset password: ${e.message}');
    } catch (e) {
      debugPrint('RESET PASSWORD ERROR: $e');
      throw Exception('An error occurred');
    }
  }

  void _handleResetPassword() async {
    // Validate current password
    if (_currentPasswordController.text.isEmpty) {
      _showErrorDialog('Please enter your current password');
      return;
    }

    // Validate new password
    if (_newPasswordController.text.isEmpty) {
      _showErrorDialog('Please enter a new password');
      return;
    }

    if (_newPasswordController.text.length < 6) {
      _showErrorDialog('New password must be at least 6 characters');
      return;
    }

    // Validate confirm password
    if (_confirmPasswordController.text.isEmpty) {
      _showErrorDialog('Please confirm your new password');
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      _showErrorDialog('Passwords do not match');
      return;
    }

    // Check if new password is same as current
    if (_currentPasswordController.text == _newPasswordController.text) {
      _showErrorDialog('New password must be different from current password');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final success = await _resetPassword();

      if (!mounted) return;

      setState(() => _isLoading = false);

      if (success) {
        _showSuccessDialog();
      }
    } catch (e) {
      if (!mounted) return;

      setState(() => _isLoading = false);

      _showErrorDialog(e.toString().replaceAll('Exception: ', ''));
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          'Error',
          style: GoogleFonts.nunito(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          message,
          style: GoogleFonts.nunito(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              'OK',
              style: GoogleFonts.nunito(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        icon: Icon(Icons.check_circle, color: Colors.green, size: 64),
        title: Text(
          'Success!',
          style: GoogleFonts.nunito(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        content: Text(
          'Your password has been reset successfully',
          textAlign: TextAlign.center,
          style: GoogleFonts.nunito(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 16,
          ),
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.pop(); // Close dialog
                context.go('/');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Go to Home',
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reset Password',
          style: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),

            // Instructions
            Text(
              'Choose a new password',
              style: GoogleFonts.nunito(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Please enter your current password and choose a new password for your account.',
              style: GoogleFonts.nunito(
                fontSize: 14,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),

            const SizedBox(height: 32),

            // Current Password Field
            Text(
              'Current Password',
              style: GoogleFonts.nunito(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _currentPasswordController,
              obscureText: !_showCurrentPassword,
              style: GoogleFonts.nunito(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                hintText: 'Enter current password',
                hintStyle: GoogleFonts.nunito(
                  color: Theme.of(context).colorScheme.secondary,
                ),
                prefixIcon: Icon(
                  Icons.lock_outline,
                  size: 22,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _showCurrentPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    size: 22,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  onPressed: () {
                    setState(() {
                      _showCurrentPassword = !_showCurrentPassword;
                    });
                  },
                ),
                filled: true,
                fillColor: isDark
                    ? Theme.of(context).colorScheme.surface
                    : Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // New Password Field
            Text(
              'New Password',
              style: GoogleFonts.nunito(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _newPasswordController,
              obscureText: !_showNewPassword,
              style: GoogleFonts.nunito(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                hintText: 'Enter new password',
                hintStyle: GoogleFonts.nunito(
                  color: Theme.of(context).colorScheme.secondary,
                ),
                prefixIcon: Icon(
                  Icons.lock,
                  size: 22,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _showNewPassword ? Icons.visibility_off : Icons.visibility,
                    size: 22,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  onPressed: () {
                    setState(() {
                      _showNewPassword = !_showNewPassword;
                    });
                  },
                ),
                filled: true,
                fillColor: isDark
                    ? Theme.of(context).colorScheme.surface
                    : Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Password Requirements
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark
                    ? Theme.of(context).colorScheme.surface
                    : Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: isDark
                    ? Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.3),
                      )
                    : null,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 18,
                    color: isDark
                        ? Theme.of(context).colorScheme.primary
                        : Colors.blue.shade700,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Password must be at least 6 characters',
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        color: isDark
                            ? Theme.of(context).colorScheme.onSurface
                            : Colors.blue.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Confirm Password Field
            Text(
              'Confirm New Password',
              style: GoogleFonts.nunito(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _confirmPasswordController,
              obscureText: !_showConfirmPassword,
              style: GoogleFonts.nunito(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                hintText: 'Re-enter new password',
                hintStyle: GoogleFonts.nunito(
                  color: Theme.of(context).colorScheme.secondary,
                ),
                prefixIcon: Icon(
                  Icons.lock,
                  size: 22,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _showConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    size: 22,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  onPressed: () {
                    setState(() {
                      _showConfirmPassword = !_showConfirmPassword;
                    });
                  },
                ),
                filled: true,
                fillColor: isDark
                    ? Theme.of(context).colorScheme.surface
                    : Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Reset Password Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleResetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      )
                    : Text(
                        'Reset Password',
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 16),

            // Cancel Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: _isLoading ? null : () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
