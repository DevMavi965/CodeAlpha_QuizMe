import 'package:flutter/foundation.dart';
import '../database/dbhelper.dart';
import '../models/flashcard.dart';


class FlashcardProvider with ChangeNotifier {
  List<Flashcard> _flashcards = [];
  int _currentCardIndex = 0;

  List<Flashcard> get flashcards => _flashcards;
  int get currentCardIndex => _currentCardIndex;
  int get totalCards => _flashcards.length;
  Flashcard? get currentCard =>
      _flashcards.isNotEmpty ? _flashcards[_currentCardIndex] : null;

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  FlashcardProvider() {
    loadFlashcards();
    notifyListeners();
  }

  Future<void> loadFlashcards() async {
    _flashcards = await _databaseHelper.getFlashcards();
    notifyListeners();
  }

  Future<void> addFlashcard(Flashcard flashcard) async {
    await _databaseHelper.insertFlashcard(flashcard);
    await loadFlashcards();
  }

  Future<void> updateFlashcard(Flashcard flashcard) async {
    await _databaseHelper.updateFlashcard(flashcard);
    await loadFlashcards();
  }

  Future<void> deleteFlashcard(int id) async {
    await _databaseHelper.deleteFlashcard(id);
    await loadFlashcards();
  }

  void nextCard() {
    if (_currentCardIndex < _flashcards.length - 1) {
      _currentCardIndex++;
      notifyListeners();
    }
  }

  void previousCard() {
    if (_currentCardIndex > 0) {
      _currentCardIndex--;
      notifyListeners();
    }
  }

  void resetQuiz() {
    _currentCardIndex = 0;
    notifyListeners();
  }
}