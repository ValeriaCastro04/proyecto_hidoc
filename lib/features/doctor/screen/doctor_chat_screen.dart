import 'package:flutter/material.dart';
import 'package:proyecto_hidoc/common/shared_widgets/footer_group.dart';
import 'package:proyecto_hidoc/common/shared_widgets/header_bar.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/list/footer_doctor.dart';
import 'package:proyecto_hidoc/common/shared_widgets/theme_toggle_button.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_hidoc/providers/chat_provider.dart';

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
  bool _isLoadingMessages = false;
  bool _isSendingMessage = false;

  @override
  void initState() {
    super.initState();
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.connect(2);
    chatProvider.addListener(() => setState(() {}));
  }

  void _sendMessage(String messageText) async {
    if (messageText.trim().isEmpty) return;
    setState(() => _isSendingMessage = true);
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.sendMessage(2, int.parse(widget.patientId), messageText);
    setState(() => _isSendingMessage = false);
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
          children: const [
            TextField(decoration: InputDecoration(labelText: 'Medicamento')),
            SizedBox(height: 12),
            TextField(decoration: InputDecoration(labelText: 'Dosis')),
            SizedBox(height: 12),
            TextField(decoration: InputDecoration(labelText: 'Duración')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Receta creada y enviada al paciente')));
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
        content: const TextField(maxLines: 4, decoration: InputDecoration(border: OutlineInputBorder(), hintText: 'Escriba sus observaciones...')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nota médica guardada')));
            },
            child: const Text('Guardar'),
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
        content: const Text('¿Desea finalizar esta consulta médica?'),
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
      case DoctorChatTab.chat:
        return DoctorMessageList(messages: chatProvider.messages, isLoading: _isLoadingMessages);
      case DoctorChatTab.expediente:
        return _buildExpedienteContent();
      case DoctorChatTab.notas:
        return _buildNotasMedicasContent();
    }
  }

  Widget _buildExpedienteContent() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(children: [
        const Text('Expediente Médico', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Expanded(
          child: ListView(children: [
            _buildExpedienteCard('Información Personal', 'Edad: 35 años\nSexo: Masculino\nPeso: 75kg\nAltura: 1.75m'),
            _buildExpedienteCard('Alergias', 'Penicilina\nMariscos'),
            _buildExpedienteCard('Medicamentos', 'Losartán 50mg/día'),
            _buildExpedienteCard('Antecedentes', 'Hipertensión arterial\nDiabetes tipo 2 (familiar)'),
          ]),
        ),
      ]),
    );
  }

  Widget _buildNotasMedicasContent() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Notas Médicas', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ElevatedButton.icon(onPressed: _addMedicalNote, icon: const Icon(Icons.add), label: const Text('Nueva Nota')),
        ]),
        const SizedBox(height: 20),
        Expanded(
          child: ListView(children: [
            _buildNotaCard('Consulta Inicial', 'Paciente refiere cefaleas frecuentes.', '10:30'),
            _buildNotaCard('Seguimiento', 'Mejoría parcial con tratamiento.', '09:15'),
            _buildNotaCard('Observaciones', 'Paciente colaborador.', '08:45'),
          ]),
        ),
      ]),
    );
  }

  Widget _buildExpedienteCard(String title, String content) => Card(
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

  Widget _buildNotaCard(String title, String content, String time) => Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text(time, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ]),
            const SizedBox(height: 8),
            Text(content),
          ]),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    const String doctorName = 'Dra. Elena Martínez';

    return Scaffold(
      appBar: HeaderBar.brand(
        logoAsset: 'assets/brand/hidoc_logo.png',
        title: doctorName,
        actions: [
          const ThemeToggleButton(),
          IconButton(onPressed: () {}, icon: Icon(Icons.notifications_none_rounded, color: colors.onSurface)),
          const SizedBox(width: 8),
          CircleAvatar(backgroundColor: colors.primary, foregroundColor: colors.onPrimary, child: Text('EM')),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(children: [
        DoctorChatHeader(
          patientName: widget.patientName,
          patientInitials: widget.patientInitials,
          onBackPressed: () => Navigator.pop(context),
          onCallPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Iniciando llamada...'))),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: DoctorChatTabNavigator(selectedTab: _selectedTab, onTabChanged: (tab) => setState(() => _selectedTab = tab)),
        ),
        Expanded(child: _buildTabContent()),
        if (_selectedTab == DoctorChatTab.chat)
          DoctorChatInput(onSendMessage: _sendMessage, onAttachFile: () => _handleDoctorAction('nota'), onTakePhoto: () {}),
        DoctorBottomActionBar(
          onRecetaPressed: () => _handleDoctorAction('receta'),
          onNotaPressed: () => _handleDoctorAction('nota'),
          onFinalizarPressed: () => _handleDoctorAction('finalizar'),
        ),
      ]),
      bottomNavigationBar: FooterGroup(buttons: doctorFooterButtons(context)),
    );
  }
}

