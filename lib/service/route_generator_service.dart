import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/model/user.dart';
import 'package:flutter_chat_app/model/user_conversation.dart';
import 'package:flutter_chat_app/screen/chat_screen.dart';
import 'package:flutter_chat_app/screen/home_screen.dart';
import 'package:flutter_chat_app/screen/login_screen.dart';
import 'package:flutter_chat_app/screen/splash_screen.dart';

class RouteGeneratorService {
  static const String splashScreen = '/splash-screen';
  static const String loginScreen = '/login-screen';
  static const String chatScreen = '/chat-screen';
  static const String homeScreen = '/home-screen';

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
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
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
