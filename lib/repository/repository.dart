import 'package:suit_up/models/category.dart';

class Repository {
  final List<Category> categories = <Category>[
    Category("res/images/category_t_shirts.png", "T-shirts"),
    Category("res/images/category_sweaters.png", "Sweaters"),
    Category("res/images/category_jeans.png", "Jeans"),
    Category("res/images/category_trousers.png", "Trousers"),
    Category("res/images/category_dress.png", "Dress"),
    Category("res/images/category_skirts.png", "Skirts"),
    Category("res/images/category_jackets.png", "Jackets")
  ];
}
