import 'package:flutter/material.dart';
import 'package:proyecto_hidoc/common/shared_widgets/theme_toggle_button.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_hidoc/providers/chat_provider.dart';

import 'package:proyecto_hidoc/common/shared_widgets/theme_toggle_button.dart';

// Importaciones de los widgets que ya creamos
// Nota: En tu proyecto real, asegúrate de importar estos widgets desde sus archivos correspondientes:
// import 'package:tu_app/features/chat/widgets/chat_header.dart';
// import 'package:tu_app/features/chat/widgets/chat_tab_navigator.dart';
// import 'package:tu_app/features/chat/widgets/message_list.dart';
// import 'package:tu_app/features/chat/widgets/chat_input.dart';
// import 'package:tu_app/features/chat/widgets/bottom_action_bar.dart';

/// Pantalla completa del chat médico para el paciente
/// 
/// Características específicas del paciente:
/// - Header con información del doctor y status "En línea"
/// - Tabs: Chat, Video, Notas (3 tabs)
/// - Lista de mensajes con burbujas diferenciadas
/// - Input para escribir y enviar mensajes
/// - Bottom bar: Receta, Adjuntar, Finalizar
/// - Manejo completo del estado de la conversación
class PatientChatScreen extends StatefulWidget {
  /// ID del doctor con quien se está conversando
  final String doctorId;
  
  /// Nombre del doctor
  final String doctorName;
  
  /// Iniciales del doctor para el avatar
  final String doctorInitials;
  
  /// Indica si el doctor está en línea
  final bool isDoctorOnline;

  const PatientChatScreen({
    Key? key,
    required this.doctorId,
    required this.doctorName,
    required this.doctorInitials,
    this.isDoctorOnline = true,
  }) : super(key: key);

  @override
  State<PatientChatScreen> createState() => _PatientChatScreenState();
}

class _PatientChatScreenState extends State<PatientChatScreen> {
  /// Tab actualmente seleccionado en el navegador
  ChatTab _selectedTab = ChatTab.chat;
  
  /// Lista de mensajes de la conversación
  List<ChatMessage> _messages = [];
  
  /// Indica si se están cargando más mensajes
  bool _isLoadingMessages = false;
  
  /// Indica si se está enviando un mensaje
  bool _isSendingMessage = false;

  @override
  void initState() {
    super.initState();
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.connect(1);

    chatProvider.addListener(() {
      setState(() {});
    });
  }

  /// Inicializa el chat con mensajes de ejemplo
  void _initializeChat() {
    // QUÉ HACE: Carga los mensajes iniciales de la conversación médica
    // CÓMO LO HACE: Añade mensajes de ejemplo que simulan una consulta real
    // entre el paciente y el Dr. López, como se ve en el diseño de Figma
    setState(() {
      _messages = [
        ChatMessage(
          id: '1',
          message: 'Hola, soy el Dr. ${widget.doctorName}. ¿En qué puedo ayudarte hoy?',
          time: '10:30',
          isFromDoctor: true,
        ),
        ChatMessage(
          id: '2',
          message: 'Hola doctor, he tenido dolor de cabeza frecuente los últimos días.',
          time: '10:31',
          isFromDoctor: false,
        ),
        ChatMessage(
          id: '3',
          message: 'Entiendo. ¿Podrías describirme mejor el tipo de dolor? ¿Es pulsátil, constante, o viene y va?',
          time: '10:32',
          isFromDoctor: true,
        ),
      ];
    });
  }

  /// Maneja el envío de nuevos mensajes del paciente
  void _sendMessage(String messageText) async {
    // QUÉ HACE: Procesa el envío de un mensaje del paciente al doctor
    // CÓMO LO HACE: Añade el mensaje a la lista, simula estado de envío
    // y genera una respuesta automática del doctor para demo
    if (messageText.trim().isEmpty) return;

    setState(() {
      _isSendingMessage = true;
    });

    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.sendMessage(
      1, // ID del paciente (temporal)
      int.parse(widget.doctorId), // ID del doctor (viene del widget)
      messageText,
    );

    // Añadir mensaje del paciente
    //final newMessage = ChatMessage(
    //  id: DateTime.now().millisecondsSinceEpoch.toString(),
    //  message: messageText,
    //  time: _getCurrentTime(),
    //  isFromDoctor: false,
    //);

    //setState(() {
    //  _messages.add(newMessage);
    //});

    // Simular respuesta del doctor después de un delay
    //await Future.delayed(const Duration(seconds: 2));
    
    //_simulateDoctorResponse(messageText);
    
    setState(() {
      _isSendingMessage = false;
    });
  }

