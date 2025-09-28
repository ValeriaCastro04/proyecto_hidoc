import 'package:flutter/material.dart';

/// Widget para el header del chat médico
/// 
/// Características:
/// - Avatar circular con iniciales del doctor
/// - Nombre del doctor y status de conexión
/// - Botones de acción: llamada, video y menú
/// - Botón de regreso para navegación
/// - Status "En línea" con indicador verde
class ChatHeader extends StatelessWidget {
  /// Nombre completo del doctor a mostrar
  final String doctorName;
  
  /// Iniciales del doctor para el avatar (ej: "DL")
  final String doctorInitials;
  
  /// Indica si el doctor está en línea
  final bool isOnline;
  
  /// Color de fondo del avatar
  final Color avatarColor;
  
  /// Callback que se ejecuta al presionar el botón de regreso
  final VoidCallback? onBackPressed;
  
  /// Callback que se ejecuta al presionar el botón de llamada
  final VoidCallback? onCallPressed;
  
  /// Callback que se ejecuta al presionar el botón de video
  final VoidCallback? onVideoPressed;
  
  /// Callback que se ejecuta al presionar el menú (3 puntos)
  final VoidCallback? onMenuPressed;

  const ChatHeader({
    Key? key,
    required this.doctorName,
    required this.doctorInitials,
    this.isOnline = true,
    this.avatarColor = Colors.blue,
    this.onBackPressed,
    this.onCallPressed,
    this.onVideoPressed,
    this.onMenuPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // QUÉ HACE: Crea el contenedor principal del header con espaciado y color
      // CÓMO LO HACE: Padding vertical de 16px para altura adecuada, horizontal de 8px
      // y color blanco para contrastar con el contenido del chat
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      color: Colors.white,
      child: SafeArea(
        // QUÉ HACE: Evita que el contenido se superponga con elementos del sistema
        // CÓMO LO HACE: SafeArea ajusta automáticamente el contenido para evitar
        // interferencias con la barra de estado y notch en diferentes dispositivos
        bottom: false,
        child: Row(
          children: [
            // QUÉ HACE: Botón de navegación hacia atrás ubicado en el extremo izquierdo
            // CÓMO LO HACE: IconButton con flecha hacia atrás que ejecuta el callback
            // onBackPressed o navega automáticamente si no se especifica callback
            IconButton(
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black87,
                size: 24,
              ),
            ),
            
            const SizedBox(width: 8),
            
            // QUÉ HACE: Avatar circular con las iniciales del doctor
            // CÓMO LO HACE: CircleAvatar con color de fondo personalizable
            // y texto blanco centrado con las iniciales del doctor
            CircleAvatar(
              radius: 24,
              backgroundColor: avatarColor,
              child: Text(
                doctorInitials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            const SizedBox(width: 12),
            
            // QUÉ HACE: Sección expandible con información del doctor
            // CÓMO LO HACE: Expanded permite que esta sección ocupe todo el espacio
            // disponible entre el avatar y los botones de acción
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // QUÉ HACE: Muestra el nombre del doctor con estilo prominente
                  // CÓMO LO HACE: Text con fontSize 18, peso bold y color negro
                  // para que sea el elemento más visible de la información
                  Text(
                    doctorName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 2),
                  
                  // QUÉ HACE: Indicador visual del status de conexión del doctor
                  // CÓMO LO HACE: Row con Container circular verde y texto condicional
                  // que muestra "En línea" o "Desconectado" según el estado
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isOnline ? Colors.green : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isOnline ? 'En línea' : 'Desconectado',
                        style: TextStyle(
                          fontSize: 14,
                          color: isOnline ? Colors.green : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // QUÉ HACE: Sección de botones de acción alineados horizontalmente
            // CÓMO LO HACE: Row con IconButtons para llamada, video y menú
            // cada uno con su respectivo callback y espaciado uniforme
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Botón de llamada telefónica
                IconButton(
                  onPressed: onCallPressed,
                  icon: const Icon(
                    Icons.phone,
                    color: Colors.black54,
                    size: 24,
                  ),
                ),
                
                // Botón de videollamada
                IconButton(
                  onPressed: onVideoPressed,
                  icon: const Icon(
                    Icons.videocam,
                    color: Colors.black54,
                    size: 24,
                  ),
                ),
                
                // Botón de menú opciones
                IconButton(
                  onPressed: onMenuPressed,
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.black54,
                    size: 24,
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

/// Widget de ejemplo para mostrar cómo usar el ChatHeader
/// Útil para testing y desarrollo con callbacks de prueba
class ChatHeaderExample extends StatelessWidget {
  const ChatHeaderExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // QUÉ HACE: Estructura básica para mostrar el ChatHeader en acción
      // CÓMO LO HACE: Body con Column que incluye el header y un área de contenido
      // simulando cómo se vería en la aplicación real
      body: Column(
        children: [
          // QUÉ HACE: Header del chat con datos de ejemplo del Dr. López
          // CÓMO LO HACE: ChatHeader configurado con los datos del Figma
          // y callbacks que muestran SnackBars para demostrar funcionalidad
          ChatHeader(
            doctorName: "Dr. López",
            doctorInitials: "DL",
            isOnline: true,
            avatarColor: Colors.blue,
            onBackPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Botón de regreso presionado')),
              );
            },
            onCallPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Iniciando llamada...')),
              );
            },
            onVideoPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Iniciando videollamada...')),
              );
            },
            onMenuPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Menú de opciones')),
              );
            },
          ),
          
          // QUÉ HACE: Área de contenido simulada para mostrar el header en contexto
          // CÓMO LO HACE: Expanded con Container que simula el área del chat
          // con color de fondo azul claro como en el diseño original
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.blue[100],
              child: const Center(
                child: Text(
                  'Área del chat\n(Aquí irían los mensajes)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}