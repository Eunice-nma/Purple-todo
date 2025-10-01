# Porple - Todo & Group Task App ✅

Porple is a simple yet powerful Flutter app for managing your daily tasks.
You can organize your tasks into groups, set reminders, and track your tasks easily.

## Essentials
- Daily Focus: Porple focuses on tasks for the current day, helping you prioritize what matters now.
- Future Reminders Only: You can set reminders, but only for future times within the day, ensuring notifications are relevant and actionable.
- Group Management: Organize tasks into groups to stay structured and efficient.

This demo focuses features that can be easily tested, such as creating tasks, grouping them, and setting reminders that are within the current day.

---

## 🚀 Features
- Create and edit task groups
- Add and edit tasks with reminders
- Mark tasks as done
- Swipe to delete tasks
- Long press to edit groups
- Color-code your groups
- Works on iOS & Android

---

## 📸 Loom video
https://www.loom.com/share/a9cda58c57174890a2f5ca11cb1e9dd2?t=230&sid=81770f98-cfe7-4ca2-8454-55decd5bd7d4

---

## 🛠 Installation
Clone the repository and run:

```bash
git clone https://github.com/Eunice-nma/Purple-todo.git
cd todo_sample_app
flutter pub get
flutter run

📂 Project Structure
lib/
 ├─ core/              # Constants, theme, utils
 │   ├─ services/      # NotificationService, StorageService
 │   └─ theme/         # Colors, text styles
 │   └─ utils/         # Helper classes
 │   └─ Widgets/       # Reuseable widgets
 ├─ features/
 │   ├─ groups/        # Group screens, modals, GroupNotifier
 │   ├─ tasks/         # Task screens, TodoNotifier
 │   └─ home/          # Home screen
 └─ main.dart

📄 License
MIT License © 2025 Nma Ndidi
