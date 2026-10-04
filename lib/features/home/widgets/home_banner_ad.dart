import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../core/services/ad_service.dart';
import 'home_reveal.dart';

/// Inline banner styled as a glass card. Takes no space until an ad loads.
class HomeBannerAd extends StatefulWidget {
  /// Distinguishes banner slots so each one keeps its own entrance animation.
  final String slot;

  const HomeBannerAd({super.key, required this.slot});

  @override
  State<HomeBannerAd> createState() => _HomeBannerAdState();
}

class _HomeBannerAdState extends State<HomeBannerAd> {
  BannerAd? _ad;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _ad = BannerAd(
      adUnitId: AdService.bannerUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (mounted) setState(() => _loaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _ad = null;
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded || _ad == null) return const SizedBox.shrink();

    return HomeReveal(
      revealKey: 'banner_${widget.slot}',
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 28, 16, 0),
        padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.8),
            width: 3,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'বিজ্ঞাপন',
              style: TextStyle(
                fontSize: 11,
                letterSpacing: 0.5,
                color: Colors.brown.shade300,
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: _ad!.size.width.toDouble(),
              height: _ad!.size.height.toDouble(),
              child: AdWidget(ad: _ad!),
            ),
          ],
        ),
      ),
    );
  }
}
