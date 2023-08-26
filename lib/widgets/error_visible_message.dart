import 'package:flutter/material.dart';

const String errorMessage = 'You should add all Pieces';

class IsErrorText {
  static Visibility buildErrorSectionVisible(isError) {
    return Visibility(
      visible: isError,
      child: const Padding(
        padding: EdgeInsets.all(10.0),
        child: Text(
          errorMessage,
          style: TextStyle(
            color: Color.fromARGB(255, 23, 63, 155),
          ),
        ),
      ),
    );
  }
}
