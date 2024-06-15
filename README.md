# downy-Video Downloader App

This Flutter project is a comprehensive video downloader app that leverages several advanced backend packages for video downloading, encryption, decryption, and local storage. The app follows a clean architecture and uses BLoC for state management to ensure maintainability and scalability.

## Table of Contents
- [Features](#features)
- [Architecture](#architecture)
- [Packages Used](#packages-used)
- [Setup and Installation](#setup-and-installation)
- [Usage](#usage)
- [Screenshots](#screenshots)


## Features
- **Video Downloading**: Download videos using the `youtube_explode_dart` package.
- **Video Encryption**: Encrypt downloaded videos using the `encrypt` package.
- **Video Decryption**: Decrypt videos for playback.
- **Multithreading**: Use Dart Isolate for performing expensive tasks like video encryption and decryption without freezing the app.
- **Local Storage**: Store video metadata locally using the `Isar` database.
- **Video Playback**: Play videos using the `Better Player` package.
- **State Management**: Manage state efficiently with BLoC.

## Architecture
The project follows the Clean Architecture principles, ensuring a clear separation of concerns. The codebase is divided into layers:
- **Presentation**: Contains the UI and state management using BLoC.
- **Domain**: Contains the business logic.
- **Data**: Handles data retrieval and storage.

### Directory Structure


![image](https://github.com/Ashif-code-hunter/Downy/assets/71429125/ed1a5b63-1ed6-41a1-a6eb-5c0fb2c0fb88)


## Packages Used
- [youtube_explode_dart](https://pub.dev/packages/youtube_explode_dart): For downloading videos.
- [encrypt](https://pub.dev/packages/encrypt): For encrypting and decrypting videos.
- [isar](https://pub.dev/packages/isar): For local storage of video metadata.
- [better_player](https://pub.dev/packages/better_player_plus): For video playback.
- [flutter_bloc](https://pub.dev/packages/flutter_bloc): For state management with BLoC.

## Setup and Installation
1. **Clone the Repository**
   ```bash
   git clone https://github.com/Ashif-code-hunter/Downy.git
   cd Downy
2. **Install Dependencies**
   ```bash
   flutter pub get
3. **Install Dependencies**
   ```bash
   flutter run

   
## Usage
* Downloading Videos: Use the app's UI to search and download youtube videos.
* Encrypting Videos: Downloaded videos are encrypted automatically.
* Playing Videos: Play encrypted videos within the app, which decrypts them smoothly.
* Managing Videos: View and manage downloaded videos through the app's interface. 


## Screenshots
![image](https://github.com/Ashif-code-hunter/Downy/assets/71429125/f7e3d905-fbd8-4da1-9156-0a76b4e026f4)
![image](https://github.com/Ashif-code-hunter/Downy/assets/71429125/164f6867-0625-44b3-abc5-dcb012525b23)
![image](https://github.com/Ashif-code-hunter/Downy/assets/71429125/55983877-c5fa-424e-9d9b-82ff0cb714cf)

![flow (1)](https://github.com/Ashif-code-hunter/Downy/assets/71429125/c20fa57d-3fbd-469d-be24-8a5f628cb51f)






