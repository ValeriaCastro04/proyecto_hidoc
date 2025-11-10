import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:proyecto_hidoc/common/shared_widgets/footer.dart';
import 'package:proyecto_hidoc/common/shared_widgets/header_bar.dart';
import 'package:proyecto_hidoc/common/shared_widgets/payment_summary_card.dart';
import 'package:proyecto_hidoc/common/shared_widgets/theme_toggle_button.dart';
import 'package:proyecto_hidoc/features/user/widgets/footer_user.dart';
import 'package:proyecto_hidoc/features/user/pages/pago_exitoso_page.dart';
import 'package:proyecto_hidoc/features/user/services/payment_service.dart';
import 'package:proyecto_hidoc/features/user/models/payment_models.dart';

class PagoPage extends StatefulWidget {
  static const String name = 'Pago';

  final String concept;         // "Consulta médica" o similar
  final double amount;          // 8.0, 9.0, etc.
  final String doctorId;        // id del doctor elegido
  final String doctorName;      // nombre del doctor elegido
  final PaymentKind kind;       // consulta | membresia
  final Duration holdTime;      // tiempo límite para pagar

  const PagoPage({
    super.key,
    required this.concept,
    required this.amount,
    required this.doctorId,
    required this.doctorName,
    this.kind = PaymentKind.consulta,
    this.holdTime = const Duration(minutes: 5),
  });

  @override
  State<PagoPage> createState() => _PagoPageState();
}

class _PagoPageState extends State<PagoPage> {
  late Duration remaining;
  Timer? timer;

  // form
  PayMethod method = PayMethod.card;
  final formKey = GlobalKey<FormState>();
  final ctrlCard = TextEditingController();
  final ctrlExp  = TextEditingController(); // MM/AA
  final ctrlCvv  = TextEditingController();
  final ctrlName = TextEditingController(); // sin valor por defecto

  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    remaining = widget.holdTime;
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      if (remaining.inSeconds <= 1) {
        setState(() => remaining = Duration.zero);
        t.cancel();
      } else {
        setState(() => remaining = Duration(seconds: remaining.inSeconds - 1));
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    ctrlCard.dispose();
    ctrlExp.dispose();
    ctrlCvv.dispose();
    ctrlName.dispose();
    super.dispose();
  }

  // -------- helpers visuales --------
  String _mmss(Duration d) {
    final m = d.inMinutes.remainder(60).toString();
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }
  String _money(double v) => '\$${v.toStringAsFixed(2)}';

  // -------- validaciones --------
  bool _luhnOk(String raw) {
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 12) return false;
    int sum = 0;
    final chars = digits.split('').reversed.toList();
    for (int i = 0; i < chars.length; i++) {
      int n = int.parse(chars[i]);
      if (i.isOdd) {
        n *= 2;
        if (n > 9) n -= 9;
      }
      sum += n;
    }
    return sum % 10 == 0;
  }

  bool _expOk(String exp) {
    // MM/AA
    final m = RegExp(r'^(\d{2})/(\d{2})$').firstMatch(exp.trim());
    if (m == null) return false;
    final mm = int.parse(m.group(1)!);
    final yy = int.parse(m.group(2)!); // 20yy
    if (mm < 1 || mm > 12) return false;

    // Vencimiento: último día del mes indicado
    final now = DateTime.now();
    final year = 2000 + yy;
    final endMonth = DateTime(year, mm + 1, 0);
    return !endMonth.isBefore(DateTime(now.year, now.month, now.day));
  }

  Future<void> _submit() async {
    if (remaining == Duration.zero || _submitting) return;

    if (method == PayMethod.card) {
      final ok = formKey.currentState?.validate() ?? false;
      if (!ok) return;
    }

    setState(() => _submitting = true);
    final scaffold = ScaffoldMessenger.of(context);
    final paySvc = PaymentService();

    try {
      final r = await paySvc.checkoutConsultation(
        doctorId: widget.doctorId,
        amount: widget.amount,
        concept: widget.concept,
        method: method == PayMethod.card ? 'card' : 'tigo',
        cardPan:  method == PayMethod.card ? ctrlCard.text : null,
        cardExp:  method == PayMethod.card ? ctrlExp.text  : null,
        cardCvv:  method == PayMethod.card ? ctrlCvv.text  : null,
        cardHolder: method == PayMethod.card ? ctrlName.text.trim() : null,
      );

      if (!mounted) return;
      context.goNamed(
        PagoExitosoPage.name,
        queryParameters: {
          'concept': 'Consulta con ${widget.doctorName}',
          'amount': widget.amount.toStringAsFixed(2),
          'doctor': widget.doctorName,
          'id': r.appointmentId,
          'metodo': r.maskedMethod,
        },
      );
    } catch (e) {
      scaffold.showSnackBar(
        SnackBar(content: Text('No se pudo completar el pago: $e')),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final totalFormatted = _money(widget.amount);

    return Scaffold(
      appBar: HeaderBar.category(
        title: 'Pago',
        subtitle: widget.kind == PaymentKind.consulta
            ? 'Completa tu consulta'
            : 'Completa tu membresía',
        icon: Icons.receipt_long_rounded,
        onBack: () { if (context.canPop()) context.pop(); },
        actions: const [ ThemeToggleButton() ],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 96),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner tiempo
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0CABA8),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.teal.shade700.withOpacity(.35)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tiempo restante para pagar la ${widget.kind == PaymentKind.consulta ? 'cita' : 'membresía'}:',
                            style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Doctor: ${widget.doctorName}',
                            style: tt.bodyMedium?.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                      Text(
                        _mmss(remaining),
                        style: tt.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Resumen pago
                PaymentSummaryCard(
                  title: 'Resumen del Pago',
                  lines: [
                    PaymentLine(label: widget.concept, value: _money(widget.amount), bold: true),
                    PaymentLine(label: 'Doctor', value: widget.doctorName),
                    PaymentLine.divider(),
                  ],
                  totalLabel: 'Total',
                  totalValue: totalFormatted,
                ),
                const SizedBox(height: 16),

                Text('Método de Pago', style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),

                Container(
                  decoration: BoxDecoration(
                    color: cs.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: cs.outline.withOpacity(.15)),
                  ),
                  child: Column(
                    children: [
                      RadioListTile<PayMethod>(
                        value: PayMethod.card,
                        groupValue: method,
                        onChanged: (v) => setState(() => method = v!),
                        title: const Text('Tarjeta de Crédito/Débito'),
                        secondary: const Icon(Icons.credit_card_rounded),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                if (method == PayMethod.card)
                  _CardForm(
                    formKey: formKey,
                    ctrlCard: ctrlCard,
                    ctrlExp: ctrlExp,
                    ctrlCvv: ctrlCvv,
                    ctrlName: ctrlName,
                    luhn: _luhnOk,
                    expOk: _expOk,
                  ),

                const SizedBox(height: 12),

                // Info de seguridad
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.verified_user_rounded, size: 20, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Tu información está protegida con cifrado de seguridad.',
                          style: tt.bodyMedium?.copyWith(color: Colors.green.shade800),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Botón pagar
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: (remaining == Duration.zero || _submitting) ? null : _submit,
                    child: _submitting
                        ? const SizedBox(
                            height: 22, width: 22,
                            child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)),
                          )
                        : Text('Pagar ${_money(widget.amount)}'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Footer(
        buttons: userFooterButtons(context, current: UserTab.consultas),
      ),
    );
  }
}

class _CardForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController ctrlCard;
  final TextEditingController ctrlExp;
  final TextEditingController ctrlCvv;
  final TextEditingController ctrlName;
  final bool Function(String) luhn;
  final bool Function(String) expOk;

  const _CardForm({
    required this.formKey,
    required this.ctrlCard,
    required this.ctrlExp,
    required this.ctrlCvv,
    required this.ctrlName,
    required this.luhn,
    required this.expOk,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    InputDecoration deco(String label, {String? hint}) => InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: cs.primary.withOpacity(.06),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Información de tarjeta', style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),

          TextFormField(
            controller: ctrlCard,
            keyboardType: TextInputType.number,
            decoration: deco('Número de Tarjeta', hint: '1234 5678 9012 3456'),
            validator: (v) {
              final raw = (v ?? '').trim();
              return luhn(raw) ? null : 'Número de tarjeta inválido';
            },
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: ctrlExp,
                  keyboardType: TextInputType.datetime,
                  decoration: deco('Fecha de Vencimiento', hint: 'MM/AA'),
                  validator: (v) => expOk(v ?? '') ? null : 'Fecha inválida',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: ctrlCvv,
                  keyboardType: TextInputType.number,
                  decoration: deco('CVV', hint: '123'),
                  validator: (v) {
                    final s = (v ?? '').trim();
                    if (s.length < 3 || s.length > 4 || !RegExp(r'^\d+$').hasMatch(s)) {
                      return 'CVV inválido';
                    }
                    return null;
                  },
                  obscureText: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          TextFormField(
            controller: ctrlName,
            textCapitalization: TextCapitalization.words,
            decoration: deco('Nombre en la Tarjeta', hint: 'Nombre y Apellido'),
            validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Ingrese el nombre' : null,
          ),
        ],
      ),
    );
  }
}