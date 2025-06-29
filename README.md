# Ambient Flow

A modern Flutter application for creating personalized ambient soundscapes to enhance focus, relaxation, and productivity.

## Features

- **Ambient Sound Library**: A curated collection of high-quality ambient sounds including rain, thunder, wind, forest, ocean, and more.
- **Individual Volume Controls**: Adjust the volume of each sound independently to create your perfect mix.
- **Global Volume Control**: Master volume control with mute functionality.
- **Sound Bookmarks**: Save and restore your favorite sound combinations for quick access.
  - Save current playing sounds with their volume levels
  - Works for both logged-in and non-logged-in users
  - Auto-restore last used bookmark when returning to the app
  - Manage bookmarks with search, sort, and delete functionality
  - Export/import bookmarks for backup and sharing
- **Responsive Design**: Optimized for desktop, tablet, and mobile devices.
- **Dark Theme**: Modern dark interface that's easy on the eyes.
- **Animated Backgrounds**: Beautiful gradient backgrounds that transition smoothly.
- **Cross-Platform**: Works on web, mobile, and desktop platforms.
- **Firebase Authentication**: Secure user authentication with Google Sign-In.
- **Persistent Settings**: Your preferences are saved and restored across sessions.

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- Firebase project setup (for authentication)
- Web browser or mobile device for testing

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/ambient-flow.git
   cd ambient-flow
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Generate auto-route files:
   ```bash
   flutter packages pub run build_runner build
   ```

4. Set up Firebase (optional, for authentication):
   - Create a Firebase project
   - Add your web app to the project
   - Download and configure Firebase config files

### Running the Application

#### Web Development
```bash
flutter packages pub global run webdev serve
```

#### Flutter Web
```bash
flutter run -d chrome
```

#### Mobile Development
```bash
flutter run
```

#### Build for Production
```bash
# Web
flutter packages pub global run webdev build
flutter build web

# Mobile
flutter build apk  # Android
flutter build ios  # iOS
```

## Usage

### Basic Usage

1. **Playing Sounds**: Click on any sound button to start playing ambient sounds.
2. **Volume Control**: Use the individual sliders to adjust each sound's volume.
3. **Global Volume**: Use the master volume control in the app bar.
4. **Mute**: Click the volume icon to mute/unmute all sounds.

### Bookmark Features

1. **Saving Bookmarks**:
   - Play your desired combination of sounds
   - Click the bookmark save button (📖+) in the app bar
   - Enter a name and optional description
   - Click "Save Bookmark"

2. **Using Bookmarks**:
   - Click the bookmarks button (📚) to view saved bookmarks
   - Click on any bookmark to apply it instantly
   - Use the quick restore button (↻) to apply the last used bookmark

3. **Managing Bookmarks**:
   - Click the settings icon in the bookmark list to open the management screen
   - Search, sort, and organize your bookmarks
   - Delete unwanted bookmarks
   - Export/import bookmarks for backup

### Authentication

- Click the "Sign In" button to authenticate with Google
- Logged-in users can save up to 50 bookmarks
- Non-logged-in users can save up to 10 bookmarks locally
- Bookmarks are automatically synced when you sign in

## Architecture

The app follows clean architecture principles with:

- **BLoC Pattern**: State management using Cubit
- **Dependency Injection**: Service locator pattern with GetIt
- **Repository Pattern**: Data access abstraction
- **Service Layer**: Business logic separation
- **Auto Route**: Type-safe navigation

### Key Components

- `BookmarkCubit`: Manages bookmark state and operations
- `BookmarkStorageService`: Handles bookmark persistence
- `AudioCoordinatorService`: Coordinates audio operations
- `BookmarkCollection`: Manages collections of bookmarks
- `SoundBookmark`: Represents saved sound combinations

## Testing

Run the test suite:

```bash
flutter test
```

Run specific test files:

```bash
flutter test test/models/sound_bookmark_test.dart
flutter test test/models/bookmark_collection_test.dart
flutter test test/cubits/bookmark_cubit_test.dart
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Sound assets from various open-source libraries
- Flutter community for excellent packages and resources
- Firebase for authentication and cloud services