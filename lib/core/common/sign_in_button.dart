import 'package:flutter/material.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/theme/pallete.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ElevatedButton.icon(
        label: const Text(
          'Continue with google',
          style: TextStyle(fontSize: 18),
        ),
        icon: Image.asset(
          Constants.googlePath,
          width: 35,
        ),
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Pallete.greyColor,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(29),
          ),
        ),
      ),
    );
  }
}
