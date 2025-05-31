import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DialogWidget extends StatelessWidget {
  // Dialog Informasi
  void showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Informasi"),
          content: Text("Ini adalah dialog informasi."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Tutup"),
            ),
          ],
        );
      },
    );
  }

  // Dialog Konfirmasi
  void showConfirmDialog(
      BuildContext context, String message, String title, action) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Back"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                action;
              },
              child: Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
