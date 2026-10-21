
import 'package:flutter/material.dart';

import 'notescreen.dart';
import 'navigationdrawer.dart';
import 'categories.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();

  String searchQuery = '';
  String selectedCategory = 'All';
  int selectedBottomIndex = 0;

  final Color primaryColor = const Color(0xFF4F46E5);

  final List<String> categories = [
    'All',
    'Personal',
    'Work',
    'Ideas',
    'Shopping',
    'Travel',
    'Others',
  ];

  final List<Map<String, dynamic>> notes = [
    {
      'title': 'Meeting Notes',
      'description': 'Discuss project timeline and upcoming tasks.',
      'category': 'Work',
      'color': 0xFFFFC629,
      'background': 0xFFFFF9E5,
      'date': '16 Oct',
      'icon': Icons.article_rounded,
      'reminder': null,
    },
    {
      'title': 'Shopping List',
      'description': 'Milk, Bread, Fruits and Vegetables.',
      'category': 'Shopping',
      'color': 0xFFF06292,
      'background': 0xFFFFF0F5,
      'date': '15 Oct',
      'icon': Icons.shopping_bag_rounded,
      'reminder': null,
    },
    {
      'title': 'Travel Plan',
      'description': 'Plan the Goa trip and book the hotel.',
      'category': 'Travel',
      'color': 0xFF8B5CF6,
      'background': 0xFFF2EDFF,
      'date': '14 Oct',
      'icon': Icons.flight_rounded,
      'reminder': null,
    },
    {
      'title': 'Workout Routine',
      'description': 'Gym schedule and daily exercise plan.',
      'category': 'Personal',
      'color': 0xFF2196F3,
      'background': 0xFFEAF5FF,
      'date': '12 Oct',
      'icon': Icons.fitness_center_rounded,
      'reminder': null,
    },
    {
      'title': 'Book Ideas',
      'description': 'New story concepts and writing ideas.',
      'category': 'Ideas',
      'color': 0xFFF06292,
      'background': 0xFFFFF0F5,
      'date': '10 Oct',
      'icon': Icons.menu_book_rounded,
      'reminder': null,
    },
  ];

  final List<Map<String, dynamic>> deletedNotes = [];

  // Accept both Color and int values to prevent type errors.
  Color getNoteColor(
      dynamic value, {
        Color fallback = Colors.indigo,
      }) {
    if (value is Color) return value;
    if (value is int) return Color(value);
    return fallback;
  }

  List<Map<String, dynamic>> get filteredNotes {
    return notes.where((note) {
      final title = (note['title'] ?? '').toString().toLowerCase();
      final description =
      (note['description'] ?? '').toString().toLowerCase();
      final category = (note['category'] ?? '').toString();

      final matchesSearch = title.contains(searchQuery.toLowerCase()) ||
          description.contains(searchQuery.toLowerCase());

      final matchesCategory =
          selectedCategory == 'All' || category == selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Open Add Note screen and add the saved note to the list.
  Future<void> addNote() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => const NoteScreen(),
      ),
    );

    if (!mounted || result == null) return;

    setState(() {
      result['color'] = getNoteColor(
        result['color'],
        fallback: primaryColor,
      ).toARGB32();

      result['background'] = getNoteColor(
        result['background'],
        fallback: Colors.white,
      ).toARGB32();

      notes.insert(0, result);
      selectedCategory = 'All';
      searchQuery = '';
      searchController.clear();
      selectedBottomIndex = 0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Note added successfully!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void deleteNote(Map<String, dynamic> note) {
    final index = notes.indexOf(note);
    if (index == -1) return;

    setState(() {
      notes.removeAt(index);
      deletedNotes.add(note);
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text('Note deleted'),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'UNDO',
            onPressed: () {
              setState(() {
                deletedNotes.remove(note);
                notes.insert(index.clamp(0, notes.length), note);
              });
            },
          ),
        ),
      );
  }

  void showNoteDetails(Map<String, dynamic> note) {
    final Color noteBackground = getNoteColor(
      note['background'],
      fallback: const Color(0xFFEEEEFF),
    );

    final Color noteColor = getNoteColor(
      note['color'],
      fallback: primaryColor,
    );

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
          decoration: BoxDecoration(
            color: noteBackground,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Icon(
                        Icons.note_alt_rounded,
                        color: noteColor,
                        size: 28,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          note['title']?.toString() ?? 'Untitled note',
                          style: const TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _detailChip(
                        Icons.folder_outlined,
                        note['category']?.toString() ?? 'Others',
                        noteColor,
                      ),
                      _detailChip(
                        Icons.calendar_today_outlined,
                        note['date']?.toString() ?? 'Today',
                        noteColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Text(
                    (note['description'] ?? '').toString().isEmpty
                        ? 'No description added.'
                        : note['description'].toString(),
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.7,
                      color: Color(0xFF343447),
                    ),
                  ),
                  if (note['reminder'] is DateTime) ...[
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(Icons.alarm, color: noteColor),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Reminder: ${_formatDateTime(note['reminder'] as DateTime)}',
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 26),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        deleteNote(note);
                      },
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Delete Note'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade50,
                        foregroundColor: Colors.red.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _detailChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';

    return '${dateTime.day}/${dateTime.month}/${dateTime.year} '
        '$hour:$minute $period';
  }

  Future<void> openCategories() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => const CategoriesScreen(),
      ),
    );

    if (!mounted || result == null) return;

    setState(() {
      selectedCategory = categories.contains(result) ? result : 'All';
      selectedBottomIndex = 0;
    });
  }

  void openSearch() {
    searchController.text = searchQuery;

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Search Notes'),
          content: TextField(
            controller: searchController,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Enter title or note text',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  searchQuery = '';
                  searchController.clear();
                });
                Navigator.pop(dialogContext);
              },
              child: const Text('Clear'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  searchQuery = searchController.text.trim();
                });
                Navigator.pop(dialogContext);
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  Widget buildCategoryChips() {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category;

          return ChoiceChip(
            label: Text(category),
            selected: isSelected,
            onSelected: (_) {
              setState(() {
                selectedCategory = category;
              });
            },
            selectedColor: primaryColor,
            backgroundColor: Colors.white,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF55556A),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            side: BorderSide(
              color: isSelected ? primaryColor : const Color(0xFFE7E7F0),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            showCheckmark: false,
          );
        },
      ),
    );
  }

  Widget buildNoteCard(Map<String, dynamic> note) {
    final Color background = getNoteColor(
      note['background'],
      fallback: const Color(0xFFEEEEFF),
    );

    final Color noteColor = getNoteColor(
      note['color'],
      fallback: primaryColor,
    );

    final title = note['title']?.toString() ?? 'Untitled note';
    final description = note['description']?.toString() ?? '';
    final category = note['category']?.toString() ?? 'Others';
    final date = note['date']?.toString() ?? 'Today';

    return Dismissible(
      key: ObjectKey(note),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 22),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
          size: 28,
        ),
      ),
      onDismissed: (_) => deleteNote(note),
      child: Card(
        elevation: 0,
        color: background,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: noteColor.withValues(alpha: 0.15),
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => showNoteDetails(note),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: noteColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        note['icon'] is IconData
                            ? note['icon'] as IconData
                            : Icons.note_alt_rounded,
                        color: noteColor,
                        size: 21,
                      ),
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF25253A),
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Delete note',
                      visualDensity: VisualDensity.compact,
                      onPressed: () => deleteNote(note),
                      icon: Icon(
                        Icons.more_vert,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  description.isEmpty ? 'No description' : description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: Color(0xFF5F6072),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: noteColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          fontSize: 11,
                          color: noteColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (note['reminder'] is DateTime)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Icon(
                          Icons.alarm,
                          size: 16,
                          color: noteColor,
                        ),
                      ),
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> handleBottomNavigation(int index) async {
    if (index == 0) {
      setState(() {
        selectedBottomIndex = 0;
        selectedCategory = 'All';
      });
    } else if (index == 1) {
      setState(() {
        selectedBottomIndex = 1;
      });

      await openCategories();

      if (mounted) {
        setState(() {
          selectedBottomIndex = 0;
        });
      }
    } else if (index == 2) {
      setState(() {
        selectedBottomIndex = 2;
      });

      await addNote();

      if (mounted) {
        setState(() {
          selectedBottomIndex = 0;
        });
      }
    } else if (index == 3) {
      setState(() {
        selectedBottomIndex = 3;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile screen coming soon!'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      if (mounted) {
        setState(() {
          selectedBottomIndex = 0;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final visibleNotes = filteredNotes;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),

      drawer: MyNotesDrawer(
        userName: 'Rushita',
        userEmail: 'rushita@gmail.com',
        onLogout: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Logout selected')),
          );
        },
      ),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F8FC),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) {
            return IconButton(
              tooltip: 'Open menu',
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(
                Icons.menu_rounded,
                color: Color(0xFF29293E),
              ),
            );
          },
        ),
        title: const Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'My',
                style: TextStyle(color: Color(0xFF29293E)),
              ),
              TextSpan(
                text: 'Notes',
                style: TextStyle(color: Color(0xFF4F46E5)),
              ),
            ],
          ),
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Search notes',
            onPressed: openSearch,
            icon: const Icon(
              Icons.search_rounded,
              color: Color(0xFF29293E),
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),

      // Purple + button at the bottom-right of the Home screen.
      floatingActionButton: FloatingActionButton(
        onPressed: addNote,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        tooltip: 'Add Note',
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: BottomNavigationBar(
            currentIndex: selectedBottomIndex,
            onTap: handleBottomNavigation,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            elevation: 0,
            selectedItemColor: primaryColor,
            unselectedItemColor: const Color(0xFF74748A),
            selectedFontSize: 11,
            unselectedFontSize: 11,
            showUnselectedLabels: true,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.grid_view_outlined),
                activeIcon: Icon(Icons.grid_view_rounded),
                label: 'Categories',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_circle_outline),
                activeIcon: Icon(Icons.add_circle),
                label: 'Add',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline_rounded),
                activeIcon: Icon(Icons.person_rounded),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your thoughts, organized.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF77778B),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'My Notes',
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF29293E),
                          ),
                        ),
                      ),
                      Text(
                        '${visibleNotes.length} Notes',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF77778B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  buildCategoryChips(),
                  const SizedBox(height: 14),
                ],
              ),
            ),
            Expanded(
              child: visibleNotes.isEmpty
                  ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.sticky_note_2_outlined,
                        size: 65,
                        color: primaryColor.withValues(alpha: 0.55),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'No notes found',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF29293E),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Add a note or try another search or category.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF77778B),
                        ),
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        onPressed: addNote,
                        icon: const Icon(Icons.add),
                        label: const Text('Create Note'),
                      ),
                    ],
                  ),
                ),
              )
                  : ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 90),
                itemCount: visibleNotes.length,
                separatorBuilder: (context, index) =>
                const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  return buildNoteCard(visibleNotes[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
