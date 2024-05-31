import 'package:flutter/material.dart';
import 'package:flutter_chat_app/model/group.dart';
import 'package:flutter_chat_app/model/user.dart';
import 'package:flutter_chat_app/model/user_call_channel.dart';
import 'package:flutter_chat_app/model/user_conversation.dart';
import 'package:flutter_chat_app/screen/chat_screen.dart';
import 'package:flutter_chat_app/screen/conversation_info_screen.dart';
import 'package:flutter_chat_app/screen/create_group_screen.dart';
import 'package:flutter_chat_app/screen/home_screen.dart';
import 'package:flutter_chat_app/screen/login_screen.dart';
import 'package:flutter_chat_app/screen/my_profile_screen.dart';
import 'package:flutter_chat_app/screen/qr_scanner_screen.dart';
import 'package:flutter_chat_app/screen/register_screen.dart';
import 'package:flutter_chat_app/screen/search_screen.dart';
import 'package:flutter_chat_app/screen/settings_screen.dart';
import 'package:flutter_chat_app/screen/splash_screen.dart';
import 'package:flutter_chat_app/screen/video_call_screen.dart';

class RouteGeneratorService {
  static const String splashScreen = '/splash-screen';
  static const String loginScreen = '/login-screen';
  static const String chatScreen = '/chat-screen';
  static const String homeScreen = '/home-screen';
  static const String videoCallScreen = '/video-call-screen';
  static const String myProfileScreen = '/my-profile-screen';
  static const String settingsScreen = '/settings-screen';
  static const String searchScreen = '/search-screen';
  static const String registerScreen = '/register-screen';
  static const String createGroupScreen = '/create-group-screen';
  static const String conversationInfoScreen = '/conversation-info-screen';
  static const String qrCodeScannerScreen = '/qr-code-scanner-screen';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashScreen:
        return pageRouteBuilder(const SplashScreen(), settings);
      case loginScreen:
        return pageRouteBuilder(const LoginPage(), settings);
      case homeScreen:
        return pageRouteBuilder(HomePage(user: settings.arguments as ChatUser), settings);
      case chatScreen:
        ChatPage? chatPage;
        if (settings.arguments is UserConversation) chatPage = ChatPage(userConversation: settings.arguments as UserConversation);
        if (settings.arguments is ChatUser) chatPage = ChatPage(chatUser: settings.arguments as ChatUser);
        return pageRouteBuilder(chatPage!, settings);
      case videoCallScreen:
        return pageRouteBuilder(VideoCallScreen(userCallChannel: settings.arguments as UserCallChannel), settings);
      case myProfileScreen:
        return pageRouteBuilder(const MyProfileScreen(), settings);
      case settingsScreen:
        return pageRouteBuilder(const SettingsScreen(), settings);
      case searchScreen:
        return pageRouteBuilder(const SearchScreen(), settings);
      case registerScreen:
        return pageRouteBuilder(const RegisterPage(), settings);
      case createGroupScreen:
        return pageRouteBuilder(const CreateGroupScreen(), settings);
      case conversationInfoScreen:
        Map<String, dynamic> map = settings.arguments as Map<String, dynamic>;
        return pageRouteBuilder(
          ConversationInfoScreen(
            type: map["type"] as String,
            group: map["group"] as Group,
          ),
          settings,
        );
      case qrCodeScannerScreen:
        return pageRouteBuilder(const QrCodeScannerScreen(), settings);
      default:
        return errorRoute();
    }
  }

  static Route<dynamic> errorRoute() {
    return MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('error'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text('page_not_found'),
        ),
      );
    });
  }

  static pageRouteBuilder(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1, 0);
        const end = Offset(0, 0);
        const curve = Curves.ease;
        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        final offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
}
