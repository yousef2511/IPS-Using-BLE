
import 'package:flutter/material.dart';
import 'newB.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/pp2.jpg'),
                fit: BoxFit.fill,
              ),
            ),
            child: Center(
                child: Column(children: [
              SizedBox(height: 600),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FlutterBlueApp(),
                    ),
                  );
                },
                child: Text('Connect Manually'),
              ),


            ]))));
  }
}
