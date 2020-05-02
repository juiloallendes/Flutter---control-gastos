import 'package:control_gastos/login_state.dart';
import 'package:control_gastos/src/page/add.dart';
import 'package:control_gastos/src/page/home.dart';
import 'package:control_gastos/src/page/login.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {

  //color app: Color(0xFF6C63FF)

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

bool _logg = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginState>(
      create: (BuildContext context) => LoginState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter',
        theme: ThemeData(
          primarySwatch: Colors.blue
        ),
        routes: {
          '/' : (BuildContext context) {
            var state = Provider.of<LoginState>(context);
            if (state.isloggedIn()) {
              return HomePage();
            } else {
              return LoginPage();
            }
          },
          '/add' : (BuildContext context) => AddPage()
        },
      ),
    );
  }
}



