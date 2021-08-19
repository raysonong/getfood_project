import 'package:flutter/material.dart';
import 'package:getfood_project/style.dart';

void showDialogOK(BuildContext context, String title, String content,
    Function performAction) {
  showDialog(
    context: context,
    builder: (_) => new AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: borderRadiusStyle),
      title: Text(
        title,
        style: Theme.of(context).textTheme.headline2,
      ),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () {
            // Close the dialog
            Navigator.of(context).pop();
            // Action
            performAction();
          },
          child: Text(
            'Ok',
            style: TextStyle(color: primaryColorStyle),
          ),
        ),
      ],
    ),
  );
}

void showDialogConfirm(BuildContext context, String title, String content,
    Function _performAction) {
  showDialog(
    context: context,
    builder: (_) => new AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: borderRadiusStyle),
      title: Text(
        title,
        style: Theme.of(context).textTheme.headline2,
      ),
      content: Text(
        content,
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Perform action by executing the function
            _performAction();
            // Close the dialog
            Navigator.of(context).pop();
          },
          child: Text(
            'Yes',
            style: TextStyle(color: primaryColorStyle),
          ),
        ),
        TextButton(
          onPressed: () {
            // Close the dialog
            Navigator.of(context).pop();
          },
          child: Text(
            'No',
            style: TextStyle(color: primaryColorStyle),
          ),
        ),
      ],
    ),
  );
}
