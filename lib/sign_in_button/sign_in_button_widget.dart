import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';

class SignInButtonWidget extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 24),
      children: [
        const SizedBox(height: 60.0),
        Center(
          child: SignInButton(Buttons.google, onPressed: () {}),
        ),
        const SizedBox(height: 8.0),
        Center(
          child: SignInButton(Buttons.facebook, onPressed: () {}),
        ),
        const SizedBox(height: 8.0),
        Center(
          child: SignInButton(Buttons.appleDark, onPressed: () {}),
        ),
      ],
    );
  }
}