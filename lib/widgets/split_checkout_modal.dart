import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../models/split_order.dart';
import '../models/tranche.dart';
import '../services/upi_service.dart';
import '../theme/app_theme.dart';
import 'glass_card.dart';
import 'liquid_glass.dart';

class SplitCheckoutDialog extends StatefulWidget {
  const SplitCheckoutDialog({
    super.key,
    required this.order,
    this.onOrderUpdated,
  });

  final SplitOrder order;
  final ValueChanged<SplitOrder>? onOrderUpdated;

  static Future<void> show(
    BuildContext context, {
    required SplitOrder order,
    ValueChanged<SplitOrder>? onOrderUpdated,
  }) =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        backgroundColor: Colors.transparent,
        builder: (_) => SplitCheckoutDialog(
          order: order,
          onOrderUpdated: onOrderUpdated,
        ),
      );

  @override
  State<SplitCheckoutDialog> createState() => _SplitCheckoutDialogState();
}

class _SplitCheckoutDialogState extends State<SplitCheckoutDialog> {
  int _index = 0;
  bool _busy = false;
  final Set<String> _opened = {};
  Tranche get _part => widget.order.tranches[_index];

  void _message(String text) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
    }
  }

  Future<void> _pay() async {
    final part = _part;
    setState(() => _busy = true);
    final launched = await UpiService.launchUpiIntent(part.upiUri);
    if (!mounted) return;
    setState(() {
      _busy = false;
      if (launched) _opened.add(part.id);
    });
    _message(
      launched
          ? 'Check the result in your UPI app. Your checklist has not changed.'
          : 'Could not open a UPI app. Use the QR code, or copy the link to a device with a UPI app.',
    );
  }

  Future<void> _togglePaid() async {
    if (_part.isPaid) {
      setState(() {
        _part.status = TrancheStatus.pending;
        _part.paidAt = null;
      });
      widget.onOrderUpdated?.call(widget.order);
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text('Checked your payment?'),
        content: const Text(
          'Only mark this part after checking your UPI app and confirming with the recipient. This updates your personal checklist; SplitPee cannot verify payment.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Not yet'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes, mark paid'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() {
      _part.status = TrancheStatus.paid;
      _part.paidAt = DateTime.now();
    });
    widget.onOrderUpdated?.call(widget.order);
  }

  Future<void> _share() async {
    final text = UpiService.generateGroupShareMessage(
      merchantName: widget.order.merchantName,
      payerName: _part.payerName ?? 'Your',
      amount: _part.amount,
      upiUri: _part.upiUri,
    );
    try {
      final box = context.findRenderObject() as RenderBox?;
      await SharePlus.instance.share(
        ShareParams(
          text: text,
          title: 'Your SplitPee share',
          sharePositionOrigin:
              box == null ? null : box.localToGlobal(Offset.zero) & box.size,
        ),
      );
    } catch (_) {
      _message('Sharing is unavailable here. Use Copy link instead.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final part = _part;

    return Center(
      heightFactor: 1,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 640,
          maxHeight: MediaQuery.sizeOf(context).height * 0.92,
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(34)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(34)),
                border: Border(
                  top: BorderSide(
                    color: Colors.white.withValues(alpha: 0.95),
                    width: 1.5,
                  ),
                ),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  22,
                  12,
                  22,
                  24 + MediaQuery.paddingOf(context).bottom,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 42,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.border,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        const Expanded(
                          child: SectionTitle('Your split, sorted.'),
                        ),
                        IconButton(
                          tooltip: 'Close split review',
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '₹${order.totalAmount.toStringAsFixed(2)} across ${order.tranches.length} parts',
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 14),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: order.progress,
                        minHeight: 8,
                        backgroundColor: AppColors.border,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${order.tranches.where((t) => t.isPaid).length} of ${order.tranches.length} marked paid by you',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 48,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: order.tranches.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 8),
                        itemBuilder: (_, i) => ChoiceChip(
                          selected: _index == i,
                          onSelected: _busy
                              ? null
                              : (_) => setState(() => _index = i),
                          label: Text(
                            '${order.tranches[i].isPaid ? '✓ ' : ''}${order.tranches[i].payerName ?? 'Part ${i + 1}'}',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    LiquidGlassCard(
                      padding: const EdgeInsets.all(22),
                      child: Column(
                        children: [
                          Text(
                            part.payerName ?? 'Part ${_index + 1}',
                            style: const TextStyle(
                              color: AppColors.muted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '₹${part.amount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 38,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -1,
                              color: AppColors.ink,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Semantics(
                            label:
                                'UPI payment QR for ₹${part.amount.toStringAsFixed(2)} to ${order.merchantVpa}',
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(22),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF0C2B38)
                                        .withValues(alpha: 0.08),
                                    blurRadius: 18,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                                border: Border.all(
                                  color: AppColors.border,
                                  width: 1.2,
                                ),
                              ),
                              child: QrImageView(
                                data: part.upiUri,
                                size: 190,
                                backgroundColor: Colors.white,
                                errorCorrectionLevel: QrErrorCorrectLevel.M,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            order.merchantName,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          SelectableText(
                            order.merchantVpa,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: AppColors.muted),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            part.isPaid
                                ? 'Marked paid by you · unverified'
                                : 'Review the recipient before paying',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    LiquidSpringButton(
                      isFullWidth: true,
                      onPressed: _busy || part.isPaid ? null : _pay,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _busy
                                ? Icons.hourglass_top_rounded
                                : Icons.open_in_new_rounded,
                            size: 19,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _busy
                                ? 'Opening…'
                                : _opened.contains(part.id)
                                    ? 'Open UPI App Again'
                                    : 'Pay with a UPI App',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.ink,
                              side: const BorderSide(color: AppColors.border),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: () async {
                              try {
                                await UpiService.copyToClipboard(part.upiUri);
                                _message('Payment link copied.');
                              } catch (_) {
                                _message(
                                  'Clipboard unavailable on this device.',
                                );
                              }
                            },
                            icon: const Icon(Icons.copy_rounded, size: 17),
                            label: const Text('Copy Link'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.ink,
                              side: const BorderSide(color: AppColors.border),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: _share,
                            icon: const Icon(
                              Icons.ios_share_rounded,
                              size: 17,
                            ),
                            label: const Text('Share'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: _busy ? null : _togglePaid,
                      icon: Icon(
                        part.isPaid
                            ? Icons.undo_rounded
                            : Icons.check_circle_outline_rounded,
                        size: 19,
                      ),
                      label: Text(
                        part.isPaid
                            ? 'Undo marked paid'
                            : 'I checked — mark as paid',
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'SplitPee cannot confirm payment. Check your UPI app and the recipient. This checklist is cleared when you close the app.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.muted,
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
