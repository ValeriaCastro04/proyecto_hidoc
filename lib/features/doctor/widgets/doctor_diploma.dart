import 'package:flutter/material.dart';

class DiplomasTab extends StatelessWidget {
  final List<dynamic> diplomas;

  const DiplomasTab({super.key, required this.diplomas});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (diplomas.isEmpty) {
      return Center(
        child: Text(
          "No hay diplomas registrados",
          style: TextStyle(color: colors.onSurfaceVariant),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Diplomas",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...diplomas.map((diploma) {
          return ListTile(
            leading: const Icon(Icons.school, color: Colors.blue),
            title: Text(diploma['title']),
            subtitle: Text("${diploma['institution']}, ${diploma['year']}"),
          );
        }).toList(),
      ],
    );
  }
}
