import 'package:flutter/material.dart';
import 'package:myplugin/my_plugin.dart';

void main() => runApp(MyApp());

@pragma('vm:entry-point')
void send() {

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //initialRoute: '/',
      routes: {
        //'/': (context) => MyHomePage(title: 'title'),
        '/my_route': (context) => MySecondPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            FutureBuilder<int>(
                initialData: 0,
                future: MyPlugin.instance.sum(1, 2),
                builder: (context, data) {
                  return Text('${data.data}');
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class MySecondPage extends StatelessWidget {
  const MySecondPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('second page'),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              MyPlugin.instance.startCounter();
            },
            child: Container(
              height: 50,
              width: 100,
              color: Colors.redAccent,
              alignment: Alignment.center,
              child: const Text('startCounter'),
            ),
          ),
          StreamBuilder<int>(
              initialData: 0,
              stream: MyPlugin.instance.eventFor(),
              builder: (context, data) {
                return Text('${data.data}');
              }),
        ],
      ),
    );
  }
}
