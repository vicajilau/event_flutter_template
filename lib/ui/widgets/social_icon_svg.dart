import 'package:event_flutter_template/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Reusable widget for displaying social media SVG icons with links
/// Supports customizable colors, sizes, and tooltips
class SocialIconSvg extends StatelessWidget {
  /// Path to the SVG asset file
  final String svgPath;

  /// URL that the icon links to
  final String url;

  /// Color for the icon and background styling
  final Color color;

  /// Tooltip text displayed on hover
  final String tooltip;

  /// Whether to apply color tinting to the SVG
  final bool tint;

  /// Size of the icon in logical pixels (default: 18)
  final double iconSize;

  /// Internal padding of the container (default: 8)
  final double padding;
  const SocialIconSvg({
    super.key,
    required this.svgPath,
    required this.url,
    required this.color,
    required this.tooltip,
    this.tint = false,
    this.iconSize = 18,
    this.padding = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: () => context.openUrl(url),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: tint
              ? SvgPicture.asset(
                  svgPath,
                  width: iconSize,
                  height: iconSize,
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                )
              : SvgPicture.asset(svgPath, width: iconSize, height: iconSize),
        ),
      ),
    );
  }
}

/// Widget for displaying a row of social media icons
/// Automatically generates icons based on available social media data
class SocialIconsRow extends StatelessWidget {
  /// Social media information object (Map with keys like 'twitter', 'linkedin', etc.)
  final dynamic social;

  /// Horizontal spacing between icons (default: 4)
  final double spacing;

  /// Size of the icons in logical pixels (default: 18)
  final double iconSize;
  const SocialIconsRow({
    super.key,
    required this.social,
    this.spacing = 4,
    this.iconSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    if (social == null) return const SizedBox.shrink();

    final List<Widget> socialIcons = [];

    // Twitter/X using SVG
    if (social['twitter'] != null) {
      socialIcons.add(
        SocialIconSvg(
          svgPath: 'assets/X_icon.svg',
          url: social['twitter'],
          color: const Color(0xFF1DA1F2),
          tooltip: 'Twitter/X',
          tint: true,
          iconSize: iconSize,
        ),
      );
    }

    // LinkedIn using SVG
    if (social['linkedin'] != null) {
      socialIcons.add(
        SocialIconSvg(
          svgPath: 'assets/LinkedIn_icon.svg',
          url: social['linkedin'],
          color: const Color(0xFF0077B5),
          tooltip: 'LinkedIn',
          iconSize: iconSize,
        ),
      );
    }

    // GitHub using SVG
    if (social['github'] != null) {
      socialIcons.add(
        SocialIconSvg(
          svgPath: 'assets/GitHub_icon.svg',
          url: social['github'],
          color: const Color(0xFF333333),
          tooltip: 'GitHub',
          tint: true,
          iconSize: iconSize,
        ),
      );
    }

    // Website using SVG
    if (social['website'] != null) {
      socialIcons.add(
        SocialIconSvg(
          svgPath: 'assets/Website_icon.svg',
          url: social['website'],
          color: const Color(0xFF4CAF50),
          tooltip: 'Website',
          tint: true,
          iconSize: iconSize,
        ),
      );
    }

    if (socialIcons.isEmpty) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: socialIcons
          .map(
            (icon) => Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing),
              child: icon,
            ),
          )
          .toList(),
    );
  }
}
