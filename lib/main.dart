import 'package:flutter/material.dart';
import 'package:rock_paper_scissors/components/colors.dart';
import 'package:rock_paper_scissors/game_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: AppColors.primary,
        primaryColorLight: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        brightness: Brightness.light,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          toolbarHeight: 0.0,
          backgroundColor: Colors.transparent,
        ),
        textTheme: TextTheme(
          headlineLarge: TextStyle(
            color: AppColors.textBlack,
            fontSize: 45.0,
            fontWeight: FontWeight.w900,
          ),
          displayLarge: TextStyle(
            color: AppColors.textWhite,
            fontSize: 45.0,
            fontWeight: FontWeight.w200,
          ),
          displayMedium: TextStyle(
            color: AppColors.textBlack,
            fontSize: 25.0,
            fontWeight: FontWeight.w900,
          ),
          labelLarge: TextStyle(
            fontSize: 18.0,
            color: AppColors.textWhite,
            fontWeight: FontWeight.w400,
          ),
          titleMedium: TextStyle(
            fontSize: 22.0,
            color: AppColors.textBlack,
            fontWeight: FontWeight.w300,
          ),
          bodyLarge: TextStyle(
            fontSize: 18.0,
            color: AppColors.textBlack,
            fontWeight: FontWeight.w400,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(AppColors.primary),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            )),
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        primaryColor: AppColors.primary,
        primaryColorLight: AppColors.primary,
        scaffoldBackgroundColor: AppColors.backgroundDark,
        brightness: Brightness.dark,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          toolbarHeight: 0.0,
          backgroundColor: Colors.transparent,
        ),
        textTheme: TextTheme(
          headlineLarge: TextStyle(
            color: AppColors.textWhite,
            fontSize: 45.0,
            fontWeight: FontWeight.w900,
          ),
          displayLarge: TextStyle(
            color: AppColors.textWhite,
            fontSize: 45.0,
            fontWeight: FontWeight.w200,
          ),
          displayMedium: TextStyle(
            color: AppColors.textWhite,
            fontSize: 25.0,
            fontWeight: FontWeight.w900,
          ),
          labelLarge: TextStyle(
            fontSize: 18.0,
            color: AppColors.textWhite,
            fontWeight: FontWeight.w400,
          ),
          titleMedium: TextStyle(
            fontSize: 22.0,
            color: AppColors.textWhite,
            fontWeight: FontWeight.w300,
          ),
          bodyLarge: TextStyle(
            fontSize: 18.0,
            color: AppColors.textWhite,
            fontWeight: FontWeight.w400,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(AppColors.primary),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            )),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'ROCK\n/ PAPER /\nSCISSORS',
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
            Image.asset(
              'assets/hands/paper.png',
              scale: 1,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 60.0,
              child: TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const GameScreen()));
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(AppColors.background),
                ),
                child: Text(
                  'START',
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(color: AppColors.textBlack),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

