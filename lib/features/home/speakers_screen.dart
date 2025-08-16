import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/data_loader.dart';

class SpeakersScreen extends StatelessWidget {
  final DataLoader dataLoader;
  const SpeakersScreen({super.key, required this.dataLoader});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: dataLoader.loadSpeakers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Cargando ponentes...'),
              ],
            ),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red),
                SizedBox(height: 16),
                Text('Error cargando ponentes'),
              ],
            ),
          );
        }
        final speakers = snapshot.data ?? [];

        if (speakers.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No hay ponentes registrados'),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: speakers.length,
          itemBuilder: (context, index) {
            final speaker = speakers[index];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                        ),
                        child: speaker['image'] != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  speaker['image'],
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.surfaceContainerHighest,
                                      ),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 32,
                                              height: 32,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 3,
                                                value:
                                                    loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes!
                                                    : null,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Cargando...',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurfaceVariant,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    debugPrint(
                                      'Error loading image for ${speaker['name']}: $error',
                                    );
                                    return Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.person,
                                            size: 48,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSurfaceVariant,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Error al cargar imagen',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodySmall,
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Center(
                                child: Icon(
                                  Icons.person,
                                  size: 48,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      speaker['name'] ?? '',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      speaker['bio'] ?? '',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    _buildSocialLinks(context, speaker['social']),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSocialLinks(BuildContext context, dynamic social) {
    if (social == null) return const SizedBox.shrink();

    final List<Widget> socialIcons = [];

    // Twitter/X usando SVG
    if (social['twitter'] != null) {
      socialIcons.add(
        _socialIconSvg(
          context,
          'assets/X_icon.svg',
          social['twitter'],
          const Color(0xFF1DA1F2),
          true,
          'Twitter/X',
        ),
      );
    }

    // LinkedIn usando SVG
    if (social['linkedin'] != null) {
      socialIcons.add(
        _socialIconSvg(
          context,
          'assets/LinkedIn_icon.svg',
          social['linkedin'],
          const Color(0xFF0077B5),
          false,
          'LinkedIn',
        ),
      );
    }

    // GitHub usando icono material (no hay SVG disponible)
    if (social['github'] != null) {
      socialIcons.add(
        _socialIconSvg(
          context,
          'assets/GitHub_icon.svg',
          social['github'],
          const Color(0xFF333333),
          true,
          'GitHub',
        ),
      );
    }

    // Website usando icono material
    if (social['website'] != null) {
      socialIcons.add(
        _socialIconSvg(
          context,
          'assets/Website_icon.svg',
          social['website'],
          const Color(0xFF4CAF50),
          true,
          'Website',
        ),
      );
    }

    if (socialIcons.isEmpty) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: socialIcons
          .map(
            (icon) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: icon,
            ),
          )
          .toList(),
    );
  }

  Widget _socialIconSvg(
    BuildContext context,
    String svgPath,
    String url,
    Color color,
    bool tint,
    String tooltip,
  ) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: () => _launchURL(url),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: (tint)
              ? SvgPicture.asset(
                  svgPath,
                  width: 18,
                  height: 18,
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                )
              : SvgPicture.asset(svgPath, width: 18, height: 18),
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    try {
      // Asegurar que la URL tenga el protocolo correcto
      String formattedUrl = url;
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        formattedUrl = 'https://$url';
      }

      final uri = Uri.parse(formattedUrl);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('No se pudo abrir la URL: $formattedUrl');
      }
    } catch (e) {
      debugPrint('Error al abrir URL: $e');
    }
  }
}
