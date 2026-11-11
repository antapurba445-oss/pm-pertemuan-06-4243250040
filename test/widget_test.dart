import 'package:flutter_test/flutter_test.dart';
import 'package:pertemuan_06/main.dart';

void main() {
  testWidgets('opens a destination detail page', (tester) async {
    await tester.pumpWidget(const WisataApp());
    await tester.pumpAndSettle();

    expect(find.text('Budaya & Sejarah Sumut'), findsOneWidget);
    expect(find.text('Istana Maimun'), findsOneWidget);

    await tester.tap(find.text('Istana Maimun').first);
    await tester.pumpAndSettle();

    expect(find.text('Sekilas'), findsOneWidget);
    expect(find.text('Saran berkunjung'), findsOneWidget);
  });
}
