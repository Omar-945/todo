import 'package:flutter/material.dart';

class ShowNote extends StatelessWidget {
  String title;
  String content;

  ShowNote({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(color: Theme.of(context).colorScheme.onBackground),
      child: Padding(
        padding: EdgeInsets.only(top: 70, right: 20, left: 20, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                title,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontSize: 20,
                      height: 2,
                    ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
                flex: 23,
                child: SingleChildScrollView(
                  child: Text(
                    content,
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(height: 2),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
