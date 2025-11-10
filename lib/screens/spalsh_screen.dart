import 'package:flutter/material.dart';
import 'package:quizme/screens/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _scaleAnimation = Tween(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
    );

    _rotationAnimation = Tween(begin: 0.0, end: 2 * 3.1416).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 6), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.height < 600;
    final isPortrait = size.height > size.width;

    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) => Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.indigo.shade800,
                Colors.deepPurple.shade600,
                Colors.blueAccent.shade700,
              ],
            ),
          ),
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Padding(
                  padding: EdgeInsets.all(isSmall ? 20 : 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated Logo
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: RotationTransition(
                          turns: _rotationAnimation,
                          child: Container(
                            width: isSmall ? 100 : 120,
                            height: isSmall ? 100 : 120,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white,
                                  Colors.blue.shade100,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.school_rounded,
                              size: isSmall ? 48 : 58,
                              color: Colors.indigo.shade700,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: isSmall ? 25 : 40),

                      // Title
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Text(
                          'Flashcard Quiz',
                          style: TextStyle(
                            fontSize: isPortrait
                                ? (isSmall ? 28 : 34)
                                : 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.4,
                            shadows: [
                              Shadow(
                                blurRadius: 8,
                                color: Colors.black.withOpacity(0.4),
                                offset: const Offset(2, 2),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Subtitle
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Text(
                          'Transform your study routine',
                          style: TextStyle(
                            fontSize: isPortrait
                                ? (isSmall ? 15 : 17)
                                : 14,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w300,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      SizedBox(height: isSmall ? 45 : 70),

                      // Loading Indicator
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          children: [
                            Container(
                              width: isSmall ? 120 : 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: const LinearProgressIndicator(
                                minHeight: 6,
                                backgroundColor: Colors.white24,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              'Preparing your study session...',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: isSmall ? 13.5 : 15.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // Footer
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.lightbulb_outline_rounded,
                              color: Colors.amber.shade300,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Learn • Practice • Master',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: isSmall ? 12.5 : 14,
                                fontStyle: FontStyle.italic,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
