import 'package:flutter/material.dart';
import 'package:flutter_chat_app/common/scroll_behavior.dart';
import 'package:flutter_chat_app/common/shared_preferences.dart';
import 'package:flutter_chat_app/shared/constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = SharedPreference.getDarkMode() ?? false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 5,
          backgroundColor: isDarkMode ? Colors.black45 : Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context, isDarkMode);
            },
            icon: Icon(
              Icons.arrow_back,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
        backgroundColor: isDarkMode ? Colors.black45 : Colors.white,
        body: ScrollConfiguration(
          behavior: RemoveGlowingBehavior(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    setState(() {
                      isDarkMode = !isDarkMode;
                      SharedPreference.saveDarkMode(isDarkMode);
                    });
                  },
                  leading: isDarkMode ? const Icon(Icons.dark_mode, color: Constants.primaryColor) : const Icon(Icons.light_mode, color: Constants.primaryColor),
                  title: Text(
                    "Dark mode",
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  trailing: Switch(
                    value: isDarkMode,
                    activeColor: Constants.primaryColor,
                    inactiveThumbColor: Colors.red,
                    onChanged: (value) {
                      setState(() {
                        isDarkMode = !isDarkMode;
                      });
                    },
                  ),
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.account_box, color: Constants.primaryColor),
                  title: Text(
                    "Account",
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_back_ios,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
