import 'package:suit_up/models/category.dart';

class Repository {
  static Repository instance = Repository._internal();

  Repository._internal();

  final List<Category> categories = <Category>[
    Category("res/images/category_t_shirts.png", "T-shirts"),
    Category("res/images/category_sweaters.png", "Sweaters"),
    Category("res/images/category_jeans.png", "Jeans"),
    Category("res/images/category_trousers.png", "Trousers"),
    Category("res/images/category_dress.png", "Dress"),
    Category("res/images/category_skirts.png", "Skirts"),
    Category("res/images/category_jackets.png", "Jackets")
  ];

  final List<Category> dress = <Category>[
    Category("res/images/dress_1.jpg", "T-shirts"),
    Category("res/images/dress_2.jpg", "Sweaters"),
    Category("res/images/dress_3.jpg", "Jeans"),
    Category("res/images/dress_4.jpg", "Trousers"),
    Category("res/images/dress_5.jpg", "Dress"),
    Category("res/images/dress_6.jpg", "Dress"),
    Category("res/images/dress_1.jpg", "T-shirts"),
    Category("res/images/dress_2.jpg", "Sweaters"),
    Category("res/images/dress_3.jpg", "Jeans")
  ];
}