  /// Simula una respuesta automática del doctor
  //void _simulateDoctorResponse(String patientMessage) {
    // QUÉ HACE: Genera respuestas automáticas del doctor para simular conversación
    // CÓMO LO HACE: Analiza el mensaje del paciente y proporciona respuestas
    // médicas apropiadas para mantener el flujo de la conversación demo
  //  String doctorResponse;
    
  //  if (patientMessage.toLowerCase().contains('dolor')) {
  //    doctorResponse = 'Entiendo tu preocupación. ¿Desde cuándo comenzó este dolor y en qué situaciones empeora?';
  //  } else if (patientMessage.toLowerCase().contains('gracias')) {
  //    doctorResponse = 'De nada. ¿Hay algo más en lo que pueda ayudarte hoy?';
  //  } else {
  //    doctorResponse = 'Gracias por la información. Esto me ayuda a entender mejor tu situación.';
  //  }

  //  final doctorMessage = ChatMessage(
  //    id: DateTime.now().millisecondsSinceEpoch.toString(),
  //    message: doctorResponse,
  //    time: _getCurrentTime(),
  //    isFromDoctor: true,
  //  );

  //  setState(() {
  //    _messages.add(doctorMessage);
  //  });
  //}

  /// Obtiene la hora actual en formato HH:mm
  //String _getCurrentTime() {
    // QUÉ HACE: Genera timestamp actual para los mensajes nuevos
    // CÓMO LO HACE: DateTime.now() formateado a HH:mm para mostrar
    // la hora exacta de envío de cada mensaje
  //  final now = DateTime.now();
  //  return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  //}

  /// Maneja la carga de mensajes anteriores
  void _loadMoreMessages() {
    // QUÉ HACE: Simula la carga de mensajes anteriores de la conversación
    // CÓMO LO HACE: Añade mensajes ficticios al inicio de la lista
    // para simular el historial de chat que se cargaría desde el servidor
    if (_isLoadingMessages) return;

    setState(() {
      _isLoadingMessages = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      final oldMessages = [
        ChatMessage(
          id: 'old_${_messages.length + 1}',
          message: 'Este es un mensaje anterior de la conversación.',
          time: '09:${55 - _messages.length}',
          isFromDoctor: _messages.length % 2 == 0,
        ),
      ];

      setState(() {
        _messages.insertAll(0, oldMessages);
        _isLoadingMessages = false;
      });
    });
  }

  /// Maneja las acciones del bottom action bar
  void _handleBottomAction(String action) {
    // QUÉ HACE: Procesa las acciones de los botones inferiores del paciente
    // CÓMO LO HACE: Switch statement que ejecuta diferentes funciones
    // según el botón presionado (Receta, Adjuntar, Finalizar)
    switch (action) {
      case 'receta':
        _showRecetaDialog();
        break;
      case 'adjuntar':
        _handleAttachFile();
        break;
      case 'finalizar':
        _handleFinishConsultation();
        break;
    }
  }

