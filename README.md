
# Habit Tracker

Habit Tracker is a simple and efficient application that helps you track your daily habits. With a clean user interface supporting both light and dark modes, you can easily manage and visualize your habits using a heatmap.

## Features

- **Track Habits**: Add and manage your daily habits.
- **Check Off Habits**: Mark your habits as completed each day.
- **Heatmap Visualization**: View your progress on a monthly heatmap.
  - A day will be colored based on the completion of all habits.
  - Fully completed days have a distinct color, while partially completed days are lighter.
- **Light and Dark Mode**: Switch between light and dark themes for a comfortable user experience.
- **CRUD Operations**: Create, read, update, and delete habits seamlessly.
- **State Management**: All logic and state management handled with Provider.
- **Database**: Uses Isar database for efficient data storage and retrieval.

## Getting Started

### Prerequisites

- Flutter SDK
- Dart

### Installation

1. **Clone the repository**:
    ```bash
    git clone https://github.com/yourusername/habit-tracker.git
    cd habit-tracker
    ```

2. **Install dependencies**:
    ```bash
    flutter pub get
    ```

3. **Run the app**:
    ```bash
    flutter run
    ```

## Usage

1. **Add Habits**: Click on the "Add Habit" button to create new habits.
2. **Check Habits**: Mark your habits as done for the day by clicking on the checkbox next to each habit.
3. **View Progress**: Open the heatmap to see your monthly progress. Colors indicate your performance:
   - Full completion: Dark color
   - Partial completion: Lighter color

## Contributing

Feel free to contribute to the development of this app. Fork the repository, make your changes, and submit a pull request.
