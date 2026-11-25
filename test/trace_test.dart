import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kidsacademybangla/core/services/age_service.dart';
import 'package:kidsacademybangla/features/details/trace_screen.dart';
import 'package:kidsacademybangla/features/details/widgets/trace_grid.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A 10×10 grid whose letter is one horizontal bar on row 5.
TraceGrid _barGrid() {
  final cells = Uint8List(100);
  for (int x = 0; x < 10; x++) {
    cells[5 * 10 + x] = 1;
  }
  return TraceGrid(10, cells);
}

void main() {
  group('TraceGrid', () {
    test('starts empty', () {
      final g = _barGrid();
      expect(g.glyphCount, 10);
      expect(g.coverage, 0);
    });

    test('painting along the letter covers it', () {
      final g = _barGrid();
      g.markSegment(0, 5.5, 5, 5.5, 0.8);
      expect(g.coverage, closeTo(0.5, 0.11));
      g.markSegment(5, 5.5, 10, 5.5, 0.8);
      expect(g.coverage, 1);
    });

    test('painting away from the letter covers nothing', () {
      final g = _barGrid();
      g.markSegment(0, 1, 10, 1, 0.8);
      expect(g.coverage, 0);
    });

    test('going over the same part twice does not double count', () {
      final g = _barGrid();
      g.markSegment(0, 5.5, 5, 5.5, 0.8);
      final once = g.coverage;
      g.markSegment(0, 5.5, 5, 5.5, 0.8);
      expect(g.coverage, once);
    });

    test('a fast swipe leaves no gaps', () {
      final g = _barGrid();
      g.markSegment(-3, 5.5, 13, 5.5, 0.6);
      expect(g.coverage, 1);
    });

    test('clear resets', () {
      final g = _barGrid();
      g.markSegment(0, 5.5, 10, 5.5, 0.8);
      g.clear();
      expect(g.coverage, 0);
    });

    test('fromRgba reads opaque pixels as letter', () {
      final rgba = Uint8List(2 * 2 * 4);
      rgba[3] = 255; // first pixel opaque
      rgba[7] = 10; // second nearly transparent
      final g = TraceGrid.fromRgba(2, rgba);
      expect(g.glyphCount, 1);
    });
  });

  group('TraceScreen', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
      AgeService.level.value = 5;
      // Speech and audio plugins don't exist in tests; answer every call.
      final messenger =
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
      for (final name in [
        'flutter_tts',
        'xyz.luan/audioplayers',
        'xyz.luan/audioplayers.global',
      ]) {
        messenger.setMockMethodCallHandler(
          MethodChannel(name),
          (call) async => 1,
        );
      }
    });

    // The audio player also opens event streams and writes assets to a temp
    // directory, neither of which exists here. Those failures are expected.
    void ignorePluginErrors() {
      final original = FlutterError.onError;
      FlutterError.onError = (details) {
        if (details.exception is! MissingPluginException) {
          original?.call(details);
        }
      };
      addTearDown(() => FlutterError.onError = original);
    }

    testWidgets('scribbling over the whole pad finishes the letter', (
      tester,
    ) async {
      ignorePluginErrors();
      await tester.pumpWidget(
        const MaterialApp(
          home: TraceScreen(itemId: 'english_alphabets', title: 'Alphabets'),
        ),
      );
      // Let the letter rasterise into the coverage grid.
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 300)),
      );
      await tester.pump();

      final bar = find.byType(LinearProgressIndicator);
      expect(tester.widget<LinearProgressIndicator>(bar).value, 0);
      expect(find.byIcon(Icons.star_rounded), findsNothing);

      // Zig-zag across the pad, top to bottom.
      final pad = tester.getRect(find.byType(CustomPaint).last);
      final gesture = await tester.startGesture(
        pad.topLeft + const Offset(4, 4),
      );
      for (double y = 4; y < pad.height; y += 12) {
        await gesture.moveTo(pad.topLeft + Offset(pad.width - 4, y));
        await gesture.moveTo(pad.topLeft + Offset(4, y + 6));
      }
      await gesture.up();
      await tester.pump();

      expect(tester.widget<LinearProgressIndicator>(bar).value, 1);
      expect(find.byIcon(Icons.star_rounded), findsOneWidget);
      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('a single small dab does not finish the letter', (
      tester,
    ) async {
      ignorePluginErrors();
      await tester.pumpWidget(
        const MaterialApp(home: TraceScreen(itemId: 'english_alphabets')),
      );
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 300)),
      );
      await tester.pump();

      final pad = tester.getRect(find.byType(CustomPaint).last);
      await tester.tapAt(pad.center);
      await tester.pump();

      final bar = find.byType(LinearProgressIndicator);
      expect(tester.widget<LinearProgressIndicator>(bar).value, lessThan(1));
      expect(find.byIcon(Icons.star_rounded), findsNothing);
    });
  });
}
