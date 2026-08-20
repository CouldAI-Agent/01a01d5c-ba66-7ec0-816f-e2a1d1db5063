import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AstraState()),
      ],
      child: const AstraApp(),
    ),
  );
}

class AstraApp extends StatelessWidget {
  const AstraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ASTRA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF070B19),
        primaryColor: const Color(0xFF00E5FF),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00E5FF),
          secondary: Color(0xFF2979FF),
          surface: Color(0xFF10162A),
        ),
        fontFamily: 'Roboto', // Ideally a futuristic font would go here
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const AstraHomeScreen(),
      },
    );
  }
}

enum AstraStatus { idle, listening, processing, speaking }

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({required this.text, required this.isUser})
      : timestamp = DateTime.now();
}

class AstraState extends ChangeNotifier {
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();

  bool _speechEnabled = false;
  AstraStatus _currentStatus = AstraStatus.idle;
  String _recognizedWords = '';
  final List<ChatMessage> _history = [];

  AstraStatus get currentStatus => _currentStatus;
  String get recognizedWords => _recognizedWords;
  List<ChatMessage> get history => _history;

  AstraState() {
    _initSpeech();
    _initTts();
  }

  Future<void> _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    notifyListeners();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage("es-ES");
    await _flutterTts.setPitch(1.1);
    await _flutterTts.setSpeechRate(0.5);
    
    _flutterTts.setCompletionHandler(() {
      _setStatus(AstraStatus.idle);
    });
  }

  void _setStatus(AstraStatus status) {
    _currentStatus = status;
    notifyListeners();
  }

  Future<void> startListening() async {
    await Permission.microphone.request();
    
    if (_speechEnabled) {
      _setStatus(AstraStatus.listening);
      _recognizedWords = '';
      await _speechToText.listen(onResult: _onSpeechResult);
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    _recognizedWords = result.recognizedWords;
    notifyListeners();

    if (result.finalResult) {
      stopListening();
      _processCommand(_recognizedWords);
    }
  }

  Future<void> stopListening() async {
    await _speechToText.stop();
    if (_currentStatus == AstraStatus.listening) {
      _setStatus(AstraStatus.idle);
    }
  }

  Future<void> _processCommand(String text) async {
    if (text.trim().isEmpty) return;

    _history.insert(0, ChatMessage(text: text, isUser: true));
    _setStatus(AstraStatus.processing);
    _recognizedWords = '';
    
    // Simulate AI processing time
    await Future.delayed(const Duration(seconds: 2));

    String response = _simulateAIResponse(text);
    _history.insert(0, ChatMessage(text: response, isUser: false));
    
    _speak(response);
  }

  String _simulateAIResponse(String input) {
    final lowerInput = input.toLowerCase();
    
    if (lowerInput.contains('hola')) {
      return "Hola. Soy ASTRA, tu asistente personal. ¿En qué puedo ayudarte?";
    } else if (lowerInput.contains('hora')) {
      final now = TimeOfDay.now();
      return "Son las ${now.hour} y ${now.minute}.";
    } else if (lowerInput.contains('quién eres') || lowerInput.contains('quien eres')) {
      return "Soy ASTRA, un asistente de inteligencia artificial avanzado diseñado para ayudarte en tus tareas diarias.";
    } else if (lowerInput.contains('abrir') || lowerInput.contains('alarma') || lowerInput.contains('configurar')) {
      return "Esa función estará disponible en la próxima actualización de mis sistemas. Por ahora, mis módulos de integración están en preparación.";
    } else {
      return "He procesado tu solicitud: '$input'. Aún estoy aprendiendo, pero pronto podré darte una respuesta detallada a eso.";
    }
  }

  Future<void> _speak(String text) async {
    _setStatus(AstraStatus.speaking);
    await _flutterTts.speak(text);
  }
  
  Future<void> stopSpeaking() async {
     await _flutterTts.stop();
     _setStatus(AstraStatus.idle);
  }

  void clearHistory() {
    _history.clear();
    notifyListeners();
  }
}

