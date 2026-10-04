import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kidsacademybangla/core/config/ad_secrets.dart';

/// Central place for ads.
///
/// - Rewarded ad is opt-in only (child taps "watch for a star").
/// - A native-ad "break" card (with our own big close bar) shows at natural
///   breaks, rate limited (warm-up + cooldown). No full-screen video.
class AdService {
  AdService._();
  static final AdService instance = AdService._();

  // Real IDs live in the git-ignored lib/core/config/ad_secrets.dart.
  static const String bannerUnitId = AdSecrets.bannerUnitId;
  static const String _nativeUnitId = AdSecrets.nativeUnitId;
  static const String _rewardedUnitId = AdSecrets.rewardedUnitId;

  /// No automatic ad during the first minutes of a session.
  static const Duration warmUp = Duration(minutes: 3);

  /// Minimum gap between automatic ads.
  static const Duration cooldown = Duration(minutes: 8);

  final ValueNotifier<bool> rewardedReady = ValueNotifier(false);

  final DateTime _startedAt = DateTime.now();
  DateTime? _lastAdShownAt;
  NativeAd? _native;
  bool _breakShowing = false;
  RewardedAd? _rewarded;

  void init() {
    _loadNative();
    _loadRewarded();
  }

  // ---------------------------------------------------------------- limits

  bool get _canShowAutomaticAd {
    final now = DateTime.now();
    if (now.difference(_startedAt) < warmUp) return false;
    final last = _lastAdShownAt;
    return last == null || now.difference(last) >= cooldown;
  }

  // ---------------------------------------------------------------- native

  static const Color _accent = Color(0xFFFF7F50);

  void _loadNative() {
    NativeAd(
      adUnitId: _nativeUnitId,
      request: const AdRequest(),
      nativeAdOptions: NativeAdOptions(
        videoOptions: VideoOptions(startMuted: true),
      ),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.medium,
        mainBackgroundColor: Colors.white,
        cornerRadius: 16,
        callToActionTextStyle: NativeTemplateTextStyle(
          textColor: Colors.white,
          backgroundColor: _accent,
          style: NativeTemplateFontStyle.bold,
          size: 16,
        ),
      ),
      listener: NativeAdListener(
        onAdLoaded: (ad) => _native = ad as NativeAd,
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _native = null;
        },
      ),
    ).load();
  }

  /// Call at natural breaks (e.g. returning home). Rate limited.
  /// Shows a card with the ad and a big "close" bar that is always at the top.
  void maybeShowNativeBreak(BuildContext context) {
    final ad = _native;
    if (ad == null || _breakShowing || !_canShowAutomaticAd) return;
    _native = null;
    _breakShowing = true;
    _lastAdShownAt = DateTime.now();

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (dialogContext) => _NativeBreakDialog(ad: ad),
    ).whenComplete(() {
      ad.dispose();
      _breakShowing = false;
      _loadNative();
    });
  }

  // -------------------------------------------------------------- rewarded

  void _loadRewarded() {
    RewardedAd.load(
      adUnitId: _rewardedUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewarded = ad;
          rewardedReady.value = true;
        },
        onAdFailedToLoad: (_) {
          _rewarded = null;
          rewardedReady.value = false;
        },
      ),
    );
  }

  /// Opt-in: only call from a button the child/parent taps.
  /// Returns true if an ad was shown; [onReward] runs once the reward is earned.
  bool showRewarded(VoidCallback onReward) {
    final ad = _rewarded;
    if (ad == null) return false;
    _rewarded = null;
    rewardedReady.value = false;
    _lastAdShownAt = DateTime.now();

    var earned = false;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _loadRewarded();
        if (earned) onReward();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _loadRewarded();
      },
    );
    ad.show(onUserEarnedReward: (ad, reward) => earned = true);
    return true;
  }
}

class _NativeBreakDialog extends StatelessWidget {
  static const Color _accent = Color(0xFFFF7F50);

  final NativeAd ad;
  const _NativeBreakDialog({required this.ad});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Always-visible, same-place close bar.
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: double.infinity,
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFB074), _accent],
                ),
                boxShadow: [
                  BoxShadow(
                    color: _accent.withValues(alpha: 0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.close_rounded, color: Colors.white, size: 26),
                  SizedBox(width: 8),
                  Text(
                    'বিজ্ঞাপন বন্ধ করুন',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Clear gap so the close bar and the ad are never confused.
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'বিজ্ঞাপন',
                  style: TextStyle(fontSize: 12, color: Colors.brown.shade300),
                ),
                const SizedBox(height: 6),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    minHeight: 320,
                    maxHeight: 400,
                  ),
                  child: AdWidget(ad: ad),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
