import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workify/theme/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  bool getTheme(BuildContext context) {
    return Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings Page"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ListTile(
            title: Text("Theme"),
            trailing: IconButton(
                onPressed:
                    Provider.of<ThemeProvider>(context, listen: false).toggle,
                icon: (getTheme(context)
                    ? Icon(Icons.mode_night)
                    : Icon(Icons.sunny))),
          ),
        ],
      ),
    );
  }
}
