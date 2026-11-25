import 'dart:math';
import 'dart:typed_data';

/// Tracks how much of a letter the child has painted over.
///
/// The letter is rasterised into a coarse [size]×[size] grid of cells
/// ([glyph] holds 1 for cells inside the letter). Finger movement is fed in as
/// segments in cell units, and [coverage] is the share of letter cells touched.
class TraceGrid {
  final int size;
  final Uint8List glyph;
  final Uint8List _covered;
  late final int glyphCount;
  int _coveredCount = 0;

  TraceGrid(this.size, this.glyph)
    : assert(glyph.length == size * size),
      _covered = Uint8List(size * size) {
    glyphCount = glyph.where((v) => v != 0).length;
  }

  /// Builds a grid from raw RGBA pixels of a [size]×[size] image, treating
  /// any reasonably opaque pixel as part of the letter.
  factory TraceGrid.fromRgba(int size, Uint8List rgba) {
    final cells = Uint8List(size * size);
    for (int i = 0; i < cells.length; i++) {
      if (rgba[i * 4 + 3] > 60) cells[i] = 1;
    }
    return TraceGrid(size, cells);
  }

  /// Share of the letter painted so far, 0–1.
  double get coverage => glyphCount == 0 ? 0 : _coveredCount / glyphCount;

  void clear() {
    _covered.fillRange(0, _covered.length, 0);
    _coveredCount = 0;
  }

  /// Marks every letter cell within [radius] of the segment (x1,y1)–(x2,y2).
  /// All values are in cell units.
  void markSegment(double x1, double y1, double x2, double y2, double radius) {
    final dist = sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
    // Step at half a cell so a fast swipe leaves no gaps.
    final steps = max(1, (dist / 0.5).ceil());
    for (int i = 0; i <= steps; i++) {
      final t = i / steps;
      _markCircle(x1 + (x2 - x1) * t, y1 + (y2 - y1) * t, radius);
    }
  }

  void _markCircle(double cx, double cy, double radius) {
    final r2 = radius * radius;
    final minX = max(0, (cx - radius).floor());
    final maxX = min(size - 1, (cx + radius).ceil());
    final minY = max(0, (cy - radius).floor());
    final maxY = min(size - 1, (cy + radius).ceil());
    for (int y = minY; y <= maxY; y++) {
      for (int x = minX; x <= maxX; x++) {
        final dx = x + 0.5 - cx, dy = y + 0.5 - cy;
        if (dx * dx + dy * dy > r2) continue;
        final i = y * size + x;
        if (glyph[i] != 0 && _covered[i] == 0) {
          _covered[i] = 1;
          _coveredCount++;
        }
      }
    }
  }
}
