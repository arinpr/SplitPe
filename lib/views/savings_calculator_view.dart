import 'package:flutter/material.dart';
import '../services/split_engine.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/liquid_glass.dart';

class SavingsCalculatorView extends StatefulWidget {
  const SavingsCalculatorView({super.key});

  @override
  State<SavingsCalculatorView> createState() => _SavingsCalculatorViewState();
}

class _SavingsCalculatorViewState extends State<SavingsCalculatorView> {
  final _form = GlobalKey<FormState>();
  final _amount = TextEditingController();
  final _rate = TextEditingController();
  double? _fee;

  @override
  void dispose() {
    _amount.dispose();
    _rate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
    child: Form(
      key: _form,
      onChanged: () {
        if (_fee != null) setState(() => _fee = null);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionTitle(
            'A clearer picture.',
            subtitle: 'Estimate a provider’s percentage fee using the rate they gave you.',
          ),
          const SizedBox(height: 20),
          LiquidGlassCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2DD4BF), Color(0xFF087F75)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF087F75).withValues(alpha: 0.28),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.85),
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(Icons.calculate_rounded, size: 30, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _amount,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Bill amount', prefixText: '₹ '),
                  validator: (value) {
                    try {
                      SplitEngine.toPaise(value ?? '');
                      return null;
                    } on FormatException catch (e) {
                      return e.message;
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _rate,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Provider fee rate', suffixText: '%'),
                  validator: (value) {
                    final rate = double.tryParse(value ?? '');
                    return rate != null && rate.isFinite && rate >= 0 && rate <= 100
                        ? null
                        : 'Enter a rate from 0 to 100.';
                  },
                ),
                const SizedBox(height: 24),
                LiquidSpringButton(
                  isFullWidth: true,
                  onPressed: () {
                    if (_form.currentState!.validate()) {
                      setState(() {
                        _fee = SplitEngine.toPaise(_amount.text) /
                            100 *
                            double.parse(_rate.text) /
                            100;
                      });
                    }
                  },
                  child: const Text('Calculate Estimate'),
                ),
                if (_fee != null) ...[
                  const SizedBox(height: 28),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.25),
                        width: 1.2,
                      ),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Estimated Fee',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.muted,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '₹${_fee!.toStringAsFixed(2)}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                            letterSpacing: -1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Illustration only. This excludes taxes, fixed charges and provider-specific conditions. It does not predict savings from splitting or determine what your bank will charge.',
            style: TextStyle(color: AppColors.muted, height: 1.6, fontSize: 13),
          ),
        ],
      ),
    ),
  );
}
