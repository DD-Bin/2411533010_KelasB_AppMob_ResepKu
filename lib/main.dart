import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resepku/pages/home_page.dart';
import 'package:resepku/providers/favorite_provider.dart';
import 'package:resepku/providers/theme_provider.dart';
import 'package:resepku/widgets/identity_footer.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FavoriteProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const ResepKuApp(),
    ),
  );
}

class ResepKuApp extends StatelessWidget {
  const ResepKuApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Membaca state dari ThemeProvider agar UI mendengarkan perubahan tema
    final themeMode = context.watch<ThemeProvider>().themeMode;

    return MaterialApp(
      title: 'ResepKu',
      debugShowCheckedModeBanner: false,
      
      // Konfigurasi tema terang
      theme: ThemeData(
        colorSchemeSeed: Colors.deepOrange,
      ),
      
      // Konfigurasi tema gelap (Latihan 1)
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.deepOrange,
        brightness: Brightness.dark,
      ),
      
      // Menggunakan state dari provider (Latihan 1)
      themeMode: themeMode, 
      
      // Footer identitas wajib ada
      builder: (context, child) => IdentityFooter(child: child!),
      
      home: const HomePage(),
    );
  }
}