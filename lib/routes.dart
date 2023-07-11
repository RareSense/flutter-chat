import 'package:get/get.dart';
import 'package:xGPT/chat/presentation/pages/chat_page.dart';

final getPages = [
  GetPage(
    name: Routes.chat,
    page: () => const ChatPage(),
  ),
];

class Routes {
  static String chat = '/chat';
}
