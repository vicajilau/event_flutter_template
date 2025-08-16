import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/core.dart';

/// Widget reutilizable para mostrar iconos sociales SVG con enlace
class SocialIconSvg extends StatelessWidget {
  /// Ruta del archivo SVG
  final String svgPath;

  /// URL a la que apunta el icono
  final String url;

  /// Color del icono y fondo
  final Color color;

  /// Texto del tooltip
  final String tooltip;

  /// Si debe aplicar tint al SVG (cambiar su color)
  final bool tint;

  /// Tamaño del icono (por defecto 18)
  final double iconSize;

  /// Padding interno del container (por defecto 8)
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

/// Widget para mostrar una lista de iconos sociales
class SocialIconsRow extends StatelessWidget {
  /// Información social del objeto (Map con claves como 'twitter', 'linkedin', etc.)
  final dynamic social;

  /// Espaciado horizontal entre iconos (por defecto 4)
  final double spacing;

  /// Tamaño de los iconos (por defecto 18)
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

    // Twitter/X usando SVG
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

    // LinkedIn usando SVG
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

    // GitHub usando SVG
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

    // Website usando SVG
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
