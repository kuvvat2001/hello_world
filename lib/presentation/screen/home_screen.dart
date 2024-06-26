import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:math_app/data/repository_impl/local__store_repository.dart';
import 'package:math_app/domain/repository/repository.dart';
import 'package:math_app/presentation/screen/books_scrren.dart';
import 'package:math_app/presentation/screen/results_screen.dart';
import 'package:math_app/presentation/screen/statistik_screen.dart';
import 'package:math_app/presentation/screen/tests_ui_screeen.dart';
import 'package:math_app/presentation/utils/const.dart';
import 'package:math_app/presentation/widgets/theme_switch.dart';
import 'package:math_app/provider/active_theme_provider.dart';

import '../theories/theories_equation/equatin_topic.dart';

// constants.dart

// menu_item.dart
class MenuItem {
  final String title;
  final IconData icon;
  final Color color;
  final Widget screen;

  MenuItem(
      {required this.title,
      required this.icon,
      required this.color,
      required this.screen});
}

// home_screen.dart
class HomeScreen extends StatelessWidget implements PreferredSizeWidget {
  const HomeScreen({
    super.key,
    required this.repository,
    required this.pref,
  });
  final IRepository repository;
  final LocalStoreRepository pref;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Matematika",
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        actions: [
          Row(
            children: [
              Consumer(
                  builder: (context, ref, child) => Icon(
                      ref.watch(activeThemeProvider) == Themes.dark
                          ? Icons.dark_mode
                          : Icons.light_mode)),
              const SizedBox(width: 8),
              const ThemeSwitch(),
            ],
          )
        ],
      ),
      body: StaggeredGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: AppConstants.mainAxisSpacing,
        crossAxisSpacing: AppConstants.crossAxisSpacing,
        padding: AppConstants.padding,
        staggeredTiles: const [
          StaggeredTile.extent(1, AppConstants.gridSize),
          StaggeredTile.extent(1, AppConstants.gridSize),
          StaggeredTile.extent(1, AppConstants.gridSize),
          StaggeredTile.extent(1, AppConstants.gridSize),
          StaggeredTile.extent(2, AppConstants.gridSize),
        ],
        children: _buildMenuItems(context),
      ),
    );
  }

  List<Widget> _buildMenuItems(BuildContext context) {
    final menuItems = [
      MenuItem(
        title: "Sapaklar",
        icon: Icons.book,
        color: Colors.greenAccent,
        screen: LessonsUiScreen(
          repository: repository,
          title: '',
        ),
      ),
      MenuItem(
        title: "Testler",
        icon: Icons.assignment,
        color: Colors.blueAccent,
        screen:
            TestsUiScreen(repository: repository, title: 'Testler', pref: pref),
      ),
      MenuItem(
        title: "Satistikalar",
        icon: Icons.bar_chart,
        color: Colors.redAccent,
        screen: StatisticScreen(
          repository: repository,
          pref: pref,
        ),
      ),
      MenuItem(
        title: "Netijeler",
        icon: Icons.poll,
        color: Colors.amber,
        screen: ResultScreen(
          repository: repository,
          title: 'Netijeler',
          pref: pref,
        ),
      ),
      MenuItem(
        title: "Kitaplar",
        icon: Icons.menu_book_rounded,
        color: Colors.deepPurple,
        screen: BooksScreen(),
      ),
    ];

    return menuItems
        .map((menuItem) => _buildMenuItem(context, menuItem))
        .toList();
  }

  Widget _buildMenuItem(BuildContext context, MenuItem menuItem) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => menuItem.screen));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: menuItem.color.withOpacity(0.2),
          boxShadow: [
            BoxShadow(
              color: menuItem.color.withOpacity(0.50),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(menuItem.icon, size: 60, color: menuItem.color),
            const SizedBox(height: 10),
            Text(
              menuItem.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Size get preferredSize => const Size.fromHeight(60);
}