  /// Muestra el diálogo de recetas médicas
  void _showRecetaDialog() {
    // QUÉ HACE: Presenta las recetas médicas disponibles para el paciente
    // CÓMO LO HACE: showDialog con una lista de recetas que el doctor
    // ha prescrito durante la consulta actual
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Recetas Médicas'),
        content: const Text('Aquí se mostrarían las recetas prescritas por el doctor durante esta consulta.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  /// Maneja la funcionalidad de adjuntar archivos
  void _handleAttachFile() {
    // QUÉ HACE: Permite al paciente adjuntar documentos, imágenes o archivos
    // CÓMO LO HACE: Muestra opciones para seleccionar diferentes tipos
    // de archivos relevantes para la consulta médica
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Adjuntar archivo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('Foto de galería'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Tomar foto'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.insert_drive_file),
              title: const Text('Documento'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  /// Maneja la finalización de la consulta
  void _handleFinishConsultation() {
    // QUÉ HACE: Procesa el cierre de la consulta médica por parte del paciente
    // CÓMO LO HACE: Muestra confirmación y ejecuta acciones de cierre
    // como guardar el historial y regresar a la pantalla anterior
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Finalizar Consulta'),
        content: const Text('¿Estás seguro de que deseas finalizar esta consulta médica?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cerrar diálogo
              Navigator.of(context).pop(); // Volver a pantalla anterior
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Finalizar'),
          ),
        ],
      ),
    );
  }

  /// Construye el contenido según el tab seleccionado
  Widget _buildTabContent() {
    // QUÉ HACE: Retorna el contenido apropiado según el tab activo
    // CÓMO LO HACE: Switch statement que evalúa _selectedTab y construye
    // el widget correspondiente (chat, video, notas)
    switch (_selectedTab) {
      case ChatTab.chat:
        return MessageList(
          messages: _messages,
          isLoading: _isLoadingMessages,
          onLoadMore: _loadMoreMessages,
        );
      case ChatTab.video:
        return _buildVideoContent();
      case ChatTab.notas:
        return _buildNotasContent();
    }
  }

  /// Construye el contenido de la sección de video
  Widget _buildVideoContent() {
    // QUÉ HACE: Muestra la interfaz de videollamadas médicas
    // CÓMO LO HACE: Container con información sobre videollamadas
    // y botones para iniciar llamadas con el doctor
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.videocam, size: 80, color: Colors.blue),
          const SizedBox(height: 20),
          const Text(
            'Videollamada',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            'Conecta con ${widget.doctorName} mediante videollamada',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () {
              // Implementar lógica de videollamada
            },
            icon: const Icon(Icons.video_call),
            label: const Text('Iniciar videollamada'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
          ),
        ],
      ),
    );
  }

  /// Construye el contenido de la sección de notas
  Widget _buildNotasContent() {
    // QUÉ HACE: Muestra las notas médicas de la consulta actual
    // CÓMO LO HACE: Lista de notas que el doctor ha tomado durante
    // la consulta y que el paciente puede revisar
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            'Notas Médicas',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                _buildNotaCard('Síntomas reportados', 'Dolor de cabeza frecuente en los últimos días'),
                _buildNotaCard('Observaciones', 'Dolor constante, empeora con estrés'),
                _buildNotaCard('Recomendaciones', 'Descanso, hidratación, seguimiento en 3 días'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Construye una tarjeta individual de nota médica
  Widget _buildNotaCard(String title, String content) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(content),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // QUÉ HACE: Estructura principal de la pantalla del chat del paciente
      // CÓMO LO HACE: Column que organiza verticalmente todos los componentes
      // header, tabs, contenido y acciones en una experiencia cohesiva
      body: Column(
        children: [
          // Header con información del doctor
          ChatHeader(
            doctorName: widget.doctorName,
            doctorInitials: widget.doctorInitials,
            isOnline: widget.isDoctorOnline,
            onBackPressed: () => Navigator.of(context).pop(),
            onCallPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Iniciando llamada...')),
              );
            },
            onVideoPressed: () {
              setState(() {
                _selectedTab = ChatTab.video;
              });
            },
            onMenuPressed: () {
              // Implementar menú de opciones
            },
          ),
          
          // Navegador de tabs
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ChatTabNavigator(
              selectedTab: _selectedTab,
              onTabChanged: (tab) {
                setState(() {
                  _selectedTab = tab;
                });
              },
            ),
          ),
          
          // Contenido principal según tab seleccionado
          Expanded(
            child: _buildTabContent(),
          ),
          
          // Input de chat (solo visible en tab Chat)
          if (_selectedTab == ChatTab.chat)
            ChatInput(
              onSendMessage: _sendMessage,
              onAttachFile: () => _handleBottomAction('adjuntar'),
              onTakePhoto: () {
                // Implementar tomar foto
              },
            ),
          
          // Barra de acciones inferior
          BottomActionBar(
            onRecetaPressed: () => _handleBottomAction('receta'),
            onAdjuntarPressed: () => _handleBottomAction('adjuntar'),
            onFinalizarPressed: () => _handleBottomAction('finalizar'),
          ),
        ],
      ),
    );
  }
}

// ===== CLASES DE DEPENDENCIAS =====
// Estas clases deberían estar en sus archivos correspondientes
// Las incluyo aquí para que el código compile correctamente

enum ChatTab { chat, video, notas }

