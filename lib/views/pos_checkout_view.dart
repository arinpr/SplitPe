import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app_info.dart';
import '../models/split_order.dart';
import '../services/split_engine.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/liquid_glass.dart';
import '../widgets/split_checkout_modal.dart';
import 'qr_scanner_view.dart';

class PosCheckoutView extends StatefulWidget {
  const PosCheckoutView({super.key, this.groupMode = false, this.onGroupTap});
  final bool groupMode;
  final VoidCallback? onGroupTap;

  @override
  State<PosCheckoutView> createState() => PosCheckoutViewState();
}

class PosCheckoutViewState extends State<PosCheckoutView> {
  final _form = GlobalKey<FormState>();
  final _amount = TextEditingController();
  final _vpa = TextEditingController();
  final _name = TextEditingController();
  final _note = TextEditingController();
  final _limit = TextEditingController(text: '1999');
  int _people = 4;
  TrancheStrategy _strategy = TrancheStrategy.maxCap;
  SplitOrder? _order;

  @override
  void dispose() {
    for (final controller in [_amount, _vpa, _name, _note, _limit]) {
      controller.dispose();
    }
    super.dispose();
  }

  void applyScannedData(Map<String, String> data) {
    setState(() {
      _vpa.text = data['pa'] ?? '';
      _name.text = data['pn'] ?? '';
      _amount.text = data['am'] ?? '';
      _note.text = data['tn'] ?? '';
      _order = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('QR added. Review the recipient and amount before continuing.'),
      ),
    );
  }

  Future<void> scanMerchantQr() async {
    final result = await Navigator.of(context).push<Map<String, String>>(
      MaterialPageRoute(builder: (_) => const QrScannerView()),
    );
    if (result != null && mounted) applyScannedData(result);
  }

  String? _validateAmount(String? value) {
    try {
      SplitEngine.toPaise(value ?? '');
      return null;
    } on FormatException catch (error) {
      return error.message;
    }
  }

  String? _validateLimit(String? value) {
    try {
      final paise = SplitEngine.toPaise(value ?? '');
      if (paise > 199900) {
        return 'Max ₹1,999';
      }
      return null;
    } on FormatException catch (error) {
      return error.message;
    }
  }

