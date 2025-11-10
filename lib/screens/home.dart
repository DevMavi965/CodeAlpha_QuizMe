import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/flashcard_provider.dart';
import 'quiz_screen.dart';
import 'manage_cards_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flashcard Quiz'),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Consumer<FlashcardProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child:ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      elevation: 8,
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.school,
                              size: 80,
                              color: Colors.blue.shade800,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Flashcard Quiz App',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade800,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Study smarter with interactive flashcards',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildActionCard(
                            context,
                            'Start Quiz',
                            Icons.quiz,
                            Colors.green,
                                () {
                              if (provider.flashcards.isNotEmpty) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => QuizScreen()),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Please add some flashcards first!'),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: _buildActionCard(
                            context,
                            'Manage Cards',
                            Icons.edit,
                            Colors.orange,
                                () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ManageCardsScreen()),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    _buildStatsCard(context, provider),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionCard(
      BuildContext context,
      String title,
      IconData icon,
      Color color,
      VoidCallback onTap,
      ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Icon(icon, size: 40, color: color),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard(BuildContext context, FlashcardProvider provider) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(Icons.library_books, 'Total Cards', '${provider.totalCards}'),
            _buildStatItem(Icons.quiz, 'Ready to Study', provider.totalCards > 0 ? 'Yes' : 'No'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue.shade800),
        SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}