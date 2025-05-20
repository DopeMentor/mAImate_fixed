import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  Stream<QuerySnapshot> getEventsStream() {
    return FirebaseFirestore.instance
        .collection('calendarEvents')
        .orderBy('date')
        .orderBy('time')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FC),
      appBar: AppBar(
        title: const Text('Tapahtumat'),
        backgroundColor: const Color(0xFF0367A6),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getEventsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  const Color(0xFF2AA876),
                ),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_note,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Ei tulevia tapahtumia',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          final events = snapshot.data!.docs;

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: events.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final data = events[index].data() as Map<String, dynamic>;
              final title = data['title'] ?? 'Tapahtuma';
              final location = data['location'] ?? '';
              final date = data['date'] ?? '';
              final time = data['time'] ?? '';

              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      // Tapahtuman klikkauslogiikka tähän
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 4,
                            height: 60,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2AA876),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (location.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        size: 14,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        location,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                time,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF0367A6),
                                ),
                              ),
                              Text(
                                date,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
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
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2AA876),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          // Uuden tapahtuman lisäyslogiikka tähän
        },
      ),
    );
  }
}