  void _createSplit() {
    FocusScope.of(context).unfocus();
    if (!_form.currentState!.validate()) return;
    try {
      final amount = SplitEngine.toPaise(_amount.text) / 100;
      final name = _name.text.trim().isEmpty
          ? _vpa.text.trim().split('@').first
          : _name.text.trim();
      final note =
          _note.text.trim().isEmpty ? 'SplitPee bill split' : _note.text.trim();
      final order = widget.groupMode
          ? SplitEngine.createGroupSplitOrder(
              totalAmount: amount,
              numberOfPeople: _people,
              merchantVpa: _vpa.text.trim(),
              merchantName: name,
              note: note,
            )
          : SplitEngine.createTrancheOrder(
              totalAmount: amount,
              merchantVpa: _vpa.text.trim(),
              merchantName: name,
              maxTranche: SplitEngine.toPaise(_limit.text) / 100,
              strategy: _strategy,
              note: note,
            );
      setState(() => _order = order);
      _reviewOrder(order);
    } on ArgumentError catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message.toString())),
      );
    } on FormatException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message)),
      );
    }
  }

  Future<void> _reviewOrder(SplitOrder order) => SplitCheckoutDialog.show(
        context,
        order: order,
        onOrderUpdated: (_) {
          if (mounted) setState(() {});
        },
      );

  @override
  Widget build(BuildContext context) {
    final group = widget.groupMode;
    return SingleChildScrollView(
      key: PageStorageKey(group ? 'friends' : 'split'),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 96),
      child: Form(
        key: _form,
        onChanged: () {
          if (_order != null) setState(() => _order = null);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Text(
                    group ? 'BETTER TOGETHER' : 'A LITTLE LESS COMPLICATED',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.auto_awesome_rounded,
                  size: 20,
                  color: AppColors.primary,
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              group ? 'Good times.\nFair shares.' : 'Big bill.\nEasy little splits.',
              style: const TextStyle(
                fontSize: 34,
                height: 1.12,
                fontWeight: FontWeight.w800,
                letterSpacing: -1.4,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              group
                  ? 'From dinner plans to weekend trips, make everyone’s share clear.'
                  : 'Organise your bill and pay each part with your favourite UPI app.',
              style: const TextStyle(
                color: AppColors.muted,
                fontSize: 14,
                height: 1.55,
              ),
            ),
            const SizedBox(height: 22),
            LiquidGlassCard(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.account_balance_wallet_outlined,
                        size: 20,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        group ? 'The shared bill' : 'Your bill amount',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        'INR',
                        style: TextStyle(
                          color: AppColors.muted,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    key: ValueKey(group ? 'group-amount' : 'bill-amount'),
                    controller: _amount,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    validator: _validateAmount,
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1.5,
                      color: AppColors.ink,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Total amount',
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      prefixText: '₹ ',
                      hintText: '0.00',
                      filled: false,
                      contentPadding: EdgeInsets.symmetric(vertical: 6),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                  const Divider(height: 26),
                  if (group)
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 16,
                      children: [
                        const Text(
                          'People, including you',
                          style: TextStyle(
                            color: AppColors.muted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton.outlined(
                              tooltip: 'Remove a person',
                              onPressed: _people > 2
                                  ? () => setState(() {
                                        _people--;
                                        _order = null;
                                      })
                                  : null,
                              icon: const Icon(Icons.remove, size: 18),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                '$_people',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            IconButton.outlined(
                              tooltip: 'Add a person',
                              onPressed: _people < 20
                                  ? () => setState(() {
                                        _people++;
                                        _order = null;
                                      })
                                  : null,
                              icon: const Icon(Icons.add, size: 18),
                            ),
                          ],
                        ),
                      ],
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Maximum per split',
                                    style: TextStyle(
                                      color: AppColors.ink,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Strictly capped at ₹1,999 for compliance',
                                    style: TextStyle(
                                      color: AppColors.muted,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 120,
                              child: TextFormField(
                                controller: _limit,
                                validator: _validateLimit,
                                keyboardType: const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9.]'),
                                  ),
                                ],
                                decoration: const InputDecoration(
                                  prefixText: '₹ ',
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        // Quick cap chips
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: ['1999', '1499', '999', '499'].map((val) {
                            final isSelected = _limit.text.trim() == val;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _limit.text = val;
                                  _order = null;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primarySoft
                                      : Colors.white.withValues(alpha: 0.7),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.border,
                                    width: isSelected ? 1.4 : 1.0,
                                  ),
                                ),
                                child: Text(
                                  '₹$val${val == '1999' ? ' (Default)' : ''}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.muted,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 14),
                        // Strategy Mode Toggle
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE9F2F5),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() {
                                    _strategy = TrancheStrategy.maxCap;
                                    _order = null;
                                  }),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _strategy == TrancheStrategy.maxCap
                                          ? Colors.white
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(11),
                                      boxShadow: _strategy == TrancheStrategy.maxCap
                                          ? [
                                              BoxShadow(
                                                color: const Color(0xFF0C2B38)
                                                    .withValues(alpha: 0.08),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ]
                                          : null,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '₹1,999 Slices',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight:
                                              _strategy == TrancheStrategy.maxCap
                                                  ? FontWeight.w700
                                                  : FontWeight.w500,
                                          color: _strategy == TrancheStrategy.maxCap
                                              ? AppColors.primary
                                              : AppColors.muted,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() {
                                    _strategy = TrancheStrategy.equal;
                                    _order = null;
                                  }),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _strategy == TrancheStrategy.equal
                                          ? Colors.white
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(11),
                                      boxShadow: _strategy == TrancheStrategy.equal
                                          ? [
                                              BoxShadow(
                                                color: const Color(0xFF0C2B38)
                                                    .withValues(alpha: 0.08),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ]
                                          : null,
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Equal Shares',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight:
                                              _strategy == TrancheStrategy.equal
                                                  ? FontWeight.w700
                                                  : FontWeight.w500,
                                          color: _strategy == TrancheStrategy.equal
                                              ? AppColors.primary
                                              : AppColors.muted,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            LiquidGlassCard(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: SectionTitle('Who’s receiving?'),
                      ),
                      IconButton(
                        tooltip: 'Scan recipient QR',
                        onPressed: scanMerchantQr,
                        icon: const Icon(
                          Icons.qr_code_scanner_rounded,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    key: ValueKey(group ? 'group-vpa' : 'recipient-vpa'),
                    controller: _vpa,
                    autocorrect: false,
                    enableSuggestions: false,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Recipient UPI ID',
                      hintText: 'name@bank',
                      prefixIcon: Icon(Icons.alternate_email_rounded, size: 20),
                    ),
                    validator: (value) => SplitEngine.isValidVpa(value ?? '')
                        ? null
                        : 'Enter a valid UPI ID, such as name@bank.',
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _name,
                    maxLength: 60,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Recipient name (optional)',
                      counterText: '',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _note,
                    maxLength: 80,
                    decoration: const InputDecoration(
                      labelText: 'What’s it for? (optional)',
                      hintText: 'Dinner, groceries, a little getaway…',
                      counterText: '',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            LiquidSpringButton(
              isFullWidth: true,
              onPressed: _createSplit,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.call_split_rounded, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    group ? 'Create Everyone’s Shares' : 'Preview My Split',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_outline_rounded,
                  size: 14,
                  color: AppColors.muted,
                ),
                SizedBox(width: 6),
                Flexible(
                  child: Text(
                    'You approve every payment in your UPI app.',
                    style: TextStyle(fontSize: 11, color: AppColors.muted),
                  ),
                ),
              ],
            ),
            if (_order != null) ...[
              const SizedBox(height: 18),
              LiquidGlassCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SectionTitle('Your Current Split'),
                    const SizedBox(height: 8),
                    Text(
                      '${_order!.tranches.length} parts · ₹${_order!.paidAmount.toStringAsFixed(2)} marked paid by you',
                      style: const TextStyle(color: AppColors.muted),
                    ),
                    const SizedBox(height: 10),
                    LiquidSpringButton(
                      backgroundColor: AppColors.primarySoft,
                      foregroundColor: AppColors.primary,
                      elevation: 2,
                      borderRadius: 14,
                      onPressed: () => _reviewOrder(_order!),
                      child: const Text('Continue Reviewing'),
                    ),
                  ],
                ),
              ),
            ],
            if (!group) ...[
              const SizedBox(height: 20),
              LiquidGlassCard(
                tint: const Color(0xFFF3F0FF),
                padding: const EdgeInsets.all(18),
                onTap: widget.onGroupTap,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white,
                          width: 1.2,
                        ),
                      ),
                      child: const Icon(
                        Icons.people_outline_rounded,
                        color: Color(0xFF7660AE),
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Out with friends?',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Split equally. Share instantly.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 20,
                      color: Color(0xFF7660AE),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            const Text(
              'SplitPee organises payments. Fees and limits are set by your payment provider; splitting does not guarantee a fee waiver.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: AppColors.muted, height: 1.5),
            ),
            const SizedBox(height: 14),
            const Text(
              AppInfo.copyright,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, color: AppColors.muted),
            ),
          ],
        ),
      ),
    );
  }
}
