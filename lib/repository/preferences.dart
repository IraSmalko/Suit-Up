import 'package:di_container/di_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  SharedPreferences prefs = Injector.get();
}
