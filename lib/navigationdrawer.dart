import 'package:flutter/material.dart';
import 'categories.dart';

class MyNotesDrawer extends StatelessWidget {
  final String userName;
  final String userEmail;
  final VoidCallback? onLogout;

  const MyNotesDrawer({
    super.key,
    this.userName = 'Rushita',
    this.userEmail = 'rushita@example.com',
    this.onLogout,
  });

  static const Color primaryColor = Color(0xFF4F46E5);
  static const Color textColor = Color(0xFF292943);
  static const Color subtitleColor = Color(0xFF85859A);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 300,
      backgroundColor: Colors.white,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User profile section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(22, 25, 18, 25),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF4F46E5),
                      Color(0xFF6657F5),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(22),
                    bottomRight: Radius.circular(22),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.white,
                          child: Text(
                            userName.trim().isNotEmpty
                                ? userName.trim()[0].toUpperCase()
                                : 'U',
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          tooltip: 'Close menu',
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Text(
                      userName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      userEmail,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              const Padding(
                padding: EdgeInsets.fromLTRB(22, 0, 16, 10),
                child: Text(
                  'MENU',
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold,
                    color: subtitleColor,
                  ),
                ),
              ),

              // Home
              _menuItem(
                context,
                icon: Icons.home_rounded,
                title: 'Home',
                selected: true,
                onTap: () {
                  Navigator.pop(context);
                },
              ),

              // Categories
              _menuItem(
                context,
                icon: Icons.grid_view_rounded,
                title: 'Categories',
                onTap: () {
                  Navigator.pop(context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CategoriesScreen(),
                    ),
                  );
                },
              ),

              // Archives
              _menuItem(
                context,
                icon: Icons.archive_outlined,
                title: 'Archives',
                onTap: () {
                  _showPlaceholder(context, 'Archives');
                },
              ),

              // Trash
              _menuItem(
                context,
                icon: Icons.delete_outline_rounded,
                title: 'Trash',
                onTap: () {
                  _showPlaceholder(context, 'Trash');
                },
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 22),
                child: Divider(
                  height: 30,
                  color: Color(0xFFEEEEF5),
                ),
              ),

              const Padding(
                padding: EdgeInsets.fromLTRB(22, 0, 16, 10),
                child: Text(
                  'PREFERENCES',
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold,
                    color: subtitleColor,
                  ),
                ),
              ),

              // Settings
              _menuItem(
                context,
                icon: Icons.settings_outlined,
                title: 'Settings',
                onTap: () {
                  _showPlaceholder(context, 'Settings');
                },
              ),

              // Help & Support
              _menuItem(
                context,
                icon: Icons.help_outline_rounded,
                title: 'Help & Support',
                onTap: () {
                  _showPlaceholder(context, 'Help & Support');
                },
              ),

              const SizedBox(height: 25),

              // Logout
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Material(
                  color: const Color(0xFFFFEEEE),
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      Navigator.pop(context);

                      if (onLogout != null) {
                        onLogout!();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Please connect your login screen '
                                  'to implement logout.',
                            ),
                          ),
                        );
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 15,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.logout_rounded,
                            color: Color(0xFFDC2626),
                            size: 22,
                          ),
                          SizedBox(width: 14),
                          Text(
                            'Logout',
                            style: TextStyle(
                              color: Color(0xFFDC2626),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          Spacer(),
                          Icon(
                            Icons.chevron_right,
                            color: Color(0xFFDC2626),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              const Center(
                child: Text(
                  'MyNotes • Stay organized',
                  style: TextStyle(
                    fontSize: 11,
                    color: subtitleColor,
                  ),
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required VoidCallback onTap,
        bool selected = false,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 3,
      ),
      child: Material(
        color: selected
            ? const Color(0xFFEEEEFF)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(13),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(13),
          child: SizedBox(
            height: 49,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 22,
                    color: selected ? primaryColor : subtitleColor,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: selected ? primaryColor : textColor,
                      ),
                    ),
                  ),
                  if (selected)
                    Container(
                      width: 4,
                      height: 23,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showPlaceholder(BuildContext context, String title) {
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title screen is not implemented yet.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
