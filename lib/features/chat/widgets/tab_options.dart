import 'package:flutter/material.dart';

/// Enum para definir los diferentes tabs disponibles
enum ChatTab {
  chat,
  video,
  notas,
}

/// Widget para el navegador de tabs del chat médico
/// 
/// Características:
/// - Tres tabs: Chat, Video, Notas
/// - Tab activo resaltado en amarillo
/// - Tabs inactivos en gris claro
/// - Bordes redondeados y diseño moderno
/// - Callback para manejar cambios de tab
class ChatTabNavigator extends StatelessWidget {
  /// Tab actualmente seleccionado
  final ChatTab selectedTab;
  
  /// Callback que se ejecuta cuando se selecciona un tab diferente
  final Function(ChatTab tab)? onTabChanged;
  
  /// Color del tab activo
  final Color activeColor;
  
  /// Color del texto del tab activo
  final Color activeTextColor;
  
  /// Color de fondo de los tabs inactivos
  final Color inactiveColor;
  
  /// Color del texto de los tabs inactivos
  final Color inactiveTextColor;

  const ChatTabNavigator({
    Key? key,
    required this.selectedTab,
    this.onTabChanged,
    this.activeColor = const Color(0xFFFFD54F), // Amarillo como en Figma
    this.activeTextColor = Colors.black87,
    this.inactiveColor = Colors.transparent,
    this.inactiveTextColor = Colors.grey,
  }) : super(key: key);

  /// Obtiene el texto a mostrar para cada tab
  String _getTabText(ChatTab tab) {
    switch (tab) {
      case ChatTab.chat:
        return 'Chat';
      case ChatTab.video:
        return 'Video';
      case ChatTab.notas:
        return 'Notas';
    }
  }

  /// Construye un tab individual con su estilo correspondiente
  Widget _buildTab(ChatTab tab) {
    // QUÉ HACE: Determina si el tab actual es el seleccionado para aplicar estilos
    // CÓMO LO HACE: Compara el tab actual con selectedTab y establece isActive
    // para controlar colores, fondos y apariencia general del botón
    final isActive = selectedTab == tab;
    
    return Expanded(
      child: GestureDetector(
        // QUÉ HACE: Maneja el tap en el tab y notifica el cambio de selección
        // CÓMO LO HACE: onTap ejecuta el callback onTabChanged con el tab seleccionado
        // solo si hay un callback definido y el tab no está ya activo
        onTap: () {
          if (onTabChanged != null && !isActive) {
            onTabChanged!(tab);
          }
        },
        child: Container(
          // QUÉ HACE: Crea el contenedor visual del tab con padding y decoración
          // CÓMO LO HACE: Padding vertical de 12px para altura táctil adecuada
          // y decoración condicional según el estado activo/inactivo
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            // QUÉ HACE: Muestra el texto del tab con estilo según su estado
            // CÓMO LO HACE: Text centrado con color y peso de fuente condicional
            // (bold para activo, normal para inactivo) y colores personalizables
            child: Text(
              _getTabText(tab),
              style: TextStyle(
                fontSize: 16,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? activeTextColor : inactiveTextColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // QUÉ HACE: Crea el contenedor principal del navegador de tabs
      // CÓMO LO HACE: Margin horizontal de 16px para separación de bordes,
      // padding interno de 4px y decoración con fondo blanco y bordes redondeados
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        // QUÉ HACE: Organiza los tres tabs horizontalmente con igual distribución
        // CÓMO LO HACE: Row con MainAxisAlignment.spaceEvenly para distribución uniforme
        // y cada tab envuelto en Expanded para ocupar espacio proporcional
        children: [
          _buildTab(ChatTab.chat),
          _buildTab(ChatTab.video),
          _buildTab(ChatTab.notas),
        ],
      ),
    );
  }
}

/// Widget de ejemplo para mostrar cómo usar el ChatTabNavigator
/// Útil para testing y desarrollo con manejo de estado
class ChatTabNavigatorExample extends StatefulWidget {
  const ChatTabNavigatorExample({Key? key}) : super(key: key);

  @override
  State<ChatTabNavigatorExample> createState() => _ChatTabNavigatorExampleState();
}

class _ChatTabNavigatorExampleState extends State<ChatTabNavigatorExample> {
  /// Estado actual del tab seleccionado
  ChatTab _selectedTab = ChatTab.chat;

  /// Obtiene el contenido a mostrar según el tab seleccionado
  Widget _getTabContent() {
    // QUÉ HACE: Retorna diferentes widgets según el tab activo para simular contenido
    // CÓMO LO HACE: Switch statement que evalúa _selectedTab y retorna
    // un Container con texto descriptivo del contenido de cada sección
    switch (_selectedTab) {
      case ChatTab.chat:
        return Container(
          padding: const EdgeInsets.all(20),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.chat_bubble, size: 80, color: Colors.blue),
              SizedBox(height: 16),
              Text(
                'Sección de Chat',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Aquí se muestran los mensajes del chat médico',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        );
      case ChatTab.video:
        return Container(
          padding: const EdgeInsets.all(20),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.videocam, size: 80, color: Colors.green),
              SizedBox(height: 16),
              Text(
                'Sección de Video',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Aquí se manejan las videollamadas médicas',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        );
      case ChatTab.notas:
        return Container(
          padding: const EdgeInsets.all(20),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.note_alt, size: 80, color: Colors.orange),
              SizedBox(height: 16),
              Text(
                'Sección de Notas',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Aquí se almacenan las notas y observaciones médicas',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // QUÉ HACE: Estructura básica para demostrar el ChatTabNavigator funcionando
      // CÓMO LO HACE: AppBar con título, body con fondo azul claro y Column
      // que contiene el navegador de tabs y el contenido dinámico
      appBar: AppBar(
        title: const Text('Chat Tab Navigator'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      backgroundColor: Colors.blue[100],
      body: Column(
        children: [
          const SizedBox(height: 20),
          
          // QUÉ HACE: Navegador de tabs con estado reactivo
          // CÓMO LO HACE: ChatTabNavigator que recibe el tab seleccionado actual
          // y callback que actualiza el estado cuando se cambia de tab
          ChatTabNavigator(
            selectedTab: _selectedTab,
            onTabChanged: (tab) {
              setState(() {
                _selectedTab = tab;
              });
            },
          ),
          
          const SizedBox(height: 20),
          
          // QUÉ HACE: Área de contenido que cambia según el tab seleccionado
          // CÓMO LO HACE: Expanded que contiene el widget retornado por _getTabContent()
          // creando una experiencia de navegación completa entre secciones
          Expanded(
            child: _getTabContent(),
          ),
        ],
      ),
    );
  }
}