class AstraHomeScreen extends StatelessWidget {
  const AstraHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'A S T R A',
          style: TextStyle(
            letterSpacing: 8,
            fontWeight: FontWeight.bold,
            color: Color(0xFF00E5FF),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Color(0xFF00E5FF)),
            onPressed: () {
              // Future settings panel
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Configuración del sistema ASTRA en desarrollo...')),
              );
            },
          )
        ],
      ),
      body: const SafeArea(
        child: Column(
          children: [
            Expanded(
              child: AstraChatHistory(),
            ),
            AstraStatusVisualizer(),
            SizedBox(height: 20),
            AstraMicButton(),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class AstraChatHistory extends StatelessWidget {
  const AstraChatHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AstraState>();
    final history = state.history;

    return ListView.builder(
      reverse: true,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final message = history[index];
        return Align(
          alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: message.isUser ? Theme.of(context).colorScheme.surface : Colors.transparent,
              border: Border.all(
                color: message.isUser ? Colors.transparent : Theme.of(context).colorScheme.primary.withOpacity(0.5),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            maxWidth: MediaQuery.of(context).size.width * 0.8,
            child: Text(
              message.text,
              style: TextStyle(
                color: message.isUser ? Colors.white : Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
          ),
        );
      },
    );
  }
}

class AstraStatusVisualizer extends StatelessWidget {
  const AstraStatusVisualizer({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AstraState>();
    final status = state.currentStatus;
    
    String statusText;
    Color statusColor;

    switch (status) {
      case AstraStatus.listening:
        statusText = 'ESCUCHANDO...';
        statusColor = Colors.redAccent;
        break;
      case AstraStatus.processing:
        statusText = 'PROCESANDO...';
        statusColor = Colors.amber;
        break;
      case AstraStatus.speaking:
        statusText = 'ASTRA HABLANDO';
        statusColor = Theme.of(context).colorScheme.primary;
        break;
      case AstraStatus.idle:
      default:
        statusText = 'SISTEMA EN ESPERA';
        statusColor = Colors.white54;
        break;
    }

    return Column(
      children: [
        if (state.recognizedWords.isNotEmpty && status == AstraStatus.listening)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              state.recognizedWords,
              style: const TextStyle(color: Colors.white70, fontSize: 18, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: statusColor.withOpacity(0.5)),
          ),
          child: Text(
            statusText,
            style: TextStyle(
              color: statusColor,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}

class AstraMicButton extends StatefulWidget {
  const AstraMicButton({super.key});

  @override
  State<AstraMicButton> createState() => _AstraMicButtonState();
}

class _AstraMicButtonState extends State<AstraMicButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AstraState>();
    final isListening = state.currentStatus == AstraStatus.listening;
    final isSpeaking = state.currentStatus == AstraStatus.speaking;
    final isProcessing = state.currentStatus == AstraStatus.processing;

    final baseColor = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: () {
        if (isListening) {
          state.stopListening();
        } else if (isSpeaking) {
          state.stopSpeaking();
        } else if (!isProcessing) {
          state.startListening();
        }
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final scale = isListening || isSpeaking || isProcessing 
              ? 1.0 + (_controller.value * 0.15) 
              : 1.0;
          
          final glowOpacity = isListening || isSpeaking || isProcessing 
              ? 0.3 + (_controller.value * 0.4) 
              : 0.1;

          return Transform.scale(
            scale: scale,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF10162A),
                boxShadow: [
                  BoxShadow(
                    color: isListening ? Colors.redAccent.withOpacity(glowOpacity) 
                         : isProcessing ? Colors.amber.withOpacity(glowOpacity)
                         : baseColor.withOpacity(glowOpacity),
                    blurRadius: 30,
                    spreadRadius: 10,
                  )
                ],
                border: Border.all(
                  color: isListening ? Colors.redAccent.withOpacity(0.5) 
                       : isProcessing ? Colors.amber.withOpacity(0.5)
                       : baseColor.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: Icon(
                isListening ? Icons.mic : (isSpeaking ? Icons.graphic_eq : Icons.mic_none),
                size: 40,
                color: isListening ? Colors.redAccent 
                     : isProcessing ? Colors.amber
                     : baseColor,
              ),
            ),
          );
        },
      ),
    );
  }
}
