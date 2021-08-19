import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
// Theme and Style
import 'package:getfood_project/style.dart';

// About Screen
class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: screenPaddingStyle,
      shrinkWrap: true,
      children: <Widget>[
        // Our Application Section
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Heading
              Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  'Our Application',
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
              // End of Heading
              // Paragraph
              Text(
                'GetFood uses delivers your favourite food anytime, anywhere and even right at your door step.',
                textAlign: TextAlign.justify,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              // End of Paragraph
            ],
          ),
        ),
        // End of Our Application Section
        SizedBox(
          height: 30,
        ),
        // Our Company Section
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Heading
              Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  'Our Company',
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
              // End of Heading
              // Paragraph
              Text(
                'GetFood is founded in 2021 by Rayson Ong. This application will help the user to order their food, desserts and drinks from their favorite store without directly going to the store as it will ease the time and effort to walk and travel there in order to be able to order their food.',
                textAlign: TextAlign.justify,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              // End of Paragraph
            ],
          ),
        ),
        // End of Our Company Section
        SizedBox(
          height: 30,
        ),
        // Contact Us Section
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Heading
              Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  'Contact Us',
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
              // End of Heading
              // Paragraph
              Text(
                'Rayson Ong',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              SizedBox(
                height: 5,
              ),
              ContactButton('tel', '+65 9234 5678'),
              SizedBox(
                height: 30,
              ),
              Text(
                'GetFood',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              SizedBox(
                height: 5,
              ),
              ContactButton('tel', '+65 6987 1234'),
              ContactButton('mailto', 'email@getfood.com'),
              // End of Paragraph
            ],
          ),
        ),
        // End of Contact Us Section
      ],
    );
  }
}
// End of About Screen

// Contact Button
class ContactButton extends StatelessWidget {
  final String contactType;
  final String url;

  ContactButton(this.contactType, this.url);

  // Launch contact number or email
  void launchContact(command) async {
    // If able to launch
    if (await canLaunch(command)) {
      await launch(command);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => launchContact(contactType + ":" + url),
      child: Text(
        url,
        style: TextStyle(
          fontSize: 16,
          color: primaryColorStyle,
        ),
      ),
    );
  }
}
// End of Contact Button
