import 'package:shared_preferences/shared_preferences.dart';

import './gemini_client.dart';
import './gemini_service.dart';

class AIProcessingService {
  static final AIProcessingService _instance = AIProcessingService._internal();
  late GeminiClient? _geminiClient;
  String _selectedProvider = 'mock'; // 'mock' or 'gemini'

  factory AIProcessingService() {
    return _instance;
  }

  AIProcessingService._internal() {
    _initializeService();
  }

  Future<void> _initializeService() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedProvider = prefs.getString('ai_provider') ?? 'mock';

    // Initialize Gemini client if API key is available
    try {
      if (GeminiService.apiKey.isNotEmpty) {
        final service = GeminiService();
        _geminiClient = GeminiClient(service.dio, service.authApiKey);
      }
    } catch (e) {
      // Gemini API key not available, use mock data
      _geminiClient = null;
    }
  }

  Future<void> setAIProvider(String provider) async {
    _selectedProvider = provider;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ai_provider', provider);
  }

  String get currentProvider => _selectedProvider;
  bool get isGeminiAvailable => _geminiClient != null;

  Future<String> processVideoSummary({
    required String videoTranscript,
    required String mode,
  }) async {
    if (_selectedProvider == 'gemini' && _geminiClient != null) {
      try {
        final completion = await _geminiClient!.summarizeVideo(
          videoTranscript: videoTranscript,
          mode: mode,
        );
        return completion.text;
      } on GeminiException catch (e) {
        throw AIProcessingException(
          'Gemini API Error: ${e.message}',
          statusCode: e.statusCode,
        );
      } catch (e) {
        throw AIProcessingException(
          'Unexpected error during AI processing: ${e.toString()}',
        );
      }
    } else {
      // Mock processing for demonstration
      return _generateMockSummary(mode);
    }
  }

  Stream<String> streamVideoSummary({
    required String videoTranscript,
    required String mode,
  }) async* {
    if (_selectedProvider == 'gemini' && _geminiClient != null) {
      try {
        String prompt = _buildPromptForMode(videoTranscript, mode);
        final message = Message(role: 'user', content: prompt);

        await for (final chunk in _geminiClient!.streamChat(
          messages: [message],
          maxTokens: 2048,
          temperature: 0.7,
        )) {
          yield chunk;
        }
      } on GeminiException catch (e) {
        throw AIProcessingException(
          'Gemini API Error: ${e.message}',
          statusCode: e.statusCode,
        );
      }
    } else {
      // Mock streaming for demonstration
      final mockSummary = _generateMockSummary(mode);
      final words = mockSummary.split(' ');

      for (int i = 0; i < words.length; i += 3) {
        await Future.delayed(const Duration(milliseconds: 200));
        final chunk =
            words.sublist(i, (i + 3).clamp(0, words.length)).join(' ') + ' ';
        yield chunk;
      }
    }
  }

  String _buildPromptForMode(String videoTranscript, String mode) {
    switch (mode.toLowerCase()) {
      case 'summary':
        return '''
        Please provide a comprehensive summary of the following video transcript. Include:
        - Main topics discussed
        - Key insights and takeaways
        - Important details and examples
        - Conclusion or recommendations if any
        
        Video transcript:
        $videoTranscript
        ''';
      case 'presentation':
        return '''
        Convert the following video transcript into a well-structured presentation format with:
        - Clear title and sections
        - Bullet points for key information
        - Introduction, main content, and conclusion
        - Speaker notes or additional context where helpful
        
        Video transcript:
        $videoTranscript
        ''';
      case 'action plan':
        return '''
        Based on the following video transcript, create an actionable plan with:
        - Specific action items
        - Priority levels
        - Timeline suggestions
        - Required resources or tools
        - Success metrics where applicable
        
        Video transcript:
        $videoTranscript
        ''';
      default:
        return '''
        Please analyze and summarize the following video transcript:
        
        $videoTranscript
        ''';
    }
  }

  String _generateMockSummary(String mode) {
    switch (mode.toLowerCase()) {
      case 'summary':
        return '''
        # Video Summary

        ## Main Topics
        - Advanced Flutter state management techniques
        - Provider pattern implementation
        - Bloc architecture best practices
        - Performance optimization strategies

        ## Key Insights
        - State management is crucial for scalable Flutter applications
        - Provider offers a simple yet powerful solution for small to medium apps
        - Bloc pattern provides better separation of concerns for complex applications
        - Performance can be improved by minimizing widget rebuilds

        ## Important Details
        - Use Consumer widgets to limit rebuild scope
        - Implement proper dispose methods to prevent memory leaks
        - Consider using freezed for immutable state classes
        - Test state management logic thoroughly

        ## Recommendations
        - Start with Provider for simple applications
        - Migrate to Bloc for complex business logic
        - Always profile your app's performance
        - Follow Flutter's official guidelines for state management
        ''';
      case 'presentation':
        return '''
        # Flutter State Management Mastery
        
        ## Introduction
        - State management is the backbone of Flutter applications
        - Choosing the right approach depends on app complexity
        - This presentation covers the most popular solutions
        
        ## Provider Pattern
        ### Benefits
        - Simple to understand and implement
        - Great for small to medium applications
        - Minimal boilerplate code
        
        ### Use Cases
        - Theme management
        - User authentication state
        - Simple data sharing between widgets
        
        ## Bloc Architecture
        ### Benefits
        - Excellent separation of concerns
        - Highly testable
        - Scalable for large applications
        
        ### Components
        - Events: User interactions or system events
        - States: Different states of the application
        - Bloc: Business logic component
        
        ## Best Practices
        - Keep state immutable
        - Use meaningful names for events and states
        - Implement proper error handling
        - Test business logic separately from UI
        
        ## Conclusion
        - Choose the right tool for your specific needs
        - Start simple and evolve as requirements grow
        - Always prioritize maintainability and testability
        ''';
      case 'action plan':
        return '''
        # Flutter State Management Action Plan
        
        ## Immediate Actions (Week 1)
        ### Priority: High
        - [ ] Evaluate current state management approach
        - [ ] Identify pain points in existing codebase
        - [ ] Set up development environment for testing new patterns
        
        ### Resources Needed
        - Flutter SDK (latest stable version)
        - IDE with Flutter plugins
        - Testing framework setup
        
        ## Short-term Goals (Weeks 2-4)
        ### Priority: High
        - [ ] Implement Provider pattern for simple state
        - [ ] Create reusable provider widgets
        - [ ] Write unit tests for state logic
        
        ### Priority: Medium
        - [ ] Explore Bloc pattern for complex features
        - [ ] Set up Bloc architecture in a feature branch
        - [ ] Document new patterns for team adoption
        
        ## Long-term Objectives (Months 2-3)
        ### Priority: High
        - [ ] Migrate critical features to chosen pattern
        - [ ] Establish coding standards and guidelines
        - [ ] Train team members on new architecture
        
        ### Priority: Medium
        - [ ] Implement advanced patterns (Cubit, Riverpod)
        - [ ] Set up automated testing for state management
        - [ ] Create performance benchmarks
        
        ## Success Metrics
        - Reduced bug reports related to state issues
        - Improved code maintainability scores
        - Faster feature development cycles
        - Better test coverage (target: 80%+)
        
        ## Timeline
        - Week 1: Assessment and planning
        - Weeks 2-4: Implementation and testing
        - Months 2-3: Migration and optimization
        
        ## Required Tools
        - Provider package
        - Bloc library
        - Testing frameworks (test, mockito)
        - Code analysis tools (dart analyze)
        ''';
      default:
        return '''
        This is a comprehensive overview of the video content covering various aspects of the discussed topics. The content has been analyzed and structured to provide maximum value to the viewer.
        ''';
    }
  }
}

class AIProcessingException implements Exception {
  final String message;
  final int? statusCode;

  AIProcessingException(this.message, {this.statusCode});

  @override
  String toString() => 'AIProcessingException: $message';
}
