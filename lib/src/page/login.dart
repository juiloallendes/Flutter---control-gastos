import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../login_state.dart';

class LoginPage extends StatelessWidget {


  const LoginPage({Key key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          child: Text('Login in'),
          onPressed: () {
            Provider.of<LoginState>(context).login();
          }
        ),
      ),
    );
  }
}