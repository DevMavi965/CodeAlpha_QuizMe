import 'package:flutter/material.dart';
import '../animations/flip_animation.dart';

class FlashcardWidget extends StatefulWidget {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;
  final VoidCallback? onCardChange; // Callback when card changes

  const FlashcardWidget({
    Key? key,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
    this.onCardChange,
  }) : super(key: key);

  @override
  _FlashcardWidgetState createState() => _FlashcardWidgetState();
}

class _FlashcardWidgetState extends State<FlashcardWidget> {
  bool _showAnswer = false;
  int? _selectedOptionIndex;

  @override
  void didUpdateWidget(FlashcardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Reset selection when the card data changes (next/previous)
    if (oldWidget.question != widget.question ||
        oldWidget.correctAnswerIndex != widget.correctAnswerIndex) {
      _resetSelection();
    }
  }

  void _resetSelection() {
    setState(() {
      _selectedOptionIndex = null;
      _showAnswer = false;
    });
  }

  void _toggleCard() {
    setState(() {
      _showAnswer = !_showAnswer;
    });
  }

  void _onOptionSelected(int index) {
    setState(() {
      _selectedOptionIndex = index;
    });
  }

  Color _getOptionBorderColor(int index) {
    if (_selectedOptionIndex == null) {
      return Colors.grey.shade300; // Default border color
    }

    if (index == widget.correctAnswerIndex) {
      return Colors.green; // Correct answer always green
    }

    if (index == _selectedOptionIndex && index != widget.correctAnswerIndex) {
      return Colors.red; // Wrong selected answer
    }

    return Colors.grey.shade300; // Other options remain default
  }

  Color _getOptionBackgroundColor(int index) {
    if (_selectedOptionIndex == null) {
      return Colors.transparent; // Default background
    }

    if (index == widget.correctAnswerIndex) {
      return Colors.green.shade50; // Correct answer light green background
    }

    if (index == _selectedOptionIndex && index != widget.correctAnswerIndex) {
      return Colors.red.shade50; // Wrong selected answer light red background
    }

    return Colors.transparent; // Other options remain transparent
  }

  Widget _buildFront() {
    return Card(
      elevation: 8,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Icon(
              Icons.help_outline,
              size: 50,
              color: Colors.blue.shade800,
            ),
            SizedBox(height: 20),
            Text(
              widget.question,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            Expanded(
              child: ListView(
                children: widget.options.asMap().entries.map((entry) {
                  int index = entry.key;
                  String option = entry.value;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: GestureDetector(
                      onTap: () => _onOptionSelected(index),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _getOptionBackgroundColor(index),
                          border: Border.all(
                            color: _getOptionBorderColor(index),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            // Option letter with icon
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: _getOptionBorderColor(index) == Colors.grey.shade300
                                    ? Colors.grey.shade200
                                    : _getOptionBorderColor(index).withOpacity(0.2),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _getOptionBorderColor(index),
                                  width: 1.5,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  String.fromCharCode(65 + index),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: _getOptionBorderColor(index) == Colors.grey.shade300
                                        ? Colors.grey.shade700
                                        : _getOptionBorderColor(index),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                option,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: _getOptionBorderColor(index) == Colors.grey.shade300
                                      ? Colors.black
                                      : _getOptionBorderColor(index),
                                  fontWeight: _selectedOptionIndex == index
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                            // Show check/cross icon based on selection
                            if (_selectedOptionIndex != null && index == _selectedOptionIndex)
                              Icon(
                                index == widget.correctAnswerIndex
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                color: index == widget.correctAnswerIndex
                                    ? Colors.green
                                    : Colors.red,
                                size: 20,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _toggleCard,
                    icon: Icon(Icons.lightbulb_outline, color: Colors.white),
                    label: Text('Show Answer', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade800,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                if (_selectedOptionIndex != null)
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _selectedOptionIndex == widget.correctAnswerIndex
                          ? Colors.green.shade100
                          : Colors.red.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _selectedOptionIndex == widget.correctAnswerIndex
                          ? 'Correct!'
                          : 'Incorrect!',
                      style: TextStyle(
                        color: _selectedOptionIndex == widget.correctAnswerIndex
                            ? Colors.green.shade800
                            : Colors.red.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBack() {
    return Card(
      elevation: 8,
      margin: EdgeInsets.all(20),
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              size: 50,
              color: Colors.green,
            ),
            SizedBox(height: 20),
            Text(
              'Correct Answer:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade800,
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green),
              ),
              child: Text(
                '${String.fromCharCode(65 + widget.correctAnswerIndex)}. ${widget.options[widget.correctAnswerIndex]}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade900,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            if (_selectedOptionIndex != null && _selectedOptionIndex != widget.correctAnswerIndex) ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red),
                ),
                child: Column(
                  children: [
                    Text(
                      'Your Answer:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade800,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '${String.fromCharCode(65 + _selectedOptionIndex!)}. ${widget.options[_selectedOptionIndex!]}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red.shade700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
            if (widget.explanation.isNotEmpty) ...[
              Text(
                'Explanation:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                widget.explanation,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
            ],
            ElevatedButton.icon(
              onPressed: _toggleCard,
              icon: Icon(Icons.question_answer, color: Colors.white),
              label: Text('Show Question', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: FlipAnimation(
        front: _buildFront(),
        back: _buildBack(),
        showFront: !_showAnswer,
      ),
    );
  }
}