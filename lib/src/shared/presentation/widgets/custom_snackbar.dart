import 'package:flutter/material.dart';

/// A custom snackbar widget that shows success or error messages.
///
/// This widget provides a consistent way to show success or error messages
/// across the application. It uses a green background for success messages
/// and a red background for error messages.
class CustomSnackbar {
  /// Shows a snackbar with the appropriate styling based on the success state.
  ///
  /// [context] - The build context where the snackbar will be shown
  /// [isSuccess] - Whether this is a success message (true) or error message (false)
  /// [message] - The message to show in the snackbar
  static void show({
    required BuildContext context,
    required bool isSuccess,
    required String message,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            message,
            semanticsLabel: message,
          ),
        ),
        backgroundColor: isSuccess ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        width: 260,
      ),
    );
  }
}
