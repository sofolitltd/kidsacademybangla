import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Shows a green "Downloaded" check when [url] is already in the audio cache.
/// Changing [refresh] re-checks the cache (e.g. after a download finishes).
class DownloadedBadge extends StatefulWidget {
  final String url;
  final Object? refresh;
  final bool compact;

  const DownloadedBadge({
    super.key,
    required this.url,
    this.refresh,
    this.compact = false,
  });

  @override
  State<DownloadedBadge> createState() => _DownloadedBadgeState();
}

class _DownloadedBadgeState extends State<DownloadedBadge> {
  bool _downloaded = false;

  @override
  void initState() {
    super.initState();
    _check();
  }

  @override
  void didUpdateWidget(covariant DownloadedBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url || oldWidget.refresh != widget.refresh) {
      _check();
    }
  }

  Future<void> _check() async {
    final info = await DefaultCacheManager().getFileFromCache(widget.url);
    if (!mounted) return;
    final downloaded = info != null;
    if (downloaded != _downloaded) setState(() => _downloaded = downloaded);
  }

  @override
  Widget build(BuildContext context) {
    if (!_downloaded) return const SizedBox.shrink();
    if (widget.compact) {
      return Container(
        padding: const EdgeInsets.all(2),
        decoration: const BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, size: 14, color: Colors.white),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.shade600,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, size: 16, color: Colors.white),
          SizedBox(width: 4),
          Text(
            'ডাউনলোড করা হয়েছে',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
