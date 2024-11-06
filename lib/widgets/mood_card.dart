import 'package:flutter/material.dart';
import 'package:mental_health_tracker/screens/moodentry_form.dart'; // Import the mood entry form page

class ItemCard extends StatelessWidget {
  // Display the card with an icon and name.
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.secondary, // Background color from theme
      borderRadius: BorderRadius.circular(12), // Rounded corners
      child: InkWell(
        onTap: () {
          // Show a snackbar when the card is pressed
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Text("You pressed the ${item.name} button!"),
            ));

          // Navigate to the appropriate route
          if (item.name == "Add Mood") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MoodEntryFormPage(), // Navigate to the mood entry page
              ),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  color: Colors.white,
                  size: 30.0,
                ),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ItemHomepage {
  final String name;
  final IconData icon;

  ItemHomepage(this.name, this.icon);
}
