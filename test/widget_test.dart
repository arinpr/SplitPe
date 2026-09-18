import 'package:flutter_test/flutter_test.dart';
import 'package:splitpee/main.dart';
import 'package:splitpee/services/split_engine.dart';

void main() {
  test('SplitEngine correctly splits ₹2,000 into ₹1,999 and ₹1.00 (maxCap)', () {
    final amounts = SplitEngine.calculateTrancheAmounts(
      totalAmount: 2000,
      strategy: TrancheStrategy.maxCap,
    );

    expect(amounts.length, 2);
    expect(amounts[0], 1999.0);
    expect(amounts[1], 1.0);
    expect(amounts[0] <= 1999.0, isTrue);
    expect(amounts[1] <= 1999.0, isTrue);
    expect(amounts.reduce((a, b) => a + b), 2000.0);
  });

  test('SplitEngine correctly splits ₹2,000 into equal ₹1,000 shares', () {
    final amounts = SplitEngine.calculateTrancheAmounts(
      totalAmount: 2000,
      strategy: TrancheStrategy.equal,
    );

    expect(amounts.length, 2);
    expect(amounts[0], 1000.0);
    expect(amounts[1], 1000.0);
    expect(amounts.every((a) => a <= 1999.0), isTrue);
    expect(amounts.reduce((a, b) => a + b), 2000.0);
  });

  test('SplitEngine rejects per-split cap greater than ₹1,999', () {
    expect(
      () => SplitEngine.calculateTrancheAmounts(
        totalAmount: 5000,
        maxTranche: 2000.0,
      ),
      throwsArgumentError,
    );
  });

  test('SplitEngine correctly splits ₹7,500 into ₹1,999 chunks', () {
    final order = SplitEngine.createTrancheOrder(
      totalAmount: 7500,
      merchantVpa: 'store@okhdfcbank',
      merchantName: 'Test Store',
      strategy: TrancheStrategy.maxCap,
    );

    expect(order.tranches.length, 4);
    expect(order.tranches[0].amount, 1999.0);
    expect(order.tranches[1].amount, 1999.0);
    expect(order.tranches[2].amount, 1999.0);
    expect(order.tranches[3].amount, 1503.0);
    expect(order.tranches.every((t) => t.amount <= 1999), isTrue);
    final totalSum = order.tranches.fold(0.0, (sum, t) => sum + t.amount);
    expect(totalSum, 7500.0);
  });

  test('SplitEngine creates equal group split for friends', () {
    final order = SplitEngine.createGroupSplitOrder(
      totalAmount: 3000,
      numberOfPeople: 3,
      merchantVpa: 'restaurant@upi',
      merchantName: 'Dinner Place',
    );

    expect(order.tranches.length, 3);
    expect(order.tranches[0].amount, 1000.0);
    expect(order.tranches[1].amount, 1000.0);
    expect(order.tranches[2].amount, 1000.0);
    expect(order.totalAmount, 3000.0);
  });

  test('SplitEngine parseUpiUri parses valid UPI links', () {
    final uri = 'upi://pay?pa=merchant@icici&pn=Cafe&am=450.00&cu=INR&tn=Lunch';
    final parsed = SplitEngine.parseUpiUri(uri);
    expect(parsed['pa'], 'merchant@icici');
    expect(parsed['pn'], 'Cafe');
    expect(parsed['am'], '450.00');
    expect(parsed['tn'], 'Lunch');
  });

  testWidgets('SplitPeeApp light theme smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SplitPeeApp());
    expect(find.text('SplitPee'), findsWidgets);
    expect(find.text('Smart UPI Split'), findsWidgets);
    expect(find.text('Split'), findsWidgets);
    expect(find.text('Friends'), findsWidgets);
    expect(find.text('Settings'), findsWidgets);
  });
}
