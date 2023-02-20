import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Models/Curenccy.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // ignore: prefer_const_literals_to_create_immutables
      supportedLocales: [
        const Locale('fa', ''), // farsi
      ],
      theme: ThemeData(
          fontFamily: "dana",
          textTheme: const TextTheme(
              displayLarge: TextStyle(
                fontFamily: "dana",
                fontSize: 16,
                fontWeight: FontWeight.w100,
              ),
              bodyMedium: TextStyle(
                fontFamily: "dana",
                fontSize: 10,
                color: Colors.white,
                fontWeight: FontWeight.w100,
              ),
              bodyLarge: TextStyle(
                fontFamily: "dana",
                fontSize: 10,
                fontWeight: FontWeight.normal,
              ),
              displayMedium: TextStyle(
                fontFamily: "dana",
                fontSize: 10,
                color: Colors.red,
                fontWeight: FontWeight.w100,
              ),
              displaySmall: TextStyle(
                fontFamily: "dana",
                fontSize: 10,
                color: Colors.green,
                fontWeight: FontWeight.w100,
              ))),
      debugShowCheckedModeBanner: false,
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Currency> currency = [];
  Future getResponse(BuildContext cnxt) async {
    var url = "http://sasansafari.com/flutter/api.php?access_key=flutter123456";
    var value = await http.get(Uri.parse(url));

    if (currency.isEmpty) {
      if (value.statusCode == 200) {
        // ignore: use_build_context_synchronously
        _showSnackbar(context, "بروزرسانی با موفقیت انجام شد");

        List jsonList = convert.jsonDecode(value.body);

        if (jsonList.isNotEmpty) {
          for (int i = 0; i < jsonList.length; i++) {
            setState(() {
              currency.add(Currency(
                  id: jsonList[i]["id"],
                  title: jsonList[i]["title"],
                  price: jsonList[i]["price"],
                  changes: jsonList[i]["changes"],
                  status: jsonList[i]["status"]));
            });
          }
        }
      }
    }

    return value;
  }

  @override
  void initState() {
    super.initState();
    getResponse(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 243, 243, 243),
        appBar: AppBar(elevation: 0, backgroundColor: Colors.white, actions: [
          Image.asset("assets/images/icon.png"),
          Align(
              alignment: Alignment.centerRight,
              child: Text(
                "قیمت بروز ارز",
                style: Theme.of(context).textTheme.displayLarge,
              )),
          Expanded(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Image.asset("assets/images/menu.png"))),
          const SizedBox(
            width: 16,
          ),
        ]),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset("assets/images/qicon.png"),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    "نرخ ارز آزاد چیست؟",
                    style: Theme.of(context).textTheme.displayLarge,
                  )
                ],
              ),
              Text(
                "نرخ ارزها در معاملات نقدی و رایج روزانه است معاملات نقدی معاملاتی هستند که خریدار و فروشنده به محض انجام معامله، ارز و ریال را با هم تبادل می نمایند.",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Container(
                  height: 35,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: const Color.fromARGB(255, 147, 147, 147)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("نام آزاد ارز",
                          style: Theme.of(context).textTheme.bodyMedium),
                      Text("  قیمت",
                          style: Theme.of(context).textTheme.bodyMedium),
                      Text("  تغییر",
                          style: Theme.of(context).textTheme.bodyMedium)
                    ],
                  ),
                ),
              ),
              SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 1.8,
                  child: listFutureBuilder(context)),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 16,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 232, 232, 232),
                      borderRadius: BorderRadius.circular(1000)),
                  child: Row(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 16,
                        width: 180,
                        child: TextButton.icon(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color.fromARGB(255, 202, 193, 255)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(1000))),
                            ),
                            onPressed: () {
                              currency.clear();
                              listFutureBuilder(context);
                            },
                            icon: const Icon(CupertinoIcons.refresh_bold),
                            label: Text(
                              "بروزرسانی",
                              style: Theme.of(context).textTheme.displayLarge,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: Text(
                          "آخرین بروزرسانی ${getFarsiNumber(_gettime())}",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ]),
          ),
        ));
  }

  FutureBuilder<dynamic> listFutureBuilder(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: currency.length,
                itemBuilder: (BuildContext context, int postion) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: MyItem(postion, currency),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  if (index % 9 == 0) {
                    return const Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: add(),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
      future: getResponse(context),
    );
  }

  String _gettime() {
    DateTime now = DateTime.now();

    return DateFormat('kk:mm:ss').format(now);
  }
}

void _showSnackbar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: Theme.of(context).textTheme.bodyMedium),
      backgroundColor: Colors.green));
}

// ignore: must_be_immutable
class MyItem extends StatelessWidget {
  int position;
  List<Currency> currency;
  MyItem(this.position, this.currency, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        boxShadow: const <BoxShadow>[
          BoxShadow(blurRadius: 1.0, color: Colors.grey)
        ],
        borderRadius: BorderRadius.circular(100),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            getFarsiNumber(currency[position].title.toString()),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            getFarsiNumber(currency[position].price.toString()),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            getFarsiNumber(currency[position].changes.toString()),
            style: currency[position].status == "n"
                ? Theme.of(context).textTheme.displayMedium
                : Theme.of(context).textTheme.displaySmall,
          ),
        ],
      ),
    );
  }
}

// ignore: camel_case_types
class add extends StatelessWidget {
  const add({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        boxShadow: const <BoxShadow>[
          BoxShadow(blurRadius: 1.0, color: Colors.grey)
        ],
        borderRadius: BorderRadius.circular(100),
        color: Colors.red,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "تبلیغات",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

String getFarsiNumber(String number) {
  const en = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const fa = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];

  for (var element in en) {
    number = number.replaceAll(element, fa[en.indexOf(element)]);
  }
  return number;
}
