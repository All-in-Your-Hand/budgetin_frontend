import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// A footer widget that displays social media links, terms & conditions, and about us section
class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          // Social Media Icons
          Row(
            children: [
              _SocialIcon(
                icon: FontAwesomeIcons.youtube,
                onTap: () {
                  // TODO: Add YouTube link
                },
              ),
              const SizedBox(width: 8),
              _SocialIcon(
                icon: FontAwesomeIcons.xTwitter,
                onTap: () {
                  // TODO: Add Twitter link
                },
              ),
              const SizedBox(width: 8),
              _SocialIcon(
                icon: FontAwesomeIcons.instagram,
                onTap: () {
                  // TODO: Add Instagram link
                },
              ),
              const SizedBox(width: 8),
              _SocialIcon(
                icon: FontAwesomeIcons.linkedin,
                onTap: () {
                  // TODO: Add LinkedIn link
                },
              ),
              const SizedBox(width: 8),
              _SocialIcon(
                icon: FontAwesomeIcons.facebook,
                onTap: () {
                  // TODO: Add Facebook link
                },
              ),
            ],
          ),

          // Terms & Conditions
          Expanded(
            child: Center(
              child: TextButton(
                onPressed: () {
                  // TODO: Navigate to Terms & Conditions
                },
                child: const Text(
                  'Terms & Conditions',
                  style: TextStyle(
                    color: Color(0xFF18242C),
                    fontSize: 16,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                    letterSpacing: -0.64,
                  ),
                ),
              ),
            ),
          ),

          // About Us Section
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'images/user-profile-group.png',
                width: 32,
                height: 32,
                color: const Color(0xFF18242C),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to About Us
                },
                child: Text(
                  'about us',
                  style: TextStyle(
                    color: const Color(0xFF18242C),
                    fontSize: 14,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                    letterSpacing: -0.56,
                    shadows: [
                      Shadow(
                        offset: const Offset(0, 4),
                        blurRadius: 4,
                        color: const Color(0xFF000000).withAlpha(64),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A reusable social media icon button
class _SocialIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SocialIcon({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: FaIcon(
          icon,
          size: 20,
          color: const Color(0xFF18242C),
        ),
        onPressed: onTap,
      ),
    );
  }
}