class ChatMessage {
  final String id;
  final String message;
  final String time;
  final bool isFromDoctor;

  const ChatMessage({
    required this.id,
    required this.message,
    required this.time,
    required this.isFromDoctor,
  });
}

// Widgets simplificados para compilación
class ChatHeader extends StatelessWidget {
  final String doctorName;
  final String doctorInitials;
  final bool isOnline;
  final VoidCallback? onBackPressed;
  final VoidCallback? onCallPressed;
  final VoidCallback? onVideoPressed;
  final VoidCallback? onMenuPressed;

  const ChatHeader({
    Key? key,
    required this.doctorName,
    required this.doctorInitials,
    required this.isOnline,
    this.onBackPressed,
    this.onCallPressed,
    this.onVideoPressed,
    this.onMenuPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            IconButton(
              onPressed: onBackPressed,
              icon: const Icon(Icons.arrow_back),
            ),
            CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(doctorInitials, style: const TextStyle(color: Colors.white)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(doctorName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(isOnline ? 'En línea' : 'Desconectado', 
                       style: TextStyle(color: isOnline ? Colors.green : Colors.grey)),
                ],
              ),
            ),
            IconButton(onPressed: onCallPressed, icon: const Icon(Icons.phone)),
            IconButton(onPressed: onVideoPressed, icon: const Icon(Icons.videocam)),
            IconButton(onPressed: onMenuPressed, icon: const Icon(Icons.more_vert)),
            const ThemeToggleButton(),
          ],
        ),
      ),
    );
  }
}

class ChatTabNavigator extends StatelessWidget {
  final ChatTab selectedTab;
  final Function(ChatTab)? onTabChanged;

  const ChatTabNavigator({
    Key? key,
    required this.selectedTab,
    this.onTabChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: ChatTab.values.map((tab) {
          final isActive = selectedTab == tab;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged?.call(tab),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isActive ? Colors.yellow[300] : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    tab.name.toUpperCase(),
                    style: TextStyle(
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class MessageList extends StatelessWidget {
  final List<ChatMessage> messages;
  final bool isLoading;
  final VoidCallback? onLoadMore;

  const MessageList({
    Key? key,
    required this.messages,
    this.isLoading = false,
    this.onLoadMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[100],
      child: ListView.builder(
        reverse: true,
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[messages.length - 1 - index];
          return ChatMessageBubble(
            message: message.message,
            time: message.time,
            isFromDoctor: message.isFromDoctor,
          );
        },
      ),
    );
  }
}

class ChatMessageBubble extends StatelessWidget {
  final String message;
  final String time;
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: isFromDoctor ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isFromDoctor ? Colors.grey[200] : Colors.blue,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(message, style: TextStyle(color: isFromDoctor ? Colors.black : Colors.white)),
                  Text(time, style: TextStyle(fontSize: 12, color: isFromDoctor ? Colors.grey : Colors.white70)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatInput extends StatelessWidget {
  final Function(String)? onSendMessage;
  final VoidCallback? onAttachFile;
  final VoidCallback? onTakePhoto;

  const ChatInput({
    Key? key,
    this.onSendMessage,
    this.onAttachFile,
    this.onTakePhoto,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(onPressed: onAttachFile, icon: const Icon(Icons.attach_file)),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Escribe tu mensaje...',
                filled: true,
                fillColor: Colors.yellow[300],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
              ),
            ),
          ),
          IconButton(onPressed: onTakePhoto, icon: const Icon(Icons.camera_alt)),
          FloatingActionButton(
            mini: true,
            onPressed: () {
              if (controller.text.isNotEmpty) {
                onSendMessage?.call(controller.text);
                controller.clear();
              }
            },
            child: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}

class BottomActionBar extends StatelessWidget {
  final VoidCallback? onRecetaPressed;
  final VoidCallback? onAdjuntarPressed;
  final VoidCallback? onFinalizarPressed;

  const BottomActionBar({
    Key? key,
    this.onRecetaPressed,
    this.onAdjuntarPressed,
    this.onFinalizarPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onRecetaPressed,
              child: const Text('Receta'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton(
              onPressed: onAdjuntarPressed,
              child: const Text('Adjuntar'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: onFinalizarPressed,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Finalizar'),
            ),
          ),
        ],
      ),
    );
  }
}