# Task Management App

This is a simple task management application built with Flutter and Dart. It allows users to create, update, delete, and view tasks. The app uses a local Hive database to store tasks.

## Features

- Create new tasks
- Update existing tasks
- Delete tasks
- View all tasks
- Mark tasks as completed

## Pre-requisites
| Requirement | Version |
| ----------- | ------- |
| Flutter     | 3.29.3  |
| Dart        | 3.7.2   |

## Getting Started
```bash
# Get the dependencies
flutter pub get
# Generate the necessary files
flutter pub run build_runner build --delete-conflicting-outputs
# Run the app
flutter run
```

## Project Structure

```
lib
├── core                  # Contains core functionalities and utilities
├── features              # Contains feature-specific code
│   ├── home              # Home screen and related widgets
|   |   ├── data          # Data layer (models, data sources)
│   |   ├── domain        # Domain layer (use cases, repositories)
│   |   └── presentation  # Presentation layer (UI components, screens, widgets, business logic)
|
|
├── main.dart             # Entry point of the application
```

- **Data Layer**: Contains the models and data sources for the application. This is where the Hive database is set up and managed.
- **Domain Layer**: Contains use cases and repositories. This is where the repository functions are defined and implemented.
- **Presentation Layer**: Contains the UI components of the application, including screens, widgets, and business logic. This is where the visual elements and user interactions are defined and implemented.