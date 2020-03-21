import 'package:flutter/material.dart';
import 'utils.dart';

Widget buildVirusAvatar(BuildContext context) {
  return IconButton(
    iconSize: 40,
    padding: EdgeInsets.all(0),
    icon: CircleAvatar(
      backgroundColor: Colors.grey.shade300,
      child: CircleAvatar(radius: 16, backgroundImage: AssetImage('assets/corona.png')),
    ),
    onPressed: () {launchURL();},
  );
}

Container buildTitledContainer(String title, {Widget child, double height}) {
  return Container(
    padding: const EdgeInsets.all(16.0),
    width: double.infinity,
    height: height,
    // Aussehen der Box
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20.0),
      color: Colors.white,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 28.0),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 4),
        ),
        if (child != null) ...[const SizedBox(height: 10.0), child]
      ],
    ),
  );
}

AppBar buildAppBar(BuildContext context) {
  return AppBar(
    iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
    titleSpacing: 15,
    // Um Schatten zu verhindern
    elevation: 0.5,
    backgroundColor: Colors.white,
    title: Text(
      "Corona Alarm",
      style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20.0
      ),
      textAlign: TextAlign.center,
    ),
    // Muss ein Array sein
    actions: <Widget>[buildVirusAvatar(context)],
  );
}