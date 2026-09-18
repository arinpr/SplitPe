import 'tranche.dart';

class SplitOrder {
  final String orderId;
  final String merchantVpa;
  final String merchantName;
  final double totalAmount;
  final String note;
  final List<Tranche> tranches;
  final DateTime createdAt;

  SplitOrder({required this.orderId, required this.merchantVpa, required this.merchantName, required this.totalAmount, required this.note, required this.tranches, required this.createdAt});

  /// User-maintained checklist only. This is not a verified payment status.
  double get paidAmount => tranches.where((t) => t.isPaid).fold<int>(0, (sum, t) => sum + (t.amount * 100).round()) / 100;
  double get remainingAmount => ((totalAmount * 100).round() - (paidAmount * 100).round()).clamp(0, (totalAmount * 100).round()) / 100;
  double get progress => totalAmount == 0 ? 0 : paidAmount / totalAmount;
  bool get isFullyPaid => tranches.isNotEmpty && tranches.every((t) => t.isPaid);
}