enum DoctorChatTab { chat, expediente, notas }

class DoctorChatHeader extends StatelessWidget {
  final String patientName, patientInitials;
  final VoidCallback? onBackPressed, onCallPressed;
  const DoctorChatHeader({Key? key, required this.patientName, required this.patientInitials, this.onBackPressed, this.onCallPressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      color: colors.onPrimary,
      child: Row(children: [
        IconButton(onPressed: onBackPressed, icon: const Icon(Icons.arrow_back)),
        CircleAvatar(radius: 28, backgroundColor: colors.primary.withOpacity(.15), child: Icon(Icons.person, color: colors.primary)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(patientName, style: const TextStyle(fontWeight: FontWeight.bold)),
          const Text('Paciente'),
        ])),
        IconButton(onPressed: onCallPressed, icon: const Icon(Icons.phone)),
      ]),
    );
  }
}

class DoctorChatTabNavigator extends StatelessWidget {
  final DoctorChatTab selectedTab;
  final Function(DoctorChatTab)? onTabChanged;
  const DoctorChatTabNavigator({Key? key, required this.selectedTab, this.onTabChanged}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: colors.onPrimary, borderRadius: BorderRadius.circular(25)),
      child: Row(
        children: DoctorChatTab.values.map((tab) {
          final isActive = selectedTab == tab;
          final name = tab.name.toUpperCase();
          return Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged?.call(tab),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(color: isActive ? colors.onPrimaryFixedVariant : Colors.transparent, borderRadius: BorderRadius.circular(20)),
                child: Center(child: Text(name, style: TextStyle(color: isActive ? colors.onPrimary : colors.onBackground, fontWeight: isActive ? FontWeight.bold : FontWeight.normal))),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class DoctorMessageList extends StatelessWidget {
  final List<Map<String, dynamic>> messages;
  final bool isLoading;
  const DoctorMessageList({Key? key, required this.messages, this.isLoading = false}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      color: colors.secondaryContainer,
      child: ListView.builder(
        reverse: true,
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[messages.length - 1 - index];
          final isFromDoctor = message['from'] == 2;
          return DoctorChatMessageBubble(message: message['content'], isFromDoctor: isFromDoctor);
        },
      ),
    );
  }
}

class DoctorChatMessageBubble extends StatelessWidget {
  final String message;
  final bool isFromDoctor;
  const DoctorChatMessageBubble({Key? key, required this.message, required this.isFromDoctor}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: isFromDoctor ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: isFromDoctor ? colors.onPrimaryFixedVariant : colors.primaryFixedDim, borderRadius: BorderRadius.circular(16)),
              child: Text(message, style: TextStyle(color: isFromDoctor ? Colors.white : Colors.black)),
            ),
          ),
        ],
      ),
    );
  }
}

class DoctorChatInput extends StatelessWidget {
  final Function(String)? onSendMessage;
  final VoidCallback? onAttachFile, onTakePhoto;
  const DoctorChatInput({Key? key, this.onSendMessage, this.onAttachFile, this.onTakePhoto}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final controller = TextEditingController();
    return Container(
      padding: const EdgeInsets.all(16),
      color: colors.onPrimary,
      child: Row(children: [
        IconButton(onPressed: onAttachFile, icon: const Icon(Icons.attach_file)),
        Expanded(child: TextField(controller: controller, decoration: InputDecoration(hintText: 'Escriba su mensaje...', filled: true, fillColor: colors.secondaryContainer, border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none)))),
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

class DoctorBottomActionBar extends StatelessWidget {
  final VoidCallback? onRecetaPressed, onNotaPressed, onFinalizarPressed;
  const DoctorBottomActionBar({Key? key, this.onRecetaPressed, this.onNotaPressed, this.onFinalizarPressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      color: colors.onPrimary,
      child: Row(children: [
        Expanded(child: OutlinedButton(onPressed: onRecetaPressed, child: const Text('Receta'))),
        const SizedBox(width: 12),
        Expanded(child: OutlinedButton(onPressed: onNotaPressed, child: const Text('Nota Médica'))),
        const SizedBox(width: 12),
        Expanded(child: ElevatedButton(onPressed: onFinalizarPressed, style: ElevatedButton.styleFrom(backgroundColor: colors.primaryContainer), child: const Text('Finalizar'))),
      ]),
    );
  }
}
