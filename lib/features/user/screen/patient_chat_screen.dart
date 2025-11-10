import 'package:flutter/material.dart';
import 'package:proyecto_hidoc/common/shared_widgets/theme_toggle_button.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_hidoc/providers/chat_provider.dart';

class PatientChatScreen extends StatefulWidget {
  final String doctorId;
  final String doctorName;
  final String doctorInitials;
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
  ChatTab _selectedTab = ChatTab.chat;
  bool _isLoadingMessages = false;
  bool _isSendingMessage = false;

  @override
  void initState() {
    super.initState();
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.connect(1);
    chatProvider.addListener(() => setState(() {}));
  }

  void _sendMessage(String messageText) async {
    if (messageText.trim().isEmpty) return;
    setState(() => _isSendingMessage = true);
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.sendMessage(1, int.parse(widget.doctorId), messageText);
    setState(() => _isSendingMessage = false);
  }

  void _handleBottomAction(String action) {
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

  void _showRecetaDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Recetas Médicas'),
        content: const Text('Aquí se mostrarían las recetas prescritas por el doctor durante esta consulta.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar')),
        ],
      ),
    );
  }

  void _handleAttachFile() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('Adjuntar archivo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          ListTile(leading: const Icon(Icons.photo), title: const Text('Foto de galería'), onTap: () => Navigator.pop(context)),
          ListTile(leading: const Icon(Icons.camera_alt), title: const Text('Tomar foto'), onTap: () => Navigator.pop(context)),
          ListTile(leading: const Icon(Icons.insert_drive_file), title: const Text('Documento'), onTap: () => Navigator.pop(context)),
        ]),
      ),
    );
  }

  void _handleFinishConsultation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Finalizar Consulta'),
        content: const Text('¿Estás seguro de que deseas finalizar esta consulta médica?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Finalizar'),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    final chatProvider = Provider.of<ChatProvider>(context);
    switch (_selectedTab) {
      case ChatTab.chat:
        return MessageList(messages: chatProvider.messages, isLoading: _isLoadingMessages);
      case ChatTab.video:
        return _buildVideoContent();
      case ChatTab.notas:
        return _buildNotasContent();
    }
  }

  Widget _buildVideoContent() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.videocam, size: 80, color: Colors.blue),
        const SizedBox(height: 20),
        const Text('Videollamada', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Text('Conecta con ${widget.doctorName} mediante videollamada', textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: Colors.grey)),
        const SizedBox(height: 30),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.video_call),
          label: const Text('Iniciar videollamada'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
        ),
      ]),
    );
  }

  Widget _buildNotasContent() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(children: [
        const Text('Notas Médicas', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Expanded(
          child: ListView(children: [
            _buildNotaCard('Síntomas reportados', 'Dolor de cabeza frecuente en los últimos días'),
            _buildNotaCard('Observaciones', 'Dolor constante, empeora con estrés'),
            _buildNotaCard('Recomendaciones', 'Descanso, hidratación, seguimiento en 3 días'),
          ]),
        ),
      ]),
    );
  }

  Widget _buildNotaCard(String title, String content) => Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(content),
          ]),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        ChatHeader(
          doctorName: widget.doctorName,
          doctorInitials: widget.doctorInitials,
          isOnline: widget.isDoctorOnline,
          onBackPressed: () => Navigator.pop(context),
          onCallPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Iniciando llamada...'))),
          onVideoPressed: () => setState(() => _selectedTab = ChatTab.video),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: ChatTabNavigator(selectedTab: _selectedTab, onTabChanged: (tab) => setState(() => _selectedTab = tab)),
        ),
        Expanded(child: _buildTabContent()),
        if (_selectedTab == ChatTab.chat)
          ChatInput(onSendMessage: _sendMessage, onAttachFile: () => _handleBottomAction('adjuntar'), onTakePhoto: () {}),
        BottomActionBar(
          onRecetaPressed: () => _handleBottomAction('receta'),
          onAdjuntarPressed: () => _handleBottomAction('adjuntar'),
          onFinalizarPressed: () => _handleBottomAction('finalizar'),
        ),
      ]),
    );
  }
}

enum ChatTab { chat, video, notas }

class ChatMessage {
  final String id;
  final String message;
  final String time;
  final bool isFromDoctor;
  const ChatMessage({required this.id, required this.message, required this.time, required this.isFromDoctor});
}

