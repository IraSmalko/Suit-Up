import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:suit_up/widgets/list_view_builder.dart';

import 'models/category.dart';

void main() => runApp(MyApp());

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
  static final List<Category> entries = <Category>[
    Category(
        "https://media2.newlookassets.com/i/newlook/611091412/womens/clothing/tops/off-white-rolled-sleeve-top.jpg?strip=true&qlt=80&w=720",
        "T-shirts"),
    Category(
        "https://media3.newlookassets.com/i/newlook/630732076/womens/clothing/hoodies-sweatshirts/bright-pink-neon-hoodie.jpg?strip=true&qlt=80&w=720",
        "Sweaters"),
    Category(
        "https://media3.newlookassets.com/i/newlook/605567544M1/womens/clothing/jeans/blue-bleach-wash-super-soft-super-skinny-india-jeans.jpg?strip=true&qlt=80&w=720",
        "Jeans"),
    Category(
        "https://media3.newlookassets.com/i/newlook/618112670M1/womens/clothing/trousers/pink-linen-blend-tapered-trousers.jpg?strip=true&qlt=80&w=720",
        "Trousers"),
    Category(
        "https://media3.newlookassets.com/i/newlook/618913986/womens/clothing/dresses/yellow-herringbone-smock-dress-.jpg?strip=true&qlt=80&w=720",
        "Dress"),
    Category(
        "https://media3.newlookassets.com/i/newlook/606530682M1/womens/clothing/skirts/bright-orange-neon-pleated-midi-skirt-.jpg?strip=true&qlt=80&w=720",
        "Skirts"),
    Category(
        "https://media2.newlookassets.com/i/newlook/618521516/womens/clothing/coats-jackets/stone-twill-double-breasted-blazer-.jpg?strip=true&qlt=80&w=720",
        "Jackets")
  ];

  var _kTabPages = <Widget>[
    Center(child: ListViewBuilder(entries)),
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

  String title;
  var wordPair = WordPair.random();

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
                  child: Image.network("https://cdn-images-1.medium.com/max/1000/1*JVWWKVOoQ6ZmGFXWN7iRjA.png"),
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
            onPressed: () => _incrementCounter(context),
            tooltip: 'Increment',
            child: Icon(Icons.add),
          );
        }));
  }

  void _showToast(BuildContext co) {
    Scaffold.of(co).showSnackBar(
      SnackBar(
        content: const Text('Added to favorite'),
      ),
    );
  }
}
