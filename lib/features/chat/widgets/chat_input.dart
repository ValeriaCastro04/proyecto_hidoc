import 'package:flutter/material.dart';

/// Widget para el input de mensajes en el chat médico
/// 
/// Características:
/// - Campo de texto con placeholder personalizado
/// - Botón de adjuntar archivo (clip)
/// - Botón de cámara para fotos
/// - Botón de enviar con ícono de flecha
/// - Callbacks para manejar las diferentes acciones
class ChatInput extends StatefulWidget {
  /// Callback que se ejecuta cuando se envía un mensaje
  final Function(String message)? onSendMessage;
  
  /// Callback que se ejecuta cuando se presiona adjuntar archivo
  final VoidCallback? onAttachFile;
  
  /// Callback que se ejecuta cuando se presiona el botón de cámara
  final VoidCallback? onTakePhoto;
  
  /// Texto del placeholder que aparece en el campo de entrada
  final String placeholder;

  const ChatInput({
    Key? key,
    this.onSendMessage,
    this.onAttachFile,
    this.onTakePhoto,
    this.placeholder = "Escribe tu mensaje...",
  }) : super(key: key);

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  /// Controlador para manejar el texto del campo de entrada
  final TextEditingController _messageController = TextEditingController();
  
  /// Indica si hay texto en el campo para habilitar/deshabilitar envío
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    // QUÉ HACE: Escucha cambios en el campo de texto para actualizar el estado
    // CÓMO LO HACE: addListener detecta cuando el usuario escribe o borra texto
    // y actualiza _hasText para controlar la UI del botón de enviar
    _messageController.addListener(() {
      setState(() {
        _hasText = _messageController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    // QUÉ HACE: Libera los recursos del controlador al destruir el widget
    // CÓMO LO HACE: dispose() del TextEditingController evita memory leaks
    // al limpiar listeners y referencias cuando el widget se elimina
    _messageController.dispose();
    super.dispose();
  }

  /// Envía el mensaje y limpia el campo de entrada
  void _sendMessage() {
    // QUÉ HACE: Procesa el envío del mensaje si hay contenido válido
    // CÓMO LO HACE: Extrae el texto, ejecuta el callback y limpia el campo
    // solo si hay texto no vacío para evitar mensajes en blanco
    final message = _messageController.text.trim();
    if (message.isNotEmpty && widget.onSendMessage != null) {
      widget.onSendMessage!(message);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // QUÉ HACE: Crea el contenedor principal del input con espaciado y color
      // CÓMO LO HACE: Padding de 16px en todos los lados para márgenes uniformes
      // y fondo blanco para contrastar con el fondo azul del chat
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          // QUÉ HACE: Botón para adjuntar archivos ubicado a la izquierda
          // CÓMO LO HACE: IconButton circular con ícono de clip (attach_file)
          // que ejecuta el callback onAttachFile cuando se presiona
          IconButton(
            onPressed: widget.onAttachFile,
            icon: const Icon(
              Icons.attach_file,
              color: Colors.grey,
              size: 24,
            ),
          ),
          const SizedBox(width: 8),
          
          // QUÉ HACE: Campo de texto expandible que ocupa el espacio disponible
          // CÓMO LO HACE: Expanded hace que el TextField use todo el espacio
          // entre los botones laterales, con decoración personalizada
          Expanded(
            child: TextField(
              controller: _messageController,
              // QUÉ HACE: Configura el comportamiento del teclado y texto
              // CÓMO LO HACE: TextInputAction.send permite enviar con Enter
              // y textCapitalization.sentences capitaliza automáticamente
              textInputAction: TextInputAction.send,
              textCapitalization: TextCapitalization.sentences,
              onSubmitted: (_) => _sendMessage(),
              decoration: InputDecoration(
                // QUÉ HACE: Estiliza la apariencia del campo de texto
                // CÓMO LO HACE: Fondo amarillo, bordes redondeados y sin bordes
                // visibles para lograr el look del diseño de Figma
                hintText: widget.placeholder,
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.yellow[300],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 8),
          
          // QUÉ HACE: Botón de cámara para tomar fotos
          // CÓMO LO HACE: IconButton con ícono de cámara que ejecuta
          // el callback onTakePhoto al ser presionado
          IconButton(
            onPressed: widget.onTakePhoto,
            icon: const Icon(
              Icons.camera_alt,
              color: Colors.grey,
              size: 24,
            ),
          ),
          
          const SizedBox(width: 8),
          
          // QUÉ HACE: Botón de enviar que cambia de apariencia según el estado
          // CÓMO LO HACE: FloatingActionButton mini con color condicional
          // (azul si hay texto, gris si está vacío) y callback de envío
          FloatingActionButton(
            onPressed: _hasText ? _sendMessage : null,
            mini: true,
            backgroundColor: _hasText ? Colors.blue : Colors.grey[300],
            child: Icon(
              Icons.send,
              color: _hasText ? Colors.white : Colors.grey[600],
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget de ejemplo para mostrar cómo usar el ChatInput
/// Útil para testing y desarrollo con callbacks de prueba
class ChatInputExample extends StatefulWidget {
  const ChatInputExample({Key? key}) : super(key: key);

  @override
  State<ChatInputExample> createState() => _ChatInputExampleState();
}

class _ChatInputExampleState extends State<ChatInputExample> {
  /// Lista de mensajes para demostrar la funcionalidad
  List<String> messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // QUÉ HACE: Estructura básica de la pantalla de ejemplo
      // CÓMO LO HACE: AppBar con título y body que muestra los mensajes
      // enviados junto con el ChatInput en la parte inferior
      appBar: AppBar(
        title: const Text('Chat Input Example'),
      ),
      body: Column(
        children: [
          // QUÉ HACE: Muestra la lista de mensajes enviados para testing
          // CÓMO LO HACE: Expanded con ListView para mostrar mensajes previos
          // y permitir scroll si hay muchos mensajes
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(messages[index]),
                );
              },
            ),
          ),
          
          // QUÉ HACE: Input de chat con callbacks funcionales para testing
          // CÓMO LO HACE: ChatInput con callbacks que muestran la funcionalidad
          // real: agregar mensajes a la lista y mostrar SnackBars para acciones
          ChatInput(
            onSendMessage: (message) {
              setState(() {
                messages.add(message);
              });
            },
            onAttachFile: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Adjuntar archivo presionado')),
              );
            },
            onTakePhoto: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cámara presionada')),
              );
            },
          ),
        ],
      ),
    );
  }
}