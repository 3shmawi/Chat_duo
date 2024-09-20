import 'package:flutter/material.dart';

toPage(context, page) => Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );

toAndReplace(context, page) => Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );

toAndFinish(context, page) => Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => page),
      (route) => false,
    );
