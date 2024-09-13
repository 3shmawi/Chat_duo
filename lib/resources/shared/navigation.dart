import 'package:flutter/material.dart';

toPage(BuildContext context, page) => Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );

toAndReplace(BuildContext context, page) =>
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
toAndFinish(BuildContext context, page) =>
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => page,
      ),
      (route) => false,
    );
