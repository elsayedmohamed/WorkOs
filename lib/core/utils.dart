


import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

void showSnakError(error,context) {
    final myErrorSnack = SnackBar(
      content: Text(error),
      duration: const Duration(
        seconds: 3,
      ),
      backgroundColor: Colors.pink,
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      width: 300,
      behavior: SnackBarBehavior.floating,
      elevation: 10,
    );

    ScaffoldMessenger.of(context).showSnackBar(myErrorSnack);
  }


   Future<Object?> navigateToPage(BuildContext context, Widget screen) async {
    return await Navigator.push(
        context, MaterialPageRoute(builder: (context) => screen));
  }
   Future<Object?> navigateToPageAndFinsh(BuildContext context, Widget screen) async {
    return await Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => screen));
  }


  void showToast(String msg,context, {int? duration, int? gravity}) {
    ToastContext().init(context);
    Toast.show(msg, duration: duration, gravity: gravity);
  }