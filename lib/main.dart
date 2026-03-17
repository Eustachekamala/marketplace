import 'package:flutter/material.dart';
import 'package:marketplace_supabase/screens/auth/auth_screen.dart';
import 'package:marketplace_supabase/screens/product/product_list_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // We Initialize supabase here.
  await Supabase.initialize(
    url: "https://zsmznbygbrrglmfsrxor.supabase.co",
    anonKey: "sb_publishable_rL5BXpSwQePvM67EqBAJYA__nOYeZSt");
  runApp(const MyApp());
}

  final SupabaseClient supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Marketplace',
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: StreamBuilder(
        stream: supabase.auth.onAuthStateChange, 
        builder: (context, snapshot) {
          // we get the session here
          final session = snapshot.data?.session;
          if (session != null) {
            return const ProductListScreen();
          } else {
            return const AuthScreen();
          }
        },
      ),
    );
  }
}