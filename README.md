# videosummarizer

A powerful Flutter application that transforms YouTube videos into structured summaries, presentations, and action plans using advanced AI technology.

## Features

- **Multiple AI Providers**: Choose between Mock processing and Google Gemini AI
- **Video Processing**: Convert YouTube videos into structured content
- **Multiple Output Formats**: 
  - Comprehensive summaries
  - Presentation-ready formats
  - Actionable plans
- **Real-time Processing**: Live streaming of AI-generated content
- **Notes Management**: Create and organize personal notes
- **Cross-platform**: Works on iOS, Android, and Web

## AI Integration

### Gemini AI
This app integrates with Google's Gemini AI for advanced natural language processing:
- Text generation and summarization
- Multi-modal content processing
- Streaming responses for real-time updates
- Multiple model support (gemini-1.5-flash, gemini-1.5-pro, etc.)

### Setup Instructions

1. **Get Gemini API Key**:
   - Visit [Google AI Studio](https://aistudio.google.com/app/apikey)
   - Create or sign in to your Google account
   - Generate a new API key
   - Save the API key securely

2. **Configure Environment Variables**:
   ```bash
   # For development
   flutter run --dart-define=GEMINI_API_KEY=your_gemini_api_key_here
   
   # For building
   flutter build apk --dart-define=GEMINI_API_KEY=your_gemini_api_key_here
   ```

3. **Alternative Configuration**:
   You can also set up environment variables in your IDE:
   - **VS Code**: Add to launch.json configurations
   - **Android Studio**: Add to run configurations
   - **Command Line**: Export as environment variable

## Getting Started

### Prerequisites
- Flutter SDK ≥ 3.10
- Dart ≥ 3.0
- Valid Gemini API key (optional, app works with mock data)

### Installation

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd videosummarizer
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the application**:
   ```bash
   # With mock AI (no API key required)
   flutter run
   
   # With Gemini AI
   flutter run --dart-define=GEMINI_API_KEY=your_api_key
   ```

## Usage

### Processing Videos

1. **Add Video URL**: Enter a YouTube video URL
2. **Choose Processing Mode**:
   - **Summary**: Comprehensive overview with key points
   - **Presentation**: Structured format ready for presentations
   - **Action Plan**: Actionable items with priorities and timelines
3. **Select AI Provider**:
   - **Mock**: Uses predefined responses (no API key required)
   - **Gemini**: Uses real AI processing (requires API key)
4. **Monitor Progress**: Watch real-time processing status
5. **View Results**: Access generated content and save notes

### Managing Notes

- Create personal notes during video review
- Organize with tags and categories
- Search and filter your note library
- Export notes in various formats

## Architecture

### Core Components

- **Services Layer**: AI processing, API clients, data management
- **Presentation Layer**: UI screens and widgets
- **Core Layer**: Shared utilities, themes, and configurations
- **Routes**: Navigation and screen management

### AI Processing Flow

1. **Video Input**: URL validation and metadata extraction
2. **Content Analysis**: Transcript processing and structure analysis
3. **AI Processing**: Gemini API integration or mock processing
4. **Output Generation**: Formatted content creation
5. **Storage**: Save processed content and user notes

## API Integration

### Gemini API Features

- **Text Generation**: Create summaries and structured content
- **Streaming**: Real-time content generation
- **Multi-modal**: Process text and images
- **Model Selection**: Choose optimal model for your use case

### Supported Models

- `gemini-1.5-flash-002`: Fast, cost-effective processing
- `gemini-1.5-pro`: Advanced reasoning and complex tasks
- `gemini-2.0-flash`: Latest generation with enhanced capabilities

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## Security Notes

- Never commit API keys to version control
- Use environment variables for sensitive data
- Consider using backend proxy for production apps
- Regularly rotate API keys

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions:
- Check the documentation
- Review existing issues
- Create a new issue with detailed information

---

**Note**: This application is designed for educational and productivity purposes. Please ensure you comply with YouTube's terms of service when processing videos.