class ChatHeader extends StatelessWidget {
  final String doctorName, doctorInitials;
  final bool isOnline;
  final VoidCallback? onBackPressed, onCallPressed, onVideoPressed;
  const ChatHeader({Key? key, required this.doctorName, required this.doctorInitials, required this.isOnline, this.onBackPressed, this.onCallPressed, this.onVideoPressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      color: Colors.white,
      child: Row(children: [
        IconButton(onPressed: onBackPressed, icon: const Icon(Icons.arrow_back)),
        CircleAvatar(backgroundColor: Colors.blue, child: Text(doctorInitials, style: const TextStyle(color: Colors.white))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(doctorName, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(isOnline ? 'En línea' : 'Desconectado', style: TextStyle(color: isOnline ? Colors.green : Colors.grey)),
        ])),
        IconButton(onPressed: onCallPressed, icon: const Icon(Icons.phone)),
        IconButton(onPressed: onVideoPressed, icon: const Icon(Icons.videocam)),
        const ThemeToggleButton(),
      ]),
    );
  }
}

class ChatTabNavigator extends StatelessWidget {
  final ChatTab selectedTab;
  final Function(ChatTab)? onTabChanged;
  const ChatTabNavigator({Key? key, required this.selectedTab, this.onTabChanged}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
      child: Row(
        children: ChatTab.values.map((tab) {
          final isActive = selectedTab == tab;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged?.call(tab),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(color: isActive ? Colors.yellow[300] : Colors.transparent, borderRadius: BorderRadius.circular(20)),
                child: Center(
                  child: Text(tab.name.toUpperCase(), style: TextStyle(fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
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
  final List<Map<String, dynamic>> messages;
  final bool isLoading;
  const MessageList({Key? key, required this.messages, this.isLoading = false}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[100],
      child: ListView.builder(
        reverse: true,
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[messages.length - 1 - index];
          final isFromDoctor = message['from'] == 2;
          return ChatMessageBubble(message: message['content'], time: '', isFromDoctor: isFromDoctor);
        },
      ),
    );
  }
}

class ChatMessageBubble extends StatelessWidget {
  final String message, time;
  final bool isFromDoctor;
  const ChatMessageBubble({Key? key, required this.message, required this.time, required this.isFromDoctor}) : super(key: key);
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
              decoration: BoxDecoration(color: isFromDoctor ? Colors.grey[200] : Colors.blue, borderRadius: BorderRadius.circular(16)),
              child: Text(message, style: TextStyle(color: isFromDoctor ? Colors.black : Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatInput extends StatelessWidget {
  final Function(String)? onSendMessage;
  final VoidCallback? onAttachFile, onTakePhoto;
  const ChatInput({Key? key, this.onSendMessage, this.onAttachFile, this.onTakePhoto}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(children: [
        IconButton(onPressed: onAttachFile, icon: const Icon(Icons.attach_file)),
        Expanded(child: TextField(controller: controller, decoration: InputDecoration(hintText: 'Escribe tu mensaje...', filled: true, fillColor: Colors.yellow[300], border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none)))),
        IconButton(onPressed: onTakePhoto, icon: const Icon(Icons.camera_alt)),
        FloatingActionButton(mini: true, onPressed: () {
          if (controller.text.isNotEmpty) {
            onSendMessage?.call(controller.text);
            controller.clear();
          }
        }, child: const Icon(Icons.send)),
      ]),
    );
  }
}

class BottomActionBar extends StatelessWidget {
  final VoidCallback? onRecetaPressed, onAdjuntarPressed, onFinalizarPressed;
  const BottomActionBar({Key? key, this.onRecetaPressed, this.onAdjuntarPressed, this.onFinalizarPressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(children: [
        Expanded(child: OutlinedButton(onPressed: onRecetaPressed, child: const Text('Receta'))),
        const SizedBox(width: 12),
        Expanded(child: OutlinedButton(onPressed: onAdjuntarPressed, child: const Text('Adjuntar'))),
        const SizedBox(width: 12),
        Expanded(child: ElevatedButton(onPressed: onFinalizarPressed, style: ElevatedButton.styleFrom(backgroundColor: Colors.green), child: const Text('Finalizar'))),
      ]),
    );
  }
}
