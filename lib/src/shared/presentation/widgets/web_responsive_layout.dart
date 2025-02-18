import 'package:flutter/material.dart';
import '../../../core/config/web_config.dart';

class WebResponsiveLayout extends StatelessWidget {
  final Widget child;
  final bool useFullWidth;

  const WebResponsiveLayout({
    super.key,
    required this.child,
    this.useFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final webConstraints = useFullWidth
            ? WebConfig.getWebConstraints(constraints).copyWith(
                maxWidth: constraints.maxWidth,
                minWidth: constraints.maxWidth,
              )
            : WebConfig.getWebConstraints(constraints);

        return Container(
          constraints: webConstraints,
          child: child,
        );
      },
    );
  }
}
