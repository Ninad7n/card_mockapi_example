import 'package:card_mockapi_example/repositories/card_repo.dart';
import 'package:card_mockapi_example/services/api_client.dart';
import 'package:card_mockapi_example/view/home_screen/home_screen.dart';
import 'package:card_mockapi_example/view_model/card_provider_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await dotenv.load(fileName: ".env");
  try {
    await dotenv.load(fileName: ".env");
    print('dotenv loaded: ${dotenv.env.keys.length} keys');
  } catch (e, s) {
    print('dotenv load failed: $e\n$s');
  }
  runApp(const MyCardApp());
}

class MyCardApp extends StatelessWidget {
  const MyCardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiClient>(create: (_) => ApiClient()),
        Provider<CardRepo>(
          create: (context) => CardRepo(apiClient: context.read<ApiClient>()),
        ),
        ChangeNotifierProvider<CardProviderModel>(
          create: (context) =>
              CardProviderModel(cardRepo: context.read<CardRepo>()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
      ),
    );
  }
}
