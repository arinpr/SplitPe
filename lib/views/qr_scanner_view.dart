import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/split_engine.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/liquid_glass.dart';

class QrScannerView extends StatefulWidget {
  const QrScannerView({super.key});
  @override
  State<QrScannerView> createState() => _QrScannerViewState();
}

class _QrScannerViewState extends State<QrScannerView> with WidgetsBindingObserver {
  final _scanner = MobileScannerController(autoStart: false, detectionSpeed: DetectionSpeed.noDuplicates, formats: const [BarcodeFormat.qrCode]);
  bool _done = false;
  bool _manualOpen = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _startCamera());
  }

  Future<void> _startCamera() async {
    if (!mounted || _done || _manualOpen) return;
    try { await _scanner.start(); } catch (_) { if (mounted) setState(() => _error = 'Camera unavailable. You can enter your UPI details below.'); }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_scanner.value.hasCameraPermission) return;
    if (state == AppLifecycleState.resumed) { _startCamera(); }
    else { _scanner.stop(); }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scanner.dispose();
    super.dispose();
  }

  void _read(String raw) {
    if (_done) return;
    try {
      final result = SplitEngine.parseUpiUri(raw);
      _done = true;
      _scanner.stop();
      Navigator.pop(context, result);
    } on FormatException catch (e) {
      setState(() => _error = e.message);
    }
  }

  Future<void> _manualEntry() async {
    _manualOpen = true;
    await _scanner.stop();
    if (!mounted) return;
    final controller = TextEditingController();
    final form = GlobalKey<FormState>();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter UPI details'),
        content: Form(key: form, child: TextFormField(
          controller: controller, autofocus: true, autocorrect: false, maxLines: 3,
          decoration: const InputDecoration(labelText: 'UPI ID or payment link', hintText: 'name@bank'),
          validator: (value) {
            try { SplitEngine.parseUpiUri(value ?? ''); return null; } on FormatException catch (e) { return e.message; }
          },
        )),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(onPressed: () { if (form.currentState!.validate()) Navigator.pop(context, controller.text); }, child: const Text('Use details')),
        ],
      ),
    );
    // The dialog route may animate after its result completes.
    await Future<void>.delayed(const Duration(milliseconds: 300));
    controller.dispose();
    if (!mounted) return;
    _manualOpen = false;
    if (result != null) { _read(result); } else { _startCamera(); }
  }

  @override
  Widget build(BuildContext context) => LiquidMeshBackground(
    child: Scaffold(
      appBar: AppBar(
        title: const Text(
          'Scan a UPI QR',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SectionTitle(
                'Point. Scan. Review.',
                subtitle:
                    'Your camera reads the QR on your device. Images are never saved or uploaded.',
              ),
              const SizedBox(height: 22),
              LiquidGlassCard(
                padding: const EdgeInsets.all(12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: MobileScanner(
                      controller: _scanner,
                      onDetect: (capture) {
                        if (_done || _manualOpen) return;
                        for (final barcode in capture.barcodes) {
                          if (barcode.rawValue != null) {
                            _read(barcode.rawValue!);
                            break;
                          }
                        }
                      },
                      errorBuilder: (_, error) => Container(
                        color: AppColors.primarySoft,
                        padding: const EdgeInsets.all(24),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.no_photography_outlined,
                              size: 42,
                              color: AppColors.primary,
                            ),
                            SizedBox(height: 14),
                            Text(
                              'Camera access is unavailable.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Allow camera permission in device settings, or enter your UPI details below.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.muted,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    _error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.ink,
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _manualEntry,
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: const Text('Enter UPI ID or paste link'),
              ),
              const SizedBox(height: 16),
              const Text(
                'Always check the recipient’s name in your UPI app before authorising a payment.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.muted, fontSize: 12, height: 1.6),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
