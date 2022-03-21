import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => Future<void>(() async {
      _sharedPreferences = await SharedPreferences.getInstance();
      runApp(const App());
    });

late final SharedPreferences _sharedPreferences;

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(title: 'Flutter Demo Home Page'),
      );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const String _counterKey = 'counter';

  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _counter = _sharedPreferences.getInt(_counterKey) ?? 0;
  }

  void _incrementCounter() => setState(() {
        _counter++;
        _sharedPreferences.setInt(_counterKey, _counter);
      });

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      );
}
