import 'package:e_admin_panel/add_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<_GridItem> items = [
    _GridItem(title: 'Just For You', icon: Icons.production_quantity_limits, screen: AddProductScreen()),
    _GridItem(title: 'Profile', icon: Icons.person, screen: Placeholder()),
    _GridItem(title: 'Settings', icon: Icons.settings, screen: Placeholder()),
    _GridItem(title: 'Notifications', icon: Icons.notifications, screen: Placeholder()),
    _GridItem(title: 'Help', icon: Icons.help, screen: Placeholder()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Admin Panel"),),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final item = items[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => item.screen),
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item.icon, size: 40, color: Colors.blue),
                    SizedBox(height: 10),
                    Text(item.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      backgroundColor: Colors.grey.shade100,
    );
  }
}

// Grid item model
class _GridItem {
  final String title;
  final IconData icon;
  final Widget screen;

  _GridItem({required this.title, required this.icon, required this.screen});
}
// Reusable screen layout
Widget _buildScreen(BuildContext context, String title) {
  return Scaffold(
    appBar: AppBar(title: Text(title)),
    body: Center(child: Text(title, style: TextStyle(fontSize: 24))),
  );
}
