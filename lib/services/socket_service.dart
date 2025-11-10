import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;

  void connect({required String userId}) {
    socket = IO.io('http://10.0.2.2:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.onConnect((_) {
      print('🟢 Socket conectado como usuario $userId');
    });

    socket.onDisconnect((_) {
      print('🔴 Socket desconectado');
    });
  }

  void sendMessage(String senderId, String receiverId, String content) {
    socket.emit('send_message', {
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
    });
  }

  void onMessage(String userId, Function(dynamic) callback) {
    socket.on('receive_message_$userId', callback);
  }

  void disconnect() {
    socket.disconnect();
  }
}
