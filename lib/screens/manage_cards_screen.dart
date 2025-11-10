import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/flashcard.dart';
import '../providers/flashcard_provider.dart';

class ManageCardsScreen extends StatefulWidget {
  @override
  _ManageCardsScreenState createState() => _ManageCardsScreenState();
}

class _ManageCardsScreenState extends State<ManageCardsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Flashcards'),
        backgroundColor: Colors.blue.shade800,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddEditFlashcardDialog(context),
          ),
        ],
      ),
      body: Consumer<FlashcardProvider>(
        builder: (context, provider, child) {
          if (provider.flashcards.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.note_add, size: 60, color: Colors.grey),
                  SizedBox(height: 20),
                  Text(
                    'No flashcards yet',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Tap the + button to add your first flashcard',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: provider.flashcards.length,
            itemBuilder: (context, index) {
              final flashcard = provider.flashcards[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    child: Text('${index + 1}'),
                  ),
                  title: Text(
                    flashcard.question,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    'Options: ${flashcard.options.length} | Correct: ${String.fromCharCode(65 + flashcard.correctAnswerIndex)}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showAddEditFlashcardDialog(
                            context, flashcard),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _showDeleteDialog(context, flashcard),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditFlashcardDialog(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.blue.shade800,
      ),
    );
  }

  void _showAddEditFlashcardDialog(BuildContext context, [Flashcard? flashcard]) {
    final _formKey = GlobalKey<FormState>();
    final _questionController = TextEditingController(text: flashcard?.question ?? '');
    final _option1Controller = TextEditingController(text: flashcard?.options[0] ?? '');
    final _option2Controller = TextEditingController(text: flashcard?.options[1] ?? '');
    final _option3Controller = TextEditingController(text: flashcard?.options[2] ?? '');
    final _option4Controller = TextEditingController(text: flashcard?.options[3] ?? '');
    final _explanationController = TextEditingController(text: flashcard?.explanation ?? '');
    int _correctAnswerIndex = flashcard?.correctAnswerIndex ?? 0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(flashcard == null ? 'Add Flashcard' : 'Edit Flashcard'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _questionController,
                    decoration: InputDecoration(labelText: 'Question'),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a question';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  Text('Options:'),
                  TextFormField(
                    controller: _option1Controller,
                    decoration: InputDecoration(labelText: 'Option A'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter option A';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _option2Controller,
                    decoration: InputDecoration(labelText: 'Option B'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter option B';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _option3Controller,
                    decoration: InputDecoration(labelText: 'Option C'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter option C';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _option4Controller,
                    decoration: InputDecoration(labelText: 'Option D'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter option D';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  Text('Correct Answer:'),
                  DropdownButtonFormField<int>(
                    value: _correctAnswerIndex,
                    items: [
                      DropdownMenuItem(value: 0, child: Text('A')),
                      DropdownMenuItem(value: 1, child: Text('B')),
                      DropdownMenuItem(value: 2, child: Text('C')),
                      DropdownMenuItem(value: 3, child: Text('D')),
                    ],
                    onChanged: (value) {
                      _correctAnswerIndex = value!;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _explanationController,
                    decoration: InputDecoration(labelText: 'Explanation (optional)'),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final newFlashcard = Flashcard(
                    id: flashcard?.id,
                    question: _questionController.text,
                    options: [
                      _option1Controller.text,
                      _option2Controller.text,
                      _option3Controller.text,
                      _option4Controller.text,
                    ],
                    correctAnswerIndex: _correctAnswerIndex,
                    explanation: _explanationController.text,
                  );

                  final provider = Provider.of<FlashcardProvider>(context, listen: false);

                  if (flashcard == null) {
                    provider.addFlashcard(newFlashcard);
                    Navigator.pop(context);
                  } else {
                    provider.updateFlashcard(newFlashcard);

                  }

                  Navigator.pop(context);
                }
              },
              child: Text(flashcard == null ? 'Add' : 'Update'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, Flashcard flashcard) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Flashcard'),
          content: Text('Are you sure you want to delete this flashcard?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<FlashcardProvider>(context, listen: false)
                    .deleteFlashcard(flashcard.id!);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}