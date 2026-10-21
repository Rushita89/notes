
import 'package:flutter/material.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  String selectedCategory = 'Personal';
  Color selectedColor = const Color(0xFF4F46E5);

  bool reminderEnabled = false;
  DateTime? reminderDateTime;

  final List<Color> colorOptions = [
    const Color(0xFFFDE68A), // Yellow
    const Color(0xFFF9C6D0), // Pink
    const Color(0xFFE9B8F5), // Purple
    const Color(0xFF4F46E5), // Blue
    const Color(0xFF86E5A0), // Green
  ];

  final List<Color> backgroundOptions = [
    const Color(0xFFFFF8D9), // Pale yellow
    const Color(0xFFFFEAF0), // Pale pink
    const Color(0xFFF7E9FF), // Pale purple
    const Color(0xFFEEEEFF), // Pale blue
    const Color(0xFFE8FFEE), // Pale green
  ];

  Color get selectedBackground {
    final index = colorOptions.indexOf(selectedColor);
    return backgroundOptions[index < 0 ? 3 : index];
  }

  @override
  void dispose() {
    titleController.dispose();
    noteController.dispose();
    super.dispose();
  }

  Future<void> chooseReminder() async {
    final now = DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: reminderDateTime ?? now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 5),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: selectedColor,
              primary: selectedColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null || !mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: reminderDateTime != null
          ? TimeOfDay.fromDateTime(reminderDateTime!)
          : TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: selectedColor,
              primary: selectedColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime == null || !mounted) return;

    setState(() {
      reminderDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      reminderEnabled = true;
    });
  }

  String formatReminder(DateTime dateTime) {
    final date =
        '${dateTime.day.toString().padLeft(2, '0')}/'
        '${dateTime.month.toString().padLeft(2, '0')}/'
        '${dateTime.year}';

    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';

    return '$date • $hour:$minute $period';
  }

  void saveNote() {
    if (titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a note title'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Store colors as integers to avoid Color/int type errors.
    final Map<String, dynamic> note = {
      'title': titleController.text.trim(),
      'description': noteController.text.trim(),
      'category': selectedCategory,
      'color': selectedColor.toARGB32(),
      'background': selectedBackground.toARGB32(),
      'reminder': reminderEnabled ? reminderDateTime : null,
      'date': 'Today',
      'icon': Icons.note_alt_rounded,
    };

    Navigator.pop(context, note);
  }

  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Color(0xFF777D90),
        fontSize: 13,
      ),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.70),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 15,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: selectedColor.withValues(alpha: 0.20),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: selectedColor,
          width: 1.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color screenColor = selectedBackground;

    return Scaffold(
      backgroundColor: screenColor,
      appBar: AppBar(
        backgroundColor: screenColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black87,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Note',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Save note',
            onPressed: saveNote,
            icon: const Icon(
              Icons.check,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          color: screenColor,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(22, 16, 22, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Title',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: titleController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: inputDecoration('Enter note title...'),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Category',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: inputDecoration('Select category'),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  borderRadius: BorderRadius.circular(12),
                  items: const [
                    DropdownMenuItem(
                      value: 'Personal',
                      child: Text('Personal'),
                    ),
                    DropdownMenuItem(
                      value: 'Work',
                      child: Text('Work'),
                    ),
                    DropdownMenuItem(
                      value: 'Ideas',
                      child: Text('Ideas'),
                    ),
                    DropdownMenuItem(
                      value: 'Shopping',
                      child: Text('Shopping'),
                    ),
                    DropdownMenuItem(
                      value: 'Travel',
                      child: Text('Travel'),
                    ),
                    DropdownMenuItem(
                      value: 'Others',
                      child: Text('Others'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedCategory = value;
                      });
                    }
                  },
                ),

                const SizedBox(height: 20),

                const Text(
                  'Note',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: noteController,
                  minLines: 4,
                  maxLines: 5,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: inputDecoration('Write your note here...'),
                ),

                const SizedBox(height: 18),

                Row(
                  children: [
                    const Icon(
                      Icons.calendar_month_outlined,
                      size: 19,
                      color: Colors.black87,
                    ),
                    const SizedBox(width: 9),
                    const Expanded(
                      child: Text(
                        'Set Reminder',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Switch(
                      value: reminderEnabled,
                      activeThumbColor: Colors.white,
                      activeTrackColor: selectedColor,
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: const Color(0xFFD9DDE5),
                      onChanged: (value) async {
                        if (!value) {
                          setState(() {
                            reminderEnabled = false;
                            reminderDateTime = null;
                          });
                        } else {
                          setState(() {
                            reminderEnabled = true;
                          });

                          await chooseReminder();

                          if (mounted && reminderDateTime == null) {
                            setState(() {
                              reminderEnabled = false;
                            });
                          }
                        }
                      },
                    ),
                  ],
                ),

                if (reminderEnabled) ...[
                  const SizedBox(height: 6),
                  InkWell(
                    onTap: chooseReminder,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.60),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selectedColor.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            color: selectedColor,
                            size: 21,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              reminderDateTime == null
                                  ? 'Choose date and time'
                                  : formatReminder(reminderDateTime!),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          Icon(
                            Icons.edit_calendar_outlined,
                            color: selectedColor,
                            size: 19,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                const Text(
                  'Color',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 14),

                Row(
                  children: List.generate(colorOptions.length, (index) {
                    final Color color = colorOptions[index];
                    final bool isSelected = selectedColor == color;

                    return Expanded(
                      child: Center(
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () {
                            setState(() {
                              selectedColor = color;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: isSelected
                                  ? Border.all(
                                color: Colors.black54,
                                width: 2,
                              )
                                  : null,
                            ),
                            child: isSelected
                                ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 20,
                            )
                                : null,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
