import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:proyecto_hidoc/common/shared_widgets/header_bar.dart';
import 'package:proyecto_hidoc/common/shared_widgets/theme_toggle_button.dart';
import 'package:proyecto_hidoc/common/shared_widgets/gradient_background.dart';
import 'package:proyecto_hidoc/common/shared_widgets/payment_summary_card.dart';
import 'package:proyecto_hidoc/common/shared_widgets/footer.dart';
import 'package:proyecto_hidoc/features/user/widgets/footer_user.dart';

class PagoExitosoPage extends StatelessWidget {
  static const String name = 'PagoExitoso';

  final String concept;        // ej: "Consulta médica"
  final double amount;         // ej: 8.0
  final String doctorName;     // ej: "Dr. María López"
  final String appointmentId;  // ej: "CITA-001234"
  final String? metodo;        // ej: "Tarjeta **** 3456"

  const PagoExitosoPage({
    super.key,
    required this.concept,
    required this.amount,
    required this.doctorName,
    required this.appointmentId,
    this.metodo,
  });

  String _money(double v) => '\$${v.toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: HeaderBar.category(
        title: 'Pago realizado',
        subtitle: '¡Tu consulta fue activada con éxito!',
        icon: Icons.verified_rounded,
        fallbackPath: '/consultas',
        actions: const [ThemeToggleButton()],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: GradientBackground(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 96),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner de éxito
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(.10),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.green.withOpacity(.35)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.green.withOpacity(.12),
                        child: const Icon(Icons.check_rounded, color: Colors.green),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('¡Pago confirmado!',
                              style: tt.titleMedium?.copyWith(
                                color: Colors.green.shade800,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Tu consulta con $doctorName está lista para iniciar.',
                              style: tt.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _money(amount),
                        style: tt.titleMedium?.copyWith(
                          color: cs.primary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Resumen de pago reutilizable
                PaymentSummaryCard(
                  title: 'Resumen del Pago',
                  lines: [
                    PaymentLine(label: concept, value: _money(amount), bold: true),
                    if (metodo != null && metodo!.isNotEmpty)
                      PaymentLine(label: 'Método', value: metodo!),
                    PaymentLine(label: 'Doctor', value: doctorName),
                    PaymentLine(label: 'ID de consulta', value: appointmentId),
                    PaymentLine.divider(),
                  ],
                  totalLabel: 'Total',
                  totalValue: _money(amount),
                  leadingIcon: Icons.receipt_long_rounded,
                ),
                const SizedBox(height: 16),

                // Siguientes pasos
                _SectionCard(
                  title: '¿Qué sigue?',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      _StepRow(index: 1, text: 'El doctor ha sido notificado.'),
                      SizedBox(height: 8),
                      _StepRow(index: 2, text: 'Puedes iniciar tu consulta por chat, llamada o videollamada.'),
                      SizedBox(height: 8),
                      _StepRow(index: 3, text: 'Si el doctor no responde en 5 min, podrás reprogramar o solicitar reembolso (demo).'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Acciones
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (){
                      context.push('/chat', extra: {
                        'doctorId': 'dr_001',
                        'doctorName': 'Dr Lopez',
                        'doctorInitials': 'Dr L',
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat, color: Colors.white),
                        SizedBox(width: 8,),
                        Text(
                          'Iniciar consulta ahora',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          )
                        )
                      ]
                    )
                    )
                ),
                const SizedBox(height: 10),
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

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outline.withOpacity(.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: tt.titleMedium?.copyWith(
              color: cs.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  final int index;
  final String text;
  const _StepRow({required this.index, required this.text});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$index. ', style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
        Expanded(child: Text(text, style: tt.bodyMedium)),
      ],
    );
  }
}