import 'package:flutter/material.dart';
import 'package:proyecto_hidoc/common/shared_widgets/footer_group.dart';
import 'package:proyecto_hidoc/common/shared_widgets/header_bar.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/list/footer_doctor.dart';

/// Pantalla completa del chat médico para el doctor
class DoctorChatScreen extends StatefulWidget {
  final String patientId;
  final String patientName;
  final String patientInitials;

  const DoctorChatScreen({
    Key? key,
    required this.patientId,
    required this.patientName,
    required this.patientInitials,
  }) : super(key: key);

  @override
  State<DoctorChatScreen> createState() => _DoctorChatScreenState();
}

class _DoctorChatScreenState extends State<DoctorChatScreen> {
  DoctorChatTab _selectedTab = DoctorChatTab.chat;
  List<ChatMessage> _messages = [];
  bool _isLoadingMessages = false;
  bool _isSendingMessage = false;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  void _initializeChat() {
    setState(() {
      _messages = [
        ChatMessage(
          id: '1',
          message: 'Hola ${widget.patientName}, soy la Dra. Elena Martínez. ¿En qué puedo ayudarte hoy?',
          time: '10:30',
          isFromDoctor: true,
        ),
        ChatMessage(
          id: '2',
          message: 'Hola doctora, he tenido dolor de cabeza frecuente los últimos días.',
          time: '10:31',
          isFromDoctor: false,
        ),
        ChatMessage(
          id: '3',
          message: 'Entiendo tu preocupación. ¿Podrías describirme mejor el tipo de dolor? ¿Es pulsátil, constante, o viene y va?',
          time: '10:32',
          isFromDoctor: true,
        ),
      ];
    });
  }

  void _sendMessage(String messageText) async {
    if (messageText.trim().isEmpty) return;

    setState(() {
      _isSendingMessage = true;
    });

    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message: messageText,
      time: _getCurrentTime(),
      isFromDoctor: true,
    );

    setState(() {
      _messages.add(newMessage);
      _isSendingMessage = false;
    });
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  void _loadMoreMessages() {
    if (_isLoadingMessages) return;

    setState(() {
      _isLoadingMessages = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      final oldMessages = [
        ChatMessage(
          id: 'old_${_messages.length + 1}',
          message: 'Mensaje anterior de la conversación.',
          time: '09:${55 - _messages.length}',
          isFromDoctor: _messages.length % 2 == 1,
        ),
      ];

      setState(() {
        _messages.insertAll(0, oldMessages);
        _isLoadingMessages = false;
      });
    });
  }

  void _handleDoctorAction(String action) {
    switch (action) {
      case 'receta':
        _createPrescription();
        break;
      case 'nota':
        _addMedicalNote();
        break;
      case 'finalizar':
        _handleFinishConsultation();
        break;
    }
  }

  void _createPrescription() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Crear Receta Médica'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Medicamento',
                hintText: 'Ej: Ibuprofeno 400mg',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Dosis',
                hintText: 'Ej: 1 tableta cada 8 horas',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Duración',
                hintText: 'Ej: 5 días',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Receta creada y enviada al paciente')),
              );
            },
            child: const Text('Crear Receta'),
          ),
        ],
      ),
    );
  }

  void _addMedicalNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Agregar Nota Médica'),
        content: TextField(
          maxLines: 4,
          decoration: const InputDecoration(
            labelText: 'Nota',
            hintText: 'Escriba sus observaciones médicas...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Nota médica guardada')),
              );
            },
            child: const Text('Guardar Nota'),
          ),
        ],
      ),
    );
  }

  void _handleFinishConsultation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Finalizar Consulta'),
        content: const Text('¿Está seguro de que desea finalizar esta consulta médica?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Finalizar'),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case DoctorChatTab.chat:
        return DoctorMessageList(
          messages: _messages,
          isLoading: _isLoadingMessages,
          onLoadMore: _loadMoreMessages,
        );
      case DoctorChatTab.expediente:
        return _buildExpedienteContent();
      case DoctorChatTab.notas:
        return _buildNotasMedicasContent();
    }
  }

  Widget _buildExpedienteContent() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            'Expediente Médico',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                _buildExpedienteCard('Información Personal', 'Edad: 35 años\nSexo: Masculino\nPeso: 75kg\nAltura: 1.75m'),
                _buildExpedienteCard('Alergias', 'Penicilina\nMariscos'),
                _buildExpedienteCard('Medicamentos Actuales', 'Losartán 50mg/día'),
                _buildExpedienteCard('Antecedentes', 'Hipertensión arterial\nDiabetes tipo 2 (familiar)'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotasMedicasContent() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Notas Médicas',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: _addMedicalNote,
                icon: const Icon(Icons.add),
                label: const Text('Nueva Nota'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                _buildNotaCard('Consulta Inicial', 'Paciente refiere cefaleas frecuentes. Dolor constante, empeora con estrés.', '10:30'),
                _buildNotaCard('Seguimiento', 'Mejoría parcial con tratamiento indicado.', '09:15'),
                _buildNotaCard('Observaciones', 'Paciente colaborador, sigue indicaciones médicas.', '08:45'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpedienteCard(String title, String content) {
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

  Widget _buildNotaCard(String title, String content, String time) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  time,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
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
    final colors = Theme.of(context).colorScheme;
    const String doctorName = 'Dra. Elena Martínez';
    
    return Scaffold(
      appBar: HeaderBar.brand(
        logoAsset: 'assets/brand/hidoc_logo.png',
        title: doctorName,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_none_rounded, color: colors.onSurface),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: colors.primary,
            foregroundColor: colors.onPrimary,
            child: Text(
              doctorName.split(' ').map((e) => e[0]).take(2).join(),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          DoctorChatHeader(
            patientName: widget.patientName,
            patientInitials: widget.patientInitials,
            onBackPressed: () => Navigator.of(context).pop(),
            onCallPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Iniciando llamada con paciente...')),
              );
            },
            onVideoPressed: () {
              setState(() {
                _selectedTab = DoctorChatTab.chat;
              });
            },
            onMenuPressed: () {},
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: DoctorChatTabNavigator(
              selectedTab: _selectedTab,
              onTabChanged: (tab) {
                setState(() {
                  _selectedTab = tab;
                });
              },
            ),
          ),
          
          Expanded(
            child: _buildTabContent(),
          ),
          
          if (_selectedTab == DoctorChatTab.chat)
            DoctorChatInput(
              onSendMessage: _sendMessage,
              onAttachFile: () => _handleDoctorAction('nota'),
              onTakePhoto: () {},
            ),
            
          DoctorBottomActionBar(
            onRecetaPressed: () => _handleDoctorAction('receta'),
            onNotaPressed: () => _handleDoctorAction('nota'),
            onFinalizarPressed: () => _handleDoctorAction('finalizar'),
          ),
        ],
      ),
      bottomNavigationBar: FooterGroup(buttons: doctorFooterButtons(context)),
    );
  }
}

