import 'package:flutter/material.dart';

class ProfileSheetList extends StatelessWidget {
  const ProfileSheetList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/profile.png'),
            ),
            const SizedBox(height: 10),
            const Text(
              'KBOT09',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'NEWUSER06@GMAIL.COM',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Divider(
              thickness: 1,
            ),
            TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.onSecondary),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Log Out',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ));
  }
}
