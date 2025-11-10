import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket _socket;

  void connect({required String userId}) {
    _socket = IO.io('http://localhost:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socket.connect();

    _socket.onConnect((_) {
      print('✅ Socket conectado como usuario $userId');
      _socket.emit('register', userId);
    });

    _socket.onDisconnect((_) {
      print('❌ Socket desconectado');
    });
  }

  void sendMessage(String senderId, String receiverId, String content) {
    print('📤 Enviando mensaje de $senderId a $receiverId: $content');
    _socket.emit('send_message', {
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
    });
  }

  void onMessage(Function(Map<String, dynamic>) callback) {
    _socket.on('receive_message', (data) {
      print('📩 Mensaje recibido: $data');
      callback(Map<String, dynamic>.from(data));
    });
  }

  void disconnect() {
    _socket.disconnect();
  }
}