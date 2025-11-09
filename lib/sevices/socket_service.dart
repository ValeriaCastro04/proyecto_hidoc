import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;

  // Conectar al servidor NestJS
  void connect({required int userId}) {
    socket = IO.io('http://10.0.2.2:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.onConnect((_) {
      print('🟢 Conectado al servidor como usuario $userId');
    });

    // Escuchar desconexiones
    socket.onDisconnect((_) => print('🔴 Desconectado del servidor'));
  }

  // Enviar mensaje
  void sendMessage(int senderId, int receiverId, String content) {
    socket.emit('send_message', {
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
    });
  }

  // Escuchar mensajes
  void onMessage(int userId, Function(dynamic) callback) {
    socket.on('receive_message_$userId', callback);
  }

  // Cerrar conexión
  void disconnect() {
    socket.disconnect();
  }
}