// ===== CLASES DE SOPORTE =====

enum DoctorChatTab { chat, expediente, notas }

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

class DoctorChatHeader extends StatelessWidget {
  final String patientName;
  final String patientInitials;
  final VoidCallback? onBackPressed;
  final VoidCallback? onCallPressed;
  final VoidCallback? onVideoPressed;
  final VoidCallback? onMenuPressed;

  const DoctorChatHeader({
    Key? key,
    required this.patientName,
    required this.patientInitials,
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
              child: Text(patientInitials, style: const TextStyle(color: Colors.white)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(patientName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const Text('Paciente', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            IconButton(onPressed: onCallPressed, icon: const Icon(Icons.phone)),
            IconButton(onPressed: onVideoPressed, icon: const Icon(Icons.videocam)),
            IconButton(onPressed: onMenuPressed, icon: const Icon(Icons.more_vert)),
          ],
        ),
      ),
    );
  }
}

class DoctorChatTabNavigator extends StatelessWidget {
  final DoctorChatTab selectedTab;
  final Function(DoctorChatTab)? onTabChanged;

  const DoctorChatTabNavigator({
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
        children: DoctorChatTab.values.map((tab) {
          final isActive = selectedTab == tab;
          String tabName;
          switch (tab) {
            case DoctorChatTab.chat:
              tabName = 'CHAT';
              break;
            case DoctorChatTab.expediente:
              tabName = 'EXPEDIENTE';
              break;
            case DoctorChatTab.notas:
              tabName = 'NOTAS';
              break;
          }
          
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
                    tabName,
                    style: TextStyle(
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12,
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

class DoctorMessageList extends StatelessWidget {
  final List<ChatMessage> messages;
  final bool isLoading;
  final VoidCallback? onLoadMore;

  const DoctorMessageList({
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
          return DoctorChatMessageBubble(
            message: message.message,
            time: message.time,
            isFromDoctor: message.isFromDoctor,
          );
        },
      ),
    );
  }
}

class DoctorChatMessageBubble extends StatelessWidget {
  final String message;
  final String time;
  final bool isFromDoctor;

  const DoctorChatMessageBubble({
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
        mainAxisAlignment: isFromDoctor ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isFromDoctor ? Colors.blue : Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(message, style: TextStyle(color: isFromDoctor ? Colors.white : Colors.black)),
                  Text(time, style: TextStyle(fontSize: 12, color: isFromDoctor ? Colors.white70 : Colors.grey)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DoctorChatInput extends StatelessWidget {
  final Function(String)? onSendMessage;
  final VoidCallback? onAttachFile;
  final VoidCallback? onTakePhoto;

  const DoctorChatInput({
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
                hintText: 'Escriba su mensaje médico...',
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

class DoctorBottomActionBar extends StatelessWidget {
  final VoidCallback? onRecetaPressed;
  final VoidCallback? onNotaPressed;
  final VoidCallback? onFinalizarPressed;

  const DoctorBottomActionBar({
    Key? key,
    this.onRecetaPressed,
    this.onNotaPressed,
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
              onPressed: onNotaPressed,
              child: const Text('Nota Médica'),
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