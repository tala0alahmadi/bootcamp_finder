import 'package:bootcamp_finder/model/bootcamp.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; 
class BootcampDetailsPage extends StatelessWidget {
  final Bootcamp camp;
  const BootcampDetailsPage({super.key, required this.camp});

  static const List<String> _curriculum = [
    'Introduction & Fundamentals',
    'Hands-on Projects',
    'Real-world Case Studies',
    'Final Project & Presentation',
  ];

  @override
  Widget build(BuildContext context) {
    final Color color = camp.color;

    
    final String priceText = camp.price == 0
        ? 'Free'
        : '\$${camp.price.toStringAsFixed(2)}';

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.black,
            expandedHeight: 220,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [color.withValues(alpha: 0.35), Colors.black],
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Icon(camp.icon, color: Colors.white, size: 45),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    camp.category.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    camp.name,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Quick info chips
                  Row(
                    children: [
                      _infoChip(Icons.schedule_rounded, '${camp.weeks} weeks'),
                      const SizedBox(width: 8),
                      _infoChip(Icons.signal_cellular_alt_rounded, camp.level),
                    ],
                  ),
                  const SizedBox(height: 24),

                  Text(
                    camp.desc,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: Colors.white60,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Additional info card
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1B22),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                    child: Column(
                      children: [
                        _detailRow(
                          Icons.public_rounded,
                          'Platform',
                          camp.source,
                        ),
                        Divider(
                          color: Colors.white.withValues(alpha: 0.08),
                          height: 24,
                        ),
                        _detailRow(Icons.payments_outlined, 'Price', priceText),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  const Text(
                    "What you'll learn",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 14),
                  ..._curriculum.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            color: color,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        color: Colors.black,
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
    
            onPressed: () async {
              try {
                String rawUrl = camp.url.trim();
                if (rawUrl.isEmpty) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("No URL available for this bootcamp"),
                      ),
                    );
                  }
                  return;
                }

                if (!rawUrl.startsWith('http://') &&
                    !rawUrl.startsWith('https://')) {
                  rawUrl = 'https://$rawUrl';
                }

                final uri = Uri.tryParse(rawUrl);
                if (uri != null && await canLaunchUrl(uri)) {
                  await launchUrl(
                    uri,
                    mode: LaunchMode.externalApplication,
                  );
                } else if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Couldn't open the link")),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Could not open link: $e")),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Go to website',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.07),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: Colors.white70),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 13, color: Colors.white70)),
      ],
    ),
  );

  Widget _detailRow(IconData icon, String label, String value) => Row(
    children: [
      Icon(icon, color: Colors.white54, size: 20),
      const SizedBox(width: 12),
      Text(label, style: const TextStyle(fontSize: 14, color: Colors.white54)),
      const Spacer(),
      Text(
        value,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    ],
  );
}
