import 'dart:math';
import '../models/split_order.dart';
import '../models/tranche.dart';

/// All split arithmetic uses integer paise so no money is lost to rounding.
abstract final class SplitEngine {
  static const double safeTrancheCap = 1999.0; // A configurable default, not a fee rule.
  static const int maxAmountPaise = 100000000; // UI planning limit: ₹10 lakh.
  static const int maxParts = 200;

  static bool isValidVpa(String value) => RegExp(r'^[a-zA-Z0-9._-]{2,256}@[a-zA-Z][a-zA-Z0-9.-]{1,63}$').hasMatch(value.trim());

  static int toPaise(String value) {
    final clean = value.trim();
    if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(clean)) {
      throw const FormatException('Enter an amount with up to 2 decimal places.');
    }
    final parts = clean.split('.');
    final rupees = int.tryParse(parts.first);
    if (rupees == null || rupees > maxAmountPaise ~/ 100) {
      throw const FormatException('Enter an amount up to ₹10,00,000.');
    }
    final paise = rupees * 100 + (parts.length == 2 ? int.parse(parts[1].padRight(2, '0')) : 0);
    if (paise < 1 || paise > maxAmountPaise) {
      throw const FormatException('Enter an amount between ₹0.01 and ₹10,00,000.');
    }
    return paise;
  }

  static int _checkedPaise(double amount) {
    if (!amount.isFinite || amount <= 0 || amount > maxAmountPaise / 100) {
      throw ArgumentError('Enter a valid positive amount up to ₹10,00,000.');
    }
    final paise = (amount * 100).round();
    if ((amount * 100 - paise).abs() > 0.00001) throw ArgumentError('Use at most two decimal places.');
    return paise;
  }

  static List<double> calculateTrancheAmounts({
    required double totalAmount,
    double maxTranche = safeTrancheCap,
    bool randomize = false,
  }) {
    final total = _checkedPaise(totalAmount);
    final cap = _checkedPaise(maxTranche);
    final count = (total + cap - 1) ~/ cap;
    if (count > maxParts) throw ArgumentError('Increase the per-split limit to create no more than $maxParts parts.');
    // Deterministic equal parts are easier to review than random payment amounts.
    final base = total ~/ count;
    final extra = total % count;
    return List.generate(count, (index) => (base + (index < extra ? 1 : 0)) / 100);
  }

  static SplitOrder createTrancheOrder({
    required double totalAmount,
    required String merchantVpa,
    required String merchantName,
    String note = 'SplitPee bill split',
    double maxTranche = safeTrancheCap,
    bool randomize = false,
  }) => _order(
    amounts: calculateTrancheAmounts(totalAmount: totalAmount, maxTranche: maxTranche),
    merchantVpa: merchantVpa, merchantName: merchantName, note: note,
  );

  static SplitOrder createGroupSplitOrder({
    required double totalAmount,
    required int numberOfPeople,
    required String merchantVpa,
    required String merchantName,
    List<String>? friendNames,
    String note = 'SplitPee group split',
  }) {
    final total = _checkedPaise(totalAmount);
    if (numberOfPeople < 2 || numberOfPeople > 20) throw ArgumentError('Choose between 2 and 20 people.');
    if (total < numberOfPeople) throw ArgumentError('The bill must allow at least ₹0.01 per person.');
    final base = total ~/ numberOfPeople;
    final extra = total % numberOfPeople;
    return _order(
      amounts: List.generate(numberOfPeople, (i) => (base + (i < extra ? 1 : 0)) / 100),
      merchantVpa: merchantVpa, merchantName: merchantName, note: note,
      names: List.generate(numberOfPeople, (i) => friendNames != null && i < friendNames.length ? friendNames[i] : (i == 0 ? 'You' : 'Friend ${i + 1}')),
    );
  }

  static SplitOrder _order({required List<double> amounts, required String merchantVpa, required String merchantName, required String note, List<String>? names}) {
    if (!isValidVpa(merchantVpa)) throw ArgumentError('Enter a valid recipient UPI ID.');
    final id = 'SP${DateTime.now().microsecondsSinceEpoch}${Random.secure().nextInt(99999)}';
    final tranches = List.generate(amounts.length, (i) {
      final ref = '$id${i + 1}';
      return Tranche(
        id: ref, index: i + 1, amount: amounts[i], payerName: names?[i],
        upiUri: buildUpiUri(vpa: merchantVpa, name: merchantName, amount: amounts[i], txnRef: ref, note: '$note · ${names?[i] ?? 'Part ${i + 1}'}'),
      );
    });
    return SplitOrder(
      orderId: id, merchantVpa: merchantVpa.trim(), merchantName: merchantName.trim(),
      totalAmount: amounts.fold<int>(0, (sum, amount) => sum + (amount * 100).round()) / 100,
      note: note, tranches: tranches, createdAt: DateTime.now(),
    );
  }

  static String buildUpiUri({required String vpa, required String name, required double amount, String? txnRef, required String note}) {
    if (!isValidVpa(vpa)) throw ArgumentError('Invalid recipient UPI ID.');
    _checkedPaise(amount);
    final params = <String, String>{
      'pa': vpa.trim(),
      if (name.trim().isNotEmpty) 'pn': name.trim(),
      'am': amount.toStringAsFixed(2), 'cu': 'INR',
      if (note.trim().isNotEmpty) 'tn': note.trim(),
      if (txnRef != null && txnRef.isNotEmpty) 'tr': txnRef,
    };
    return 'upi://pay?${params.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&')}';
  }

  static Map<String, String> parseUpiUri(String rawData) {
    final clean = rawData.trim();
    if (isValidVpa(clean)) return {'pa': clean, 'pn': '', 'am': '', 'tn': ''};
    try {
      final uri = Uri.parse(clean);
      if (uri.scheme.toLowerCase() != 'upi' || uri.host.toLowerCase() != 'pay' || uri.path.isNotEmpty || uri.fragment.isNotEmpty) {
        throw const FormatException('Scan a UPI payment QR code or enter a UPI ID.');
      }
      final query = <String, String>{};
      for (final entry in uri.queryParametersAll.entries) {
        final key = entry.key.toLowerCase();
        if (entry.value.length != 1 || query.containsKey(key)) throw const FormatException('This QR has duplicate payment details.');
        query[key] = entry.value.single;
      }
      if (!isValidVpa(query['pa'] ?? '')) throw const FormatException('This QR does not contain a valid UPI ID.');
      if (query['cu'] != null && query['cu'] != 'INR') throw const FormatException('Only INR payment QR codes are supported.');
      final amount = query['am'] ?? '';
      if (amount.isNotEmpty) toPaise(amount);
      return {'pa': query['pa']!, 'pn': query['pn'] ?? '', 'am': amount, 'tn': query['tn'] ?? ''};
    } on FormatException { rethrow; }
    catch (_) { throw const FormatException('This UPI QR code could not be read.'); }
  }
}
