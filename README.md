# 🎓 CampusOne - Your Complete College Event Management Platform

> 🏆 **This repository is part of the Open Source 101 organised by ISTE HIT SC**

[![Flutter](https://img.shields.io/badge/Flutter-3.10.4+-02569B?logo=flutter)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

**CampusOne** is a comprehensive Flutter application designed to centralize all college activities, events, and society management in one beautiful platform. Whether you're a student looking for events to join, a club organizing activities, or an admin managing everything, CampusOne has you covered!

---

## 📖 Table of Contents
- [Why CampusOne?](#-why-campusone)
- [Features Overview](#-features-overview)
- [Quick Start Guide](#-quick-start-guide)
- [For Beginners](#-for-beginners---new-to-flutter)
- [Project Architecture](#-project-architecture)
- [Tech Stack](#-tech-stack)
- [Contributing](#-how-to-contribute)
- [Screenshots](#-screenshots)
- [Roadmap](#-roadmap)
- [Contact](#-contact)

---

## 🎯 Why CampusOne?

Ever struggled to find out what events are happening on campus? Missed a society registration deadline? Had trouble organizing club activities? **CampusOne solves all these problems!**

### The Problem
- Events scattered across multiple WhatsApp groups
- No centralized place to discover societies and clubs
- Manual event management is time-consuming
- Students miss out on opportunities

### Our Solution
A single, beautiful app where:
- ✅ All events are listed in one place
- ✅ Societies can easily manage their activities
- ✅ Students get personalized recommendations
- ✅ Everything is organized and searchable

---

## ✨ Features Overview

### 👨‍🎓 **For Students**
<table>
<tr>
<td width="50%">

**🔍 Event Discovery**
- Browse all upcoming college events
- Filter by category (Academic, Cultural, Sports, etc.)
- View detailed event information with agenda
- See event timings, venues, and requirements

</td>
<td width="50%">

**🎯 Personalized Experience**
- Create and customize your profile
- Track events you're interested in
- Get recommendations based on your interests
- Quick registration for events

</td>
</tr>
<tr>
<td width="50%">

**🏛️ Society Directory**
- Explore all clubs and societies
- View society details, events, and achievements
- Check member counts and activity levels
- Direct contact with society coordinators

</td>
<td width="50%">

**⚽ Sports & Activities**
- Stay updated with sports events
- View team information and schedules
- Track match results and standings
- Join sports clubs and teams

</td>
</tr>
</table>

### 🎪 **For Clubs & Societies**
- **📝 Society Registration** - Easy onboarding process
- **🎯 Event Creation** - Create events with rich details
- **📊 Analytics** - Track event engagement
- **👥 Member Management** - Handle membership requests
- **📢 Announcements** - Send updates to members

### 🛡️ **For Administrators**
- **📈 Dashboard** - Overview of all platform activity
- **✅ Approval System** - Review and approve events
- **🔧 User Management** - Handle user roles and permissions
- **📊 Analytics** - Platform-wide statistics

---

## 🚀 Quick Start Guide

### Prerequisites
Before you begin, ensure you have the following installed:
- **Flutter SDK** version 3.10.4 or higher ([Download here](https://flutter.dev/docs/get-started/install))
- **Dart SDK** (comes with Flutter)
- **Git** ([Download here](https://git-scm.com/downloads))
- **Android Studio** or **VS Code** with Flutter extension
- **Android Emulator** or **iOS Simulator** (or a physical device)

### Step-by-Step Installation

#### 1️⃣ Clone the Repository
```bash
git clone https://github.com/Nayab-Gauhar/campus_one.git
cd campus_one
```

#### 2️⃣ Install Dependencies
```bash
flutter pub get
```
This command downloads all the packages listed in `pubspec.yaml`

#### 3️⃣ Verify Installation
```bash
flutter doctor
```
This checks if everything is set up correctly. Fix any issues shown.

#### 4️⃣ Run the App
```bash
# To run on a connected device/emulator
flutter run

# To run in debug mode with hot reload
flutter run -d <device-id>

# To see available devices
flutter devices
```

#### 5️⃣ Build for Production (Optional)
```bash
# For Android APK
flutter build apk --release

# For Android App Bundle
flutter build appbundle --release

# For iOS (requires macOS)
flutter build ios --release
```

---

## 🆕 For Beginners - New to Flutter?

Don't worry! Here's everything you need to know:

### What is Flutter?
Flutter is a framework by Google that lets you build beautiful mobile apps for Android and iOS using a single codebase. Think of it as writing one app that works on all phones!

### What is Dart?
Dart is the programming language Flutter uses. It's similar to JavaScript, Java, and C#, so if you know any of those, you'll feel right at home!

### Setting Up Your Development Environment

#### **For Windows Users:**
1. Download Flutter SDK from [flutter.dev](https://flutter.dev)
2. Extract to `C:\src\flutter`
3. Add to PATH: `C:\src\flutter\bin`
4. Install Android Studio
5. Install Flutter and Dart plugins in Android Studio

#### **For macOS Users:**
1. Install Homebrew if not already installed
2. Run: `brew install --cask flutter`
3. Install Xcode from App Store (for iOS development)
4. Install Android Studio
5. Install Flutter and Dart plugins

#### **For Linux Users:**
1. Download Flutter SDK
2. Extract and add to PATH
3. Install Android Studio
4. Install Flutter and Dart plugins

### Understanding the Project Structure

```
campus_one/
│
├── lib/                          # Main application code
│   ├── main.dart                # App entry point (START HERE!)
│   ├── core/                    # Core functionality
│   │   └── theme/               # App colors, fonts, styles
│   ├── features/                # Feature modules
│   │   ├── admin/               # Admin-specific screens
│   │   ├── dashboard/           # Main user interface
│   │   └── ...                  # Other features
│   ├── models/                  # Data structures (Event, User, etc.)
│   ├── services/                # Business logic & data management
│   └── widgets/                 # Reusable UI components
│
├── assets/                       # Images, fonts, icons
├── android/                      # Android-specific code
├── ios/                          # iOS-specific code
├── test/                         # Unit and widget tests
│
├── pubspec.yaml                  # Project dependencies
├── README.md                     # You are here!
└── CONTRIBUTING.md              # How to contribute

```

### Key Concepts Explained

#### **1. Widgets**
Everything in Flutter is a widget! Buttons, text, layouts - all widgets.

```dart
// Example widget
Text('Hello CampusOne!')  // Displays text
ElevatedButton()          // A button
Container()               // A box to hold things
```

#### **2. State Management (Provider)**
We use Provider to manage app state. Think of it as a way to share data across different screens.

```dart
// Reading data from Provider
final events = Provider.of<EventProvider>(context).events;
```

#### **3. Navigation**
Moving between screens:

```dart
// Go to another screen
Navigator.push(context, MaterialPageRoute(
  builder: (context) => EventDetailsScreen()
));
```

#### **4. Material Design**
We use Material Design - Google's design system for beautiful, consistent UIs.

### Common Commands

```bash
# Hot reload (refresh app while running)
# Press 'r' in the terminal where flutter run is active

# Hot restart (full restart)
# Press 'R' in the terminal

# Clear cache and reinstall
flutter clean
flutter pub get

# Check for issues
flutter doctor

# Format code
dart format .

# Analyze code for errors
flutter analyze
```

### Helpful Resources for Learning
- [Flutter Official Docs](https://docs.flutter.dev/) - Best place to start
- [Flutter Codelabs](https://docs.flutter.dev/codelabs) - Hands-on tutorials
- [Dart Language Tour](https://dart.dev/guides/language/language-tour) - Learn Dart
- [Flutter Widget Catalog](https://docs.flutter.dev/ui/widgets) - All available widgets
- [Provider Package](https://pub.dev/packages/provider) - State management

---

## 🏗️ Project Architecture

CampusOne follows a **feature-first architecture** for better organization and scalability:

```
lib/
├── core/                    # Core functionality used across the app
│   └── theme/              
│       └── app_theme.dart  # Centralized theming (colors, fonts, styles)
│
├── features/               # Feature-based modules (self-contained)
│   ├── admin/             # Admin functionality
│   │   ├── screens/       # Admin screens (dashboard, approvals)
│   │   ├── widgets/       # Admin-specific widgets
│   │   └── providers/     # Admin state management
│   │
│   ├── dashboard/         # Main student dashboard
│   │   ├── screens/       # Dashboard screens
│   │   ├── widgets/       # Dashboard widgets
│   │   └── providers/     # Dashboard state
│   │
│   └── auth/              # Authentication (login, signup)
│
├── models/                # Data models (business entities)
│   ├── event.dart         # Event model
│   ├── society.dart       # Society model
│   ├── user.dart          # User model
│   └── sports_team.dart   # Sports team model
│
├── services/              # Business logic & data services
│   ├── data_service.dart  # Data fetching and management
│   └── auth_service.dart  # Authentication logic
│
├── widgets/               # Shared, reusable widgets
│   ├── custom_button.dart
│   ├── event_card.dart
│   └── ...
│
└── main.dart             # Application entry point
```

### Design Patterns Used
- **Provider Pattern** - State management
- **Repository Pattern** - Data layer abstraction
- **Feature-First** - Modular architecture

---

## 🛠️ Tech Stack

### **Core Framework**
- **Flutter** (^3.10.4) - Cross-platform UI framework
- **Dart** - Programming language

### **State Management**
- **Provider** (^6.1.5) - Simple and powerful state management

### **UI/UX Libraries**
- **Google Fonts** (^6.3.3) - Beautiful typography
- **Glassmorphism** (^3.0.0) - Modern glass-effect UI
- **Shimmer** (^3.0.0) - Elegant loading animations
- **Cached Network Image** (^3.4.1) - Optimized image loading

### **Utilities**
- **Intl** (^0.20.2) - Internationalization and date formatting
- **Table Calendar** (^3.2.0) - Beautiful calendar widget
- **Shared Preferences** (^2.5.2) - Local data persistence
- **Screen Brightness** (^2.1.7) - Brightness control

### **Development Tools**
- **Flutter Lints** (^6.0.0) - Code quality and best practices
- **Flutter Launcher Icons** (^0.13.1) - Custom app icons

---

## 🤝 How to Contribute

We ❤️ contributions! Whether you're fixing bugs, improving documentation, or adding new features, all contributions are welcome.

### Ways to Contribute

1. **🐛 Report Bugs** - Found a bug? [Open an issue](https://github.com/Nayab-Gauhar/campus_one/issues)
2. **💡 Suggest Features** - Have an idea? We'd love to hear it!
3. **📝 Improve Documentation** - Help make our docs better
4. **🔧 Submit Code** - Fix bugs or add features

### Contribution Process

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. **Make your changes**
4. **Commit with a clear message**
   ```bash
   git commit -m "feat: add event filtering by date"
   ```
5. **Push to your fork**
   ```bash
   git push origin feature/amazing-feature
   ```
6. **Open a Pull Request**

📚 Read our detailed [Contributing Guide](CONTRIBUTING.md) for more information!

### Good First Issues
New to open source? Look for issues tagged with `good-first-issue` - they're perfect for beginners!

---

## 📸 Screenshots

> 🚧 **Coming Soon!** We're working on adding screenshots to showcase the app's beautiful UI.

Want to help? Submit screenshots of your favorite features!

---

## 🗺️ Roadmap

### ✅ Phase 1 - Core Features (Completed)
- [x] User authentication
- [x] Event browsing and details
- [x] Society directory
- [x] Admin dashboard
- [x] Basic profile management

### 🚧 Phase 2 - Enhancement (In Progress)
- [ ] Backend integration (Firebase/Supabase)
- [ ] Push notifications
- [ ] Event registration system
- [ ] Image uploads
- [ ] Advanced search and filters

### � Phase 3 - Advanced Features (Planned)
- [ ] Social features (comments, likes)
- [ ] Event check-in with QR codes
- [ ] Chat/messaging system
- [ ] Analytics dashboard
- [ ] Multi-language support
- [ ] Dark mode enhancements

### 🌟 Phase 4 - Scale & Polish
- [ ] Performance optimizations
- [ ] Accessibility improvements
- [ ] Advanced caching
- [ ] Offline mode
- [ ] Integration with college systems

Want to contribute to any of these? Check out our [Contributing Guide](CONTRIBUTING.md)!

---

## 🐛 Found a Bug?

If you discover a bug, please:
1. Check if it's already reported in [Issues](https://github.com/Nayab-Gauhar/campus_one/issues)
2. If not, [create a new issue](https://github.com/Nayab-Gauhar/campus_one/issues/new) with:
   - Clear title and description
   - Steps to reproduce
   - Expected vs actual behavior
   - Screenshots (if applicable)
   - Your environment (OS, Flutter version, device)

---

## 📜 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

**In simple terms:** You can use this code freely, modify it, and distribute it, as long as you include the original license.

---

## 👥 Authors & Contributors

### Project Author
- **Nayab Gauhar** - *Creator & Maintainer* - [@Nayab-Gauhar](https://github.com/Nayab-Gauhar)

### Contributors
A big thank you to all our contributors! 🎉

> Want to see your name here? [Start contributing!](CONTRIBUTING.md)

---

## 🎉 Acknowledgments

This project wouldn't be possible without:

- 🏆 **ISTE HIT SC** - For organizing Open Source 101 and promoting open source culture
- 💙 **Flutter Team** - For the amazing framework and tools
- 📦 **Open Source Community** - For the wonderful packages we use
- 🎓 **College Community** - For inspiration and feedback
- ⭐ **All Contributors** - For your valuable contributions

---

## � Get in Touch

### Questions or Suggestions?
- 💬 **GitHub Issues**: [Ask a question](https://github.com/Nayab-Gauhar/campus_one/issues/new?labels=question)
- 📧 **Email**: Coming soon
- 🐦 **Twitter**: Coming soon

### Links
- 🌐 **Repository**: [github.com/Nayab-Gauhar/campus_one](https://github.com/Nayab-Gauhar/campus_one)
- 📋 **Issues**: [github.com/Nayab-Gauhar/campus_one/issues](https://github.com/Nayab-Gauhar/campus_one/issues)
- 🔀 **Pull Requests**: [github.com/Nayab-Gauhar/campus_one/pulls](https://github.com/Nayab-Gauhar/campus_one/pulls)

---

## ⭐ Show Your Support

If you find CampusOne helpful or interesting:

- ⭐ **Star this repository** - It helps others discover the project
- 🍴 **Fork it** - Make your own version
- 📢 **Share it** - Tell your friends and classmates
- 🤝 **Contribute** - Help make it even better

---

## 📈 Project Stats

![GitHub stars](https://img.shields.io/github/stars/Nayab-Gauhar/campus_one?style=social)
![GitHub forks](https://img.shields.io/github/forks/Nayab-Gauhar/campus_one?style=social)
![GitHub issues](https://img.shields.io/github/issues/Nayab-Gauhar/campus_one)
![GitHub pull requests](https://img.shields.io/github/issues-pr/Nayab-Gauhar/campus_one)

---

<div align="center">

**Made with ❤️ for the college community**

**Part of Open Source 101 by ISTE HIT SC** 🏆

[Report Bug](https://github.com/Nayab-Gauhar/campus_one/issues) • [Request Feature](https://github.com/Nayab-Gauhar/campus_one/issues) • [Contribute](CONTRIBUTING.md)

</div>
