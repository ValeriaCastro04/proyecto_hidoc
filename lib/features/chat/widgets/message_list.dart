import 'package:flutter/material.dart';

/// Modelo de datos para representar un mensaje individual
class ChatMessage {
  /// Contenido del mensaje
  final String message;
  
  /// Hora del mensaje en formato HH:mm
  final String time;
  
  /// Indica si el mensaje es del doctor (true) o del paciente (false)
  final bool isFromDoctor;
  
  /// ID único del mensaje para identificación
  final String id;

  const ChatMessage({
    required this.message,
    required this.time,
    required this.isFromDoctor,
    required this.id,
  });
}

/// Widget para mostrar una lista de mensajes del chat médico con scroll
/// 
/// Características:
/// - Lista scrolleable de mensajes con ChatMessageBubble
/// - Auto-scroll hacia el último mensaje enviado
/// - Manejo eficiente de listas largas con ListView.builder
/// - Indicador de carga para mensajes pendientes
/// - Fondo personalizable según el diseño
class MessageList extends StatefulWidget {
  /// Lista de mensajes a mostrar en el chat
  final List<ChatMessage> messages;
  
  /// Indica si se están cargando más mensajes
  final bool isLoading;
  
  /// Callback que se ejecuta cuando se llega al inicio de la lista (scroll up)
  final VoidCallback? onLoadMore;
  
  /// Color de fondo de la lista de mensajes
  final Color backgroundColor;
  
  /// Padding interno de la lista
  final EdgeInsets padding;

  const MessageList({
    Key? key,
    required this.messages,
    this.isLoading = false,
    this.onLoadMore,
    this.backgroundColor = const Color(0xFFE3F2FD), // Azul claro como en Figma
    this.padding = const EdgeInsets.symmetric(vertical: 8),
  }) : super(key: key);

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  /// Controlador para manejar el scroll de la lista
  late ScrollController _scrollController;
  
