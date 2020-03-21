import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:nice_button/nice_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:async';
import 'dart:convert';
import 'ui.dart';
import 'welcome.dart';

void main() => runApp(CoronaApp());

class CoronaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Corona Alarm',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey.shade300,
        primarySwatch: Colors.red,
        accentColor: Colors.indigo,
      ),
      home: Splash(),
    );
  }
}

class Splash extends StatefulWidget {
  @override
  SplashState createState() => new SplashState();
}

class SplashState extends State<Splash> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new CoronaDashboard()));
    } else {
      await prefs.setBool('seen', true);
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new WelcomeScreen()));
    }
  }

  @override
  void initState() {
    super.initState();
    checkFirstSeen();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Text('Loading...'),
      ),
    );
  }
}


class CoronaDashboard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).buttonColor,
      appBar: buildAppBar(context),
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        // Corona Fälle Insgesamt/Todesfälle/Kuriert
        _buildGeneralCoronaStats(),
        // Chart
        _buildCharts(),
        _panicButton(context),
      ],
    );
  }

  SliverPadding _buildCharts() {
    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverToBoxAdapter(
          child: buildTitledContainer("Statistik",
              child: Container(
                  height: 200, child: StackedAreaLineChart.withSampleData())),
      )
    );
  }

  Container _buildStatBox(int value, String title, Color color){

    final TextStyle stats = TextStyle(
        fontWeight: FontWeight.normal, fontSize: 20.0, color: Colors.white);

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: color,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            value.toString(),
            style: stats,
          ),
          const SizedBox(height: 5.0),
          Text(title.toUpperCase())
        ],
      ),
    );
  }

  Future<ApiResponse> makeApiCall() async {
    final response = await http.get('https://coronavirus-19-api.herokuapp.com/countries/germany');

    if (response.statusCode == 200) {
      print("Okay!!!!");
      return ApiResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to call API');
    }
  }

  SliverPadding _buildGeneralCoronaStats() {

    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverGrid.count(
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 1.5,
        crossAxisCount: 3,
        children: <Widget>[
          _buildStatBox(19848, "Inifiziert", Colors.blue),
          _buildStatBox(68, "Todesfälle", Colors.red),
          _buildStatBox(180, "Genesen", Colors.green),
        ],
      ),
    );
  }

  SliverPadding _panicButton(BuildContext context) {

    const msg = "*Automatisierte Warnnachricht* "
        "Hallo, ich wurde positiv auf das COVID-19-Virus getestet. Falls wir beide innerhalb der letzten zwei Wochen engen Kontakt zueinander hatten, bist auch du verpflichtet, dich in eine 14-tägige Quarantäne zu begeben (siehe www.rki.de/SharedDocs/FAQ/NCOV2019/FAQ_Liste.html). Als enger Kontakt zählen Anhusten, Anniesen oder auch schon ein mehrminütiges Gespräch."
        "Sollten wir uns ausschließlich im gleichen Raum befunden haben, bist du zu einer Quarantäne nicht verpflichtet. [Stand 17.03.2020]"
        "Bitte achte in den nächsten 14 Tagen besonders auf mögliche Symtome wie Fieber, Husten und Kurzatmigkeit. Auch Durchfall und Kopfschmerzen können ein Indikator sein. Bitte halte dich in diesem Zeitraum besonders an die Abstandsregeln und verkehre mit so wenigen Menschen wie möglich, um eine Weitergabe zu verhindern. Solltest du Krankheitssymtome bemerken, gehe bitte nicht zum Arzt sondern melde dich telefonisch an. Sollte dein Arzt nicht zu erreichen sein, hilft der ärztliche Bereitschaftsdienst 116117 weiter."
        "_Zusätzliche Hinweise des lokalen Testinstituts:_"
        "Die Teststation im darmstädter Klinikum wird ab nächster Woche nur noch bis 13:00 Uhr geöffnet haben, da es sonst zu Personalengpässen in der Pflege kommen kann (weitere Informationen unter _linkToKlinikumDarmstadt_)."
        "*Diese Nachricht wurde von “CallMyContacts - Corona Warnnachricht” verschickt*"
        "--- https://www.rki.de/SharedDocs/FAQ/NCOV2019/FAQ_Liste.html"
        "---";

    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverToBoxAdapter(
        child: buildTitledContainer(
          "Inifiziert",
          height: 150,

          child: NiceButton(
            background: Color(0xffffffff),
            width: 320,
            elevation: 8.0,
            radius: 52.0,
            text: "Warne deine Angehörigen!",
            gradientColors: [Color(0xffE50026), Color(0xffD8726E)],
            onPressed: () {print("Debug");
            FlutterShareMe()
                .shareToWhatsApp(msg: msg);
            },
          ),
        ),
      ),
    );
  }
}

class StackedAreaLineChart  extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  StackedAreaLineChart(this.seriesList, {this.animate});

  factory StackedAreaLineChart.withSampleData() {
    return new StackedAreaLineChart(
      _createSampleData(),
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.LineChart(seriesList,
        defaultRenderer:
        new charts.LineRendererConfig(includeArea: true, stacked: true),
        animate: animate);
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<LinearSales, int>> _createSampleData() {
    final myFakeDesktopData = [
      new LinearSales(0, 5),
      new LinearSales(1, 25),
      new LinearSales(2, 100),
      new LinearSales(3, 75),
    ];

    var myFakeTabletData = [
      new LinearSales(0, 10),
      new LinearSales(1, 50),
      new LinearSales(2, 200),
      new LinearSales(3, 150),
    ];

    var myFakeMobileData = [
      new LinearSales(0, 15),
      new LinearSales(1, 75),
      new LinearSales(2, 300),
      new LinearSales(3, 225),
    ];

    return [
      new charts.Series<LinearSales, int>(
        id: 'Desktop',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: myFakeDesktopData,
      ),
      new charts.Series<LinearSales, int>(
        id: 'Tablet',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: myFakeTabletData,
      ),
      new charts.Series<LinearSales, int>(
        id: 'Mobile',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: myFakeMobileData,
      ),
    ];
  }
}

/// Sample linear data type.
class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}

class Activity {
  final String title;
  final IconData icon;
  Activity({this.title, this.icon});
}

final List<Activity> activities = [
  Activity(title: "Results", icon: FontAwesomeIcons.listOl),
  Activity(title: "Messages", icon: FontAwesomeIcons.sms),
  Activity(title: "Appointments", icon: FontAwesomeIcons.calendarDay),
  Activity(title: "Video Consultation", icon: FontAwesomeIcons.video),
  Activity(title: "Summary", icon: FontAwesomeIcons.fileAlt),
  Activity(title: "Billing", icon: FontAwesomeIcons.dollarSign),
];

class ApiResponse {

  String country;
  int cases;
  int todayCases;
  int deaths;
  int todayDeaths;
  int recovered;
  int active;
  int critical;
  int casesPerOneMillion;

  ApiResponse({this.cases, this.deaths, this.recovered});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      cases: json['cases'],
      deaths: json['deaths'],
      recovered: json['recovered'],
    );
  }

  int getTotal(){
    return cases;
  }
}
