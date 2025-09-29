import 'package:flutter/material.dart';

/// Widget para mostrar burbujas de mensajes en el chat médico
/// 
/// Características:
/// - Mensajes del doctor: burbuja gris alineada a la izquierda
/// - Mensajes del paciente: burbuja azul alineada a la derecha
/// - Incluye timestamp en cada mensaje
/// - Responsive: se adapta al contenido del mensaje
class ChatMessageBubble extends StatelessWidget {
  /// Contenido del mensaje a mostrar
  final String message;
  
  /// Hora del mensaje en formato HH:mm (ej: "10:30")
  final String time;
  
  /// Define si el mensaje es del doctor (true) o del paciente (false)
  final bool isFromDoctor;

  const ChatMessageBubble({
    Key? key,
    required this.message,
    required this.time,
    required this.isFromDoctor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      // QUÉ HACE: Crea espaciado exterior para separar mensajes entre sí
      // CÓMO LO HACE: Aplica 16px horizontal para márgenes laterales
      // y 4px vertical para separación entre burbujas consecutivas
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        // QUÉ HACE: Alinea la burbuja según el remitente del mensaje
        // CÓMO LO HACE: MainAxisAlignment.start para doctor (izquierda)
        // y MainAxisAlignment.end para paciente (derecha)
        mainAxisAlignment: isFromDoctor 
            ? MainAxisAlignment.start 
            : MainAxisAlignment.end,
        children: [
          Flexible(
            // QUÉ HACE: Permite que la burbuja se adapte al contenido del mensaje
            // CÓMO LO HACE: Flexible envuelve el Container para que no ocupe
            // todo el ancho disponible sino solo el espacio necesario
            child: Container(
              // QUÉ HACE: Define el espaciado interno de la burbuja
              // CÓMO LO HACE: 16px horizontal y 12px vertical para crear
              // el "relleno" interno entre el borde y el contenido
              padding: const EdgeInsets.symmetric(
                horizontal: 16, 
                vertical: 12
              ),
              decoration: BoxDecoration(
                // QUÉ HACE: Estiliza la apariencia visual de la burbuja
                // CÓMO LO HACE: Color condicional (gris/azul) y BorderRadius
                // de 16px para crear la forma redondeada característica
                color: isFromDoctor 
                    ? Colors.grey[200] 
                    : Colors.blue,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                // QUÉ HACE: Organiza verticalmente el mensaje y el timestamp
                // CÓMO LO HACE: CrossAxisAlignment.start alinea a la izquierda
                // y MainAxisSize.min ocupa solo el espacio vertical necesario
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // QUÉ HACE: Muestra el contenido principal del mensaje
                  // CÓMO LO HACE: Text widget con tamaño 16 y color condicional
                  // (negro para doctor, blanco para paciente)
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 16,
                      color: isFromDoctor 
                          ? Colors.black87 
                          : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // QUÉ HACE: Muestra la hora del mensaje de forma discreta
                  // CÓMO LO HACE: Text más pequeño (12px) con colores tenues
                  // para que sea menos prominente que el mensaje principal
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 12,
                      color: isFromDoctor 
                          ? Colors.grey[600] 
                          : Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget de ejemplo para mostrar cómo usar las burbujas de mensaje
/// Útil para testing y desarrollo con datos de prueba del Figma
class ChatMessagesExample extends StatelessWidget {
  const ChatMessagesExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // QUÉ HACE: Establece el fondo de la pantalla del chat
      // CÓMO LO HACE: Colors.blue[100] crea un azul muy claro
      // que simula el ambiente visual del diseño de Figma
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        title: const Text('Chat Messages'),
      ),
      body: Column(
        children: [
          // QUÉ HACE: Simula una conversación médica real
          // CÓMO LO HACE: Serie de ChatMessageBubble con isFromDoctor
          // alternando para mostrar el flujo de conversación típico
          const ChatMessageBubble(
            message: "Hola, soy el Dr. López. ¿En qué puedo ayudarte hoy?",
            time: "10:30",
            isFromDoctor: true,
          ),
          const ChatMessageBubble(
            message: "Hola doctor, he tenido dolor de cabeza frecuente los últimos días.",
            time: "10:31",
            isFromDoctor: false,
          ),
          const ChatMessageBubble(
            message: "Entiendo. ¿Podrías describirme mejor el tipo de dolor? ¿Es pulsátil, constante, o viene y va?",
            time: "10:32",
            isFromDoctor: true,
          ),
        ],
      ),
    );
  }
}