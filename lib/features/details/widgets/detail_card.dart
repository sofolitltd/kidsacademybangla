import 'package:flutter/material.dart';

import 'detail_card_builders.dart';
import 'downloaded_badge.dart';
import 'package:kidsacademybangla/core/config/app_urls.dart';

class DetailCard extends StatefulWidget {
  final Map<String, dynamic> item;
  final String? itemId;
  final Color categoryColor;
  final bool isSelected;
  final VoidCallback onTap;
  final ValueChanged<String>? onSpeak;
  final bool isAudioLoading;

  const DetailCard({
    super.key,
    required this.item,
    required this.itemId,
    required this.categoryColor,
    required this.isSelected,
    required this.onTap,
    this.onSpeak,
    this.isAudioLoading = false,
  });

  @override
  State<DetailCard> createState() => _DetailCardState();
}

class _DetailCardState extends State<DetailCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.95), weight: 33),
      TweenSequenceItem(tween: Tween(begin: 0.95, end: 1.05), weight: 33),
      TweenSequenceItem(tween: Tween(begin: 1.08, end: 1.0), weight: 34),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(covariant DetailCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final letterColors = [
      Colors.red.shade400,
      Colors.blue.shade400,
      Colors.green.shade400,
      Colors.purple.shade400,
      Colors.orange.shade400,
      Colors.pink.shade400,
      Colors.teal.shade400,
      Colors.indigo.shade400,
    ];

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(scale: _scaleAnimation.value, child: child);
      },
      child: GestureDetector(
        onTap: widget.onTap,
        onLongPress: widget.onSpeak != null
            ? () => widget.onSpeak!(widget.item['item'] ?? '')
            : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? Colors.white.withValues(alpha: 0.5)
                : Colors.white.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.isSelected
                  ? widget.categoryColor
                  : Colors.white.withValues(alpha: 0.6),
              width: widget.isSelected ? 3 : 3,
            ),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: widget.categoryColor.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : [],
          ),
          child: Stack(
            children: [
              buildCardContent(
                item: widget.item,
                itemId: widget.itemId,
                categoryColor: widget.categoryColor,
                letterColors: letterColors,
              ),
              if (widget.itemId == 'small_suras')
                Positioned(
                  top: 0,
                  right: 0,
                  child: DownloadedBadge(
                    url: AppUrls.surahAudio(widget.item['id']),
                    refresh: (widget.isSelected, widget.isAudioLoading),
                    compact: true,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
