import 'package:flutter/material.dart';

/// A custom snackbar widget that shows success or error messages.
///
/// This widget provides a consistent way to show success or error messages
/// across the application. It uses a theme color background for success messages
/// and a theme color background for error messages.
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
    Duration duration = const Duration(seconds: 4),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      message,
                      semanticsLabel: message,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    splashRadius: 16,
                    tooltip: 'Close',
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: TweenAnimationBuilder<double>(
                duration: duration,
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, _) => LinearProgressIndicator(
                  minHeight: 3,
                  value: value,
                  backgroundColor: Colors.white.withAlpha(64),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white.withAlpha(128),
                  ),
                ),
              ),
            ),
          ],
        ),
        backgroundColor: isSuccess ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        width: 300,
        duration: duration,
        padding: EdgeInsets.zero,
      ),
    );
  }
}
