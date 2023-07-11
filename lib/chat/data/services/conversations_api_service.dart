// import 'package:flutter/cupertino.dart';
//
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:xGPT/chat/domain/models/session.dart';
//
// import 'package:xGPT/core/services/base_service.dart';
//
// class ConversationsApiService extends BaseService {
//   static final String apiBaseUrl = dotenv.env['API_BASE_URL'] ?? '';
//
//   // Singleton pattern
//   static final ConversationsApiService _instance = ConversationsApiService._();
//   factory ConversationsApiService() => _instance;
//   ConversationsApiService._();
//
//   Future<List<Session>?> getSessions(int page) async {
//     final endPoint = '$apiBaseUrl/sessions?page=$page';
//     try {
//       final responseJson = await handleGetRequest(endPoint,successStatusCode: 200, onError: (error) {
//         debugPrint('Callback Error Occurred: $error');
//         handleApiError(error);
//       });
//
//       if (responseJson != null) {
//         // debugPrint("sessions: $responseJson");
//         List<dynamic> sessionsJson = responseJson['sessions'];
//         return sessionsJson.map((session) => Session.fromJson(session)).toList();
//       }
//     } catch (error) {
//       debugPrint('Error Occurred: $error');
//       // handleApiError(error, onUnauthorizedError: onUnauthorizedError);
//     }
//
//     return null;
//   }
//
//   Future<bool> deleteConversation(String sessionId) async {
//     final endPoint = '$apiBaseUrl/sessions/$sessionId';
//     try {
//
//       final responseJson = await handleDeleteRequest(
//         endPoint,
//         successStatusCode: 200,
//         onError: (error) {
//           handleApiError(error);
//         },
//       );
//
//       if (responseJson != null) {
//         debugPrint("Conversation deleted: $responseJson");
//         return true;
//       }
//     } catch (error) {
//       debugPrint("Error deleting conversation: $error");
//     }
//
//     return false;
//   }
//
//   @override
//   void handleError(String errorMessage) {
//     throw Exception(errorMessage);
//   }
// }
