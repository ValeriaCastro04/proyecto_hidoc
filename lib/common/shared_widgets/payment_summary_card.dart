import 'package:flutter/material.dart';

class PaymentLine {
  final String label;
  final String value;        // ya formateado (p.ej. $8.00)
  final bool bold;
  final bool isDivider;

  const PaymentLine({
    this.label = '',
    this.value = '',
    this.bold = false,
    this.isDivider = false,
  });

  factory PaymentLine.divider() => const PaymentLine(isDivider: true);
}

class PaymentSummaryCard extends StatelessWidget {
  final String title;
  final List<PaymentLine> lines;
  final String totalLabel;
  final String totalValue;
  final IconData leadingIcon;

  const PaymentSummaryCard({
    super.key,
    required this.title,
    required this.lines,
    required this.totalLabel,
    required this.totalValue,
    this.leadingIcon = Icons.receipt_long_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outline.withOpacity(.15)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.06), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado
            Row(
              children: [
                Icon(leadingIcon, color: cs.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Items
            ...lines.map((l) {
              if (l.isDivider) return const Divider(height: 20);
              final style = (l.bold ? tt.titleSmall : tt.bodyMedium);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(l.label, style: style),
                    ),
                    const SizedBox(width: 12),
                    Text(l.value, style: style),
                  ],
                ),
              );
            }),

            const SizedBox(height: 6),
            // Total
            Row(
              children: [
                Expanded(
                  child: Text(
                    totalLabel,
                    style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
                Text(
                  totalValue,
                  style: tt.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: cs.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}