import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'split_engine.dart';

abstract final class UpiService {
  static Future<bool> launchUpiIntent(String upiUri) async {
    try {
      SplitEngine.parseUpiUri(upiUri);
      final uri = Uri.parse(upiUri);
      if (uri.scheme != 'upi') return false;
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) { return false; }
  }

  static Future<void> copyToClipboard(String text) => Clipboard.setData(ClipboardData(text: text));

  static String generateGroupShareMessage({required String merchantName, required String payerName, required double amount, required String upiUri}) =>
    '$payerName, your share for $merchantName is ₹${amount.toStringAsFixed(2)}.\n'
    'Review the recipient before paying in your UPI app.\n$upiUri\n\nSplitPee - Smart UPI Split';
}
