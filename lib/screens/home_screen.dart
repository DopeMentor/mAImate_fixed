import 'package:flutter/material.dart';
import '../routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('mAImate'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildTile(context, Icons.mic, 'Talk', onTap: () {
              Navigator.pushNamed(context, AppRoutes.chat);
            }),
            _buildTile(context, Icons.message, 'Chat', onTap: () {
              Navigator.pushNamed(context, AppRoutes.chat);
            }),
            _buildTile(context, Icons.calendar_today, 'Calendar', onTap: () {
              Navigator.pushNamed(context, AppRoutes.calendar);
            }),
            _buildTile(context, Icons.memory, 'Memory', onTap: () {
              Navigator.pushNamed(context, AppRoutes.memory);
            }), 
            _buildTile(context, Icons.mark_email_read, 'Analyze Msg', onTap: () {
              Navigator.pushNamed(context, AppRoutes.messageAnalysis);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(BuildContext context, IconData icon, String label, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.indigo.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: Colors.indigo),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

