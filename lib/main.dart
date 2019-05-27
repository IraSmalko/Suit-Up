import 'package:cached_network_image/cached_network_image.dart';
import 'package:di_container/di_container.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suit_up/repository/repository.dart';
import 'package:suit_up/widgets/categories_list.dart';

import 'models/category.dart';

void main() async {
  runApp(MyApp());

  final x = await SharedPreferences.getInstance();
  Injector.register(type: Type.singleton, builder: () => x);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Suit up",
      theme: ThemeData(
          backgroundColor: Colors.white,
          accentColor: Colors.black,
          bottomAppBarTheme: BottomAppBarTheme(color: Colors.white)),
      home: Container(
        padding: const EdgeInsets.all(8.0),
        child: _BottomTabbarPage(),
      ),
    );
  }
}

class _BottomTabbarPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BottomTabbarPageState();
}

class _BottomTabbarPageState extends State<_BottomTabbarPage> with SingleTickerProviderStateMixin {
  TabController _tabController;

  static final List<Category> categories = Repository.instance.categories;

  var _kTabPages = <Widget>[
    Center(child: CategoriesList(categories)),
    Center(child: MyHomePage(title: "Suit up")),
    Center(child: Icon(Icons.forum, size: 64.0, color: Colors.blue)),
    Center(child: Icon(Icons.forum, size: 64.0, color: Colors.blue)),
  ];
  static const _kTabs = <Tab>[
    Tab(icon: Icon(Icons.thumb_up, size: 24), text: 'Сlothing'),
    Tab(icon: Icon(Icons.burst_mode, size: 24), text: 'LookBook'),
    Tab(icon: Icon(Icons.refresh, size: 24), text: 'Random'),
    Tab(icon: Icon(Icons.calendar_today, size: 24), text: 'Calendar'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _kTabPages.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          backgroundColor: Colors.white,
          title: Text("text"),
          bottom: TabBar(
            labelStyle: TextStyle(color: Colors.black, fontStyle: FontStyle.italic, fontSize: 10),
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black12,
            tabs: _kTabs,
            controller: _tabController,
          ),
        ),
        preferredSize: Size.fromHeight(74),
      ),
      body: TabBarView(
        children: _kTabPages,
        controller: _tabController,
      ),
      backgroundColor: Colors.white,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, @required this.title}) : super(key: key);

  final String title;
  final wordPair = WordPair.random();

  @override
  _MyHomePageState createState() => _MyHomePageState(title);
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String s;

  _MyHomePageState(this.s);

  void _incrementCounter(BuildContext co) {
    _showToast(co);
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
    _counter = 5;
  }

  @override
  Widget build(BuildContext context) {
    final key = new GlobalKey<ScaffoldState>();
    return Scaffold(
        key: key,
        appBar: null,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'You have pushed the button this many times:',
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CachedNetworkImage(
                    height: 80,
                    width: 80,
                    imageUrl: "https://cdn-images-1.medium.com/max/1000/1*JVWWKVOoQ6ZmGFXWN7iRjA.png",
                    placeholder: (q, w) => CircularProgressIndicator(),
                    errorWidget: (q, w, e) => Text(e.toString()),
                  ),
                ),
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.display1,
              ),
            ],
          ),
        ),
        floatingActionButton: new Builder(builder: (BuildContext context) {
          return FloatingActionButton(
            elevation: 5,
            onPressed: () => pickImage(ImageSource.camera),
            tooltip: 'Increment',
            child: Icon(Icons.add),
          );
        }));
  }

  pickImage(ImageSource source) async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
  }

  void _showToast(BuildContext co) {
    Scaffold.of(co).showSnackBar(
      SnackBar(
        content: const Text('Added to favorite'),
      ),
    );
  }
}
