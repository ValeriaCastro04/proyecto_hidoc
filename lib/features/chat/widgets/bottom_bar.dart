import 'package:flutter/material.dart';

/// Widget para la barra de acciones inferior del chat médico
/// 
/// Características:
/// - Tres botones principales: Receta, Adjuntar, Finalizar
/// - Botones Receta y Adjuntar: estilo outline con borde azul
/// - Botón Finalizar: estilo filled con fondo verde
/// - Bordes redondeados y espaciado uniforme
/// - Callbacks individuales para cada acción
class BottomActionBar extends StatelessWidget {
  /// Callback que se ejecuta al presionar el botón Receta
  final VoidCallback? onRecetaPressed;
  
  /// Callback que se ejecuta al presionar el botón Adjuntar
  final VoidCallback? onAdjuntarPressed;
  
  /// Callback que se ejecuta al presionar el botón Finalizar
  final VoidCallback? onFinalizarPressed;
  
  /// Color del borde y texto para botones outline (Receta y Adjuntar)
  final Color outlineColor;
  
  /// Color de fondo del botón Finalizar
  final Color finalizarColor;
  
  /// Color del texto del botón Finalizar
  final Color finalizarTextColor;
  
  /// Texto del botón Receta
  final String recetaText;
  
  /// Texto del botón Adjuntar
  final String adjuntarText;
  
  /// Texto del botón Finalizar
  final String finalizarText;

  const BottomActionBar({
    Key? key,
    this.onRecetaPressed,
    this.onAdjuntarPressed,
    this.onFinalizarPressed,
    this.outlineColor = Colors.blue,
    this.finalizarColor = Colors.green,
    this.finalizarTextColor = Colors.white,
    this.recetaText = "Receta",
    this.adjuntarText = "Adjuntar",
    this.finalizarText = "Finalizar",
  }) : super(key: key);

  /// Construye un botón con estilo outline (borde visible, fondo transparente)
  Widget _buildOutlineButton({
    required String text,
    required VoidCallback? onPressed,
    required Color borderColor,
  }) {
    return Expanded(
      // QUÉ HACE: Crea un botón con estilo de borde para acciones secundarias
      // CÓMO LO HACE: OutlinedButton con bordes redondeados, color de borde personalizado
      // y texto del mismo color del borde para mantener coherencia visual
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: borderColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: borderColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  /// Construye un botón con estilo filled (fondo sólido)
  Widget _buildFilledButton({
    required String text,
    required VoidCallback? onPressed,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return Expanded(
      // QUÉ HACE: Crea un botón con fondo sólido para la acción principal
      // CÓMO LO HACE: ElevatedButton con color de fondo personalizado, bordes redondeados
      // y texto blanco para crear contraste y destacar la acción más importante
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // QUÉ HACE: Crea el contenedor principal de la barra de acciones
      // CÓMO LO HACE: Padding de 16px en todos los lados para espaciado uniforme,
      // fondo blanco y sombra sutil para separar visualmente del contenido
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        // QUÉ HACE: Asegura que los botones no se superpongan con elementos del sistema
        // CÓMO LO HACE: SafeArea ajusta automáticamente el padding inferior
        // para evitar interferencias con indicadores de home y gestos del sistema
        top: false,
        child: Row(
          children: [
            // QUÉ HACE: Botón "Receta" con estilo outline para prescripciones médicas
            // CÓMO LO HACE: _buildOutlineButton con texto personalizable y callback
            // para manejar la creación o visualización de recetas médicas
            _buildOutlineButton(
              text: recetaText,
              onPressed: onRecetaPressed,
              borderColor: outlineColor,
            ),
            
            const SizedBox(width: 12),
            
            // QUÉ HACE: Botón "Adjuntar" con estilo outline para añadir archivos
            // CÓMO LO HACE: _buildOutlineButton que permite adjuntar documentos,
            // imágenes o cualquier archivo relevante para la consulta médica
            _buildOutlineButton(
              text: adjuntarText,
              onPressed: onAdjuntarPressed,
              borderColor: outlineColor,
            ),
            
            const SizedBox(width: 12),
            
            // QUÉ HACE: Botón "Finalizar" con estilo filled como acción principal
            // CÓMO LO HACE: _buildFilledButton con fondo verde que indica
            // la finalización exitosa de la consulta médica
            _buildFilledButton(
              text: finalizarText,
              onPressed: onFinalizarPressed,
              backgroundColor: finalizarColor,
              textColor: finalizarTextColor,
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget de ejemplo para mostrar cómo usar el BottomActionBar
/// Útil para testing y desarrollo con callbacks de prueba
class BottomActionBarExample extends StatelessWidget {
  const BottomActionBarExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // QUÉ HACE: Estructura básica para demostrar la barra de acciones
      // CÓMO LO HACE: AppBar con título, body con contenido simulado
      // y BottomActionBar posicionada en la parte inferior
      appBar: AppBar(
        title: const Text('Bottom Action Bar'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      backgroundColor: Colors.blue[100],
      body: Column(
        children: [
          // QUÉ HACE: Área de contenido simulada para mostrar el contexto de uso
          // CÓMO LO HACE: Expanded con contenido centrado que simula
          // el área principal de la aplicación donde va el chat
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.medical_services,
                    size: 80,
                    color: Colors.blue,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Consulta Médica',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Área principal del chat médico.\nLas acciones están disponibles abajo.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // QUÉ HACE: Barra de acciones con callbacks funcionales para testing
          // CÓMO LO HACE: BottomActionBar configurada con callbacks que muestran
          // SnackBars para demostrar la funcionalidad de cada botón
          BottomActionBar(
            onRecetaPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Crear receta médica'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            onAdjuntarPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Adjuntar archivo o documento'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            onFinalizarPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Finalizando consulta médica'),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}