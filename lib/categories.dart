import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  final List<Map<String, dynamic>> categories = const [
    {
      'name': 'Personal',
      'count': 12,
      'icon': Icons.article_rounded,
      'color': Color(0xFFF06292),
      'background': Color(0xFFFFF0F5),
    },
    {
      'name': 'Work',
      'count': 8,
      'icon': Icons.work_rounded,
      'color': Color(0xFF2196F3),
      'background': Color(0xFFEAF5FF),
    },
    {
      'name': 'Ideas',
      'count': 6,
      'icon': Icons.lightbulb_rounded,
      'color': Color(0xFFFFC629),
      'background': Color(0xFFFFF9E5),
    },
    {
      'name': 'Shopping',
      'count': 5,
      'icon': Icons.shopping_cart_rounded,
      'color': Color(0xFF39B86A),
      'background': Color(0xFFE9FAEF),
    },
    {
      'name': 'Travel',
      'count': 4,
      'icon': Icons.flight_rounded,
      'color': Color(0xFF8B5CF6),
      'background': Color(0xFFF2EDFF),
    },
    {
      'name': 'Others',
      'count': 3,
      'icon': Icons.grid_view_rounded,
      'color': Color(0xFF1687E8),
      'background': Color(0xFFEDF6FF),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black87,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Categories',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: GridView.builder(
          // Extra horizontal padding makes each card narrower.
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          itemCount: categories.length,
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 12,

            // Higher ratio means shorter cards.
            childAspectRatio: 1.35,
          ),
          itemBuilder: (context, index) {
            final category = categories[index];

            final String name = category['name'] as String;
            final int count = category['count'] as int;
            final IconData icon = category['icon'] as IconData;
            final Color color = category['color'] as Color;
            final Color background =
            category['background'] as Color;

            return InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {
                Navigator.pop(context, name);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: background,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: color.withValues(alpha: 0.10),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height:25,
                      width: 25,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.13),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        icon,
                        color: color,
                        size: 22,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF202033),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '$count Notes',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF777789),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
