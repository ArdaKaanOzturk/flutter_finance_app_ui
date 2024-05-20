import 'package:dribble_finance_app_design/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(Icons.notifications_none),
          )
        ],
      ),
      body: SlidingUpPanel(
        panel: Center(
          child: Text("Sliding Widget"),
        ),
        body: const Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                children: [
                  Text("Available balance"),
                  Row(
                    children: [
                      Text("\$"),
                      SizedBox(width: 2),
                      Text("4820.23")
                    ],
                  )
                ],
              ),
            )
          ],
        )
      ),
    );
  }
}