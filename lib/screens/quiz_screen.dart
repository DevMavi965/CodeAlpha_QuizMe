import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/flashcard_provider.dart';
import '../widgets/flashcard_widget.dart';
import '../widgets/custom_button.dart';

class QuizScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flashcard Quiz'),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Consumer<FlashcardProvider>(
        builder: (context, provider, child) {
          if (provider.flashcards.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: Colors.grey),
                  SizedBox(height: 20),
                  Text(
                    'No flashcards available',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Go Back'),
                  ),
                ],
              ),
            );
          }

          final currentCard = provider.currentCard!;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Card ${provider.currentCardIndex + 1} of ${provider.totalCards}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.home),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FlashcardWidget(
                  question: currentCard.question,
                  options: currentCard.options,
                  correctAnswerIndex: currentCard.correctAnswerIndex,
                  explanation: currentCard.explanation,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                      onPressed: provider.previousCard,
                      text: 'Previous',
                      icon: Icons.arrow_back,
                      isEnabled: provider.currentCardIndex > 0,
                    ),
                    CustomButton(
                      onPressed: provider.nextCard,
                      text: 'Next',
                      icon: Icons.arrow_forward,
                      isEnabled: provider.currentCardIndex < provider.totalCards - 1,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}