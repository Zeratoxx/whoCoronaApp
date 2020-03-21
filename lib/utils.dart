import 'package:url_launcher/url_launcher.dart';

void launchURL() async {
  const url = 'https://www.rki.de/DE/Content/InfAZ/N/Neuartiges_Coronavirus/Fallzahlen.html';
  if (await canLaunch(Uri.encodeFull(url))) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

