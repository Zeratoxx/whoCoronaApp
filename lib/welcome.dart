import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

const brightYellow = Color(0xFFFFD300);
const darkYellow = Color(0xFFFFB900);

const message1 = "Diese App dient dazu, ihre Freunde und Familie im Zuge ihrer "
    "Infektion mit dem Coronavirus zu warnen und über die nächsten notwendigen "
    "Schritte aufzuklären.";
const message2 = "Bitte nehmen sie sich ein paar Minuten Zeit um sich "
    "zu Überlegen, mit wem sie in den letzten zwei Wochen Kontakt hatten.";
const message3 = "Anschließend können sie eine vorgefertigte Nachricht an "
    "diese Personengruppe absetzen.";

class _WelcomeScreenState extends State<WelcomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: brightYellow,
      body: Column(
        children: [
          Flexible(
            flex: 5,
            child: FlareActor(
              'assets/bus.flr',
              alignment: Alignment.center,
              fit: BoxFit.cover,
              animation: 'driving',
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                  ),
                  child: Text(
                    message1,
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20.0),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8, top: 8),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                  ),
                  child: Text(
                    message2,
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20.0),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8, top: 8),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                  ),
                  child: Text(
                    message3,
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20.0),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 40),
                ),
                RaisedButton(
                  color: darkYellow,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  child: Text(
                    'Verstanden!',
                    style: TextStyle(fontWeight: FontWeight.normal,
                        fontSize: 18.0,
                        color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        new MaterialPageRoute(builder: (context) => new CoronaDashboard()));
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 64),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}