  /// Key para acceder al estado de RefreshIndicator
  final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // QUÉ HACE: Inicializa el controlador de scroll y configura listeners
    // CÓMO LO HACE: Crea ScrollController y añade listener para detectar
    // cuando el usuario hace scroll hacia arriba para cargar más mensajes
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    // QUÉ HACE: Libera los recursos del controlador al destruir el widget
    // CÓMO LO HACE: dispose() del ScrollController evita memory leaks
    // al limpiar listeners y referencias cuando el widget se elimina
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(MessageList oldWidget) {
    super.didUpdateWidget(oldWidget);
    // QUÉ HACE: Detecta cuando llegan nuevos mensajes para hacer auto-scroll
    // CÓMO LO HACE: Compara la longitud de mensajes anterior con la actual
    // y si hay nuevos mensajes, hace scroll automático hacia el final
    if (oldWidget.messages.length < widget.messages.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  /// Maneja el evento de scroll para detectar pull-to-refresh
  void _onScroll() {
    // QUÉ HACE: Detecta cuando el usuario hace scroll hacia arriba para cargar más
    // CÓMO LO HACE: Verifica si el scroll está cerca del inicio de la lista
    // y ejecuta el callback onLoadMore para cargar mensajes anteriores
    if (_scrollController.position.pixels <= 100 && widget.onLoadMore != null) {
      widget.onLoadMore!();
    }
  }

  /// Hace scroll automático hacia el último mensaje
  Future<void> _scrollToBottom() async {
    // QUÉ HACE: Desplaza la vista hacia el mensaje más reciente de forma suave
    // CÓMO LO HACE: animateTo() mueve el scroll al final de la lista
    // con una animación de 300ms para una experiencia fluida
    if (_scrollController.hasClients) {
      await _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  /// Maneja el pull-to-refresh para cargar mensajes anteriores
  Future<void> _onRefresh() async {
    // QUÉ HACE: Implementa el gesto de pull-to-refresh para cargar más mensajes
    // CÓMO LO HACE: Ejecuta el callback onLoadMore y espera un breve delay
    // para simular la carga de datos desde el servidor
    if (widget.onLoadMore != null) {
      widget.onLoadMore!();
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  /// Construye un ChatMessageBubble a partir de un ChatMessage
  Widget _buildMessageBubble(ChatMessage message) {
    // QUÉ HACE: Convierte un modelo ChatMessage en el widget visual correspondiente
    // CÓMO LO HACE: Crea un ChatMessageBubble usando los datos del mensaje
    // y añade una key única para optimización de la lista
    return ChatMessageBubble(
      key: ValueKey(message.id),
      message: message.message,
      time: message.time,
      isFromDoctor: message.isFromDoctor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // QUÉ HACE: Crea el contenedor principal con el fondo del chat
      // CÓMO LO HACE: Container con color de fondo personalizable
      // que simula el ambiente visual del diseño de Figma
      color: widget.backgroundColor,
      child: RefreshIndicator(
        // QUÉ HACE: Añade funcionalidad de pull-to-refresh para cargar más mensajes
        // CÓMO LO HACE: RefreshIndicator envuelve la lista y ejecuta _onRefresh
        // cuando el usuario hace el gesto de arrastrar hacia abajo desde el inicio
        key: _refreshKey,
        onRefresh: _onRefresh,
        child: widget.messages.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
                // QUÉ HACE: Crea una lista scrolleable optimizada para muchos mensajes
                // CÓMO LO HACE: ListView.builder construye widgets bajo demanda,
                // reverse: true para que los mensajes más recientes aparezcan abajo
                controller: _scrollController,
                padding: widget.padding,
                reverse: true,
                itemCount: widget.messages.length + (widget.isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  // QUÉ HACE: Construye cada elemento de la lista según su posición
                  // CÓMO LO HACE: Si es el primer item y está cargando, muestra indicador
                  // de lo contrario, construye la burbuja de mensaje correspondiente
                  if (index == 0 && widget.isLoading) {
                    return _buildLoadingIndicator();
                  }
                  
                  final messageIndex = widget.isLoading ? index - 1 : index;
                  final reversedIndex = widget.messages.length - 1 - messageIndex;
                  return _buildMessageBubble(widget.messages[reversedIndex]);
                },
              ),
      ),
    );
  }

  /// Construye el estado vacío cuando no hay mensajes
  Widget _buildEmptyState() {
    // QUÉ HACE: Muestra una pantalla informativa cuando no hay mensajes en el chat
    // CÓMO LO HACE: Column centrada con ícono, texto y mensaje de bienvenida
    // para guiar al usuario sobre cómo iniciar la conversación
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No hay mensajes aún',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Inicia la conversación enviando un mensaje',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construye el indicador de carga para mensajes pendientes
  Widget _buildLoadingIndicator() {
    // QUÉ HACE: Muestra un indicador visual cuando se están cargando más mensajes
    // CÓMO LO HACE: Container con CircularProgressIndicator centrado
    // y padding adecuado para no interferir con el flujo de mensajes
    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      child: const CircularProgressIndicator(
        strokeWidth: 2,
      ),
    );
  }
}

/// Dependencia: Importar el ChatMessageBubble widget
/// Este widget debe estar disponible en el mismo proyecto
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
    // QUÉ HACE: Implementación básica del ChatMessageBubble
    // CÓMO LO HACE: Esta es una versión simplificada para que el código compile
    // En la implementación real, usar el ChatMessageBubble del archivo anterior
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: isFromDoctor 
            ? MainAxisAlignment.start 
            : MainAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isFromDoctor ? Colors.grey[200] : Colors.blue,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 16,
                      color: isFromDoctor ? Colors.black87 : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 12,
                      color: isFromDoctor ? Colors.grey[600] : Colors.white70,
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

/// Widget de ejemplo para mostrar cómo usar el MessageList
/// Útil para testing y desarrollo con datos de prueba
class MessageListExample extends StatefulWidget {
  const MessageListExample({Key? key}) : super(key: key);

  @override
  State<MessageListExample> createState() => _MessageListExampleState();
}

class _MessageListExampleState extends State<MessageListExample> {
  /// Lista de mensajes de ejemplo
  List<ChatMessage> messages = [
    ChatMessage(
      id: '1',
      message: 'Hola, soy el Dr. López. ¿En qué puedo ayudarte hoy?',
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

  bool isLoading = false;

  /// Simula la carga de más mensajes
  void _loadMoreMessages() {
    // QUÉ HACE: Simula la carga de mensajes anteriores desde el servidor
    // CÓMO LO HACE: Añade mensajes ficticios con delay para simular latencia
    // de red y muestra el estado de carga durante el proceso
    setState(() {
      isLoading = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        messages.addAll([
          ChatMessage(
            id: '${messages.length + 1}',
            message: 'Mensaje cargado ${messages.length + 1}',
            time: '10:2${messages.length}',
            isFromDoctor: messages.length % 2 == 0,
          ),
        ]);
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // QUÉ HACE: Estructura completa para demostrar el MessageList funcionando
      // CÓMO LO HACE: AppBar con título y MessageList ocupando todo el espacio
      // disponible con funcionalidad de carga de más mensajes
      appBar: AppBar(
        title: const Text('Message List'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: MessageList(
        messages: messages,
        isLoading: isLoading,
        onLoadMore: _loadMoreMessages,
      ),
    );
  }
}