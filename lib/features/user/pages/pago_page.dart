import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_hidoc/common/shared_widgets/footer.dart';
import 'package:proyecto_hidoc/common/shared_widgets/header_bar.dart';
import 'package:proyecto_hidoc/common/shared_widgets/payment_summary_card.dart';
import 'package:proyecto_hidoc/features/user/widgets/footer_user.dart';
import 'package:proyecto_hidoc/common/shared_widgets/theme_toggle_button.dart';
import 'package:proyecto_hidoc/features/user/pages/pago_exitoso_page.dart';

enum PaymentKind { consulta, membresia }

enum PayMethod { card, tigo }

class PagoPage extends StatefulWidget {
  static const String name = 'Pago';

  final String concept; // Ej: "Consulta médica" o "Membresía Premium"
  final double amount; // Ej: 8.0
  final PaymentKind kind; // consulta | membresia
  final Duration holdTime; // tiempo para pagar (countdown)

  const PagoPage({
    super.key,
    required this.concept,
    required this.amount,
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
  final ctrlExp = TextEditingController();
  final ctrlCvv = TextEditingController();
  final ctrlName = TextEditingController(text: 'Juan Pérez');

  @override
  void initState() {
    super.initState();
    remaining = widget.holdTime;

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }

      if (remaining.inSeconds <= 1) {
        setState(() => remaining = Duration.zero);
        t.cancel();
      } else {
        setState(() {
          remaining = Duration(seconds: remaining.inSeconds - 1);
        });
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

  String _mmss(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(1, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String _money(double v) => '\$${v.toStringAsFixed(2)}';

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
        icon: Icons.payment_rounded,
        onBack: () {
          if (context.canPop()) context.pop();
        },
        actions: [ThemeToggleButton()],
      ),

      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 96),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner de tiempo
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 14,
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 12, 171, 168),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.green.shade700.withOpacity(.5),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tiempo restante para pagar la ${widget.kind == PaymentKind.consulta ? 'cita' : 'membresía'}:',
                        style: tt.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _mmss(remaining),
                        style: tt.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Resumen de pago reutilizable
                PaymentSummaryCard(
                  title: 'Resumen del Pago',
                  lines: [
                    PaymentLine(
                      label: widget.concept,
                      value: _money(widget.amount),
                      bold: true,
                    ),
                    PaymentLine.divider(),
                  ],
                  totalLabel: 'Total',
                  totalValue: totalFormatted,
                ),
                const SizedBox(height: 16),

                // Método de pago
                Text(
                  'Método de Pago',
                  style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),

                // Selección
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
                      const Divider(height: 0),
                      RadioListTile<PayMethod>(
                        value: PayMethod.tigo,
                        groupValue: method,
                        onChanged: (v) => setState(() => method = v!),
                        title: const Text('Tigo Money'),
                        secondary: const Icon(
                          Icons.account_balance_wallet_rounded,
                        ),
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
                      const Icon(
                        Icons.verified_user_rounded,
                        size: 20,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Tu información está protegida con cifrado de seguridad.',
                          style: tt.bodyMedium?.copyWith(
                            color: Colors.green.shade800,
                          ),
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
                    onPressed: remaining == Duration.zero
                        ? null
                        : () {
                            if (method == PayMethod.card &&
                                !(formKey.currentState?.validate() ?? false)) {
                              return;
                            }
                            // Demo: redirigir a confirmación
                            context.goNamed(
                              PagoExitosoPage.name,
                              queryParameters: {
                                'concept': widget.concept,
                                'amount': widget.amount.toString(),
                                'doctor':
                                    'Dra. Elena Martinez', // TODO: pasar el real
                                'id': 'CITA-000123', // TODO: id real de la cita
                                'metodo': method == PayMethod.card
                                    ? 'Tarjeta **** 3456'
                                    : 'Tigo Money',
                              },
                            );
                          },
                    child: Text('Pagar \$${widget.amount.toStringAsFixed(2)}'),
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

  const _CardForm({
    required this.formKey,
    required this.ctrlCard,
    required this.ctrlExp,
    required this.ctrlCvv,
    required this.ctrlName,
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
          Text(
            'Información de tarjeta',
            style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),

          TextFormField(
            controller: ctrlCard,
            keyboardType: TextInputType.number,
            decoration: deco('Número de Tarjeta', hint: '1234 5678 9012 3456'),
            validator: (v) =>
                (v == null || v.trim().length < 12) ? 'Número inválido' : null,
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: ctrlExp,
                  keyboardType: TextInputType.datetime,
                  decoration: deco('Fecha de Vencimiento', hint: 'MM/AA'),
                  validator: (v) =>
                      (v == null || !RegExp(r'^\d{2}/\d{2}$').hasMatch(v))
                      ? 'Fecha inválida'
                      : null,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: ctrlCvv,
                  keyboardType: TextInputType.number,
                  decoration: deco('CVV', hint: '123'),
                  validator: (v) =>
                      (v == null || v.length < 3) ? 'CVV inválido' : null,
                  obscureText: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          TextFormField(
            controller: ctrlName,
            textCapitalization: TextCapitalization.words,
            decoration: deco('Nombre en la Tarjeta', hint: 'Juana Pérez'),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Ingrese el nombre' : null,
          ),
        ],
      ),
    );
  }
}
