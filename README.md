# **Project Title: Electricity Consumption Estimator (Consumer+)**
https://github.com/TheHiddenDeveloper/Consumerplus/blob/master/assets/images/logo_no_bg.png

## **Project Overview**

**Consumer+** is an app designed to help residents monitor and estimate their electricity consumption. It offers features such as real-time usage tracking, monthly cost estimation, and easy management of home appliances. The app integrates Firebase services for backend support, shared preferences for onboarding and user management, and employs state-of-the-art UI design patterns and navigation flows using Flutter.

## **Table of Contents**

1. [Project Overview](#project-overview)
2. [Key Features](#key-features)
3. [Architecture](#architecture)
4. [Project Setup](#project-setup)
5. [Dependencies](#dependencies)
6. [Directory Structure](#directory-structure)
7. [Services and Utils](#services-and-utils)
8. [Flow and Navigation](#flow-and-navigation)
9. [Future Enhancements](#future-enhancements)

---

## **Key Features**

1. **Electricity Usage Tracking**: 
   - Provides real-time data on electricity consumption.
2. **Bill Estimation**: 
   - Estimates monthly electricity bills based on usage.
3. **Appliance Management**: 
   - Users can easily add, remove, and monitor home appliances.
4. **User Onboarding**: 
   - A guided onboarding experience for first-time users.
5. **Permissions Handling**:
   - Manages permissions such as camera, storage, and location.
6. **Profile and Settings**:
   - Users can update and manage their profile and app settings.
7. **Responsive UI**: 
   - Supports both light and dark themes with an adaptive design.

---

## **Architecture**

### **Architecture Pattern: MVVM (Model-View-ViewModel)**

The **Model-View-ViewModel (MVVM)** architecture pattern is employed to make the app modular and scalable.

1. **Model**:
   - Handles the data layer of the app, including data storage and communication with external APIs and databases (Firestore).
   
2. **View**:
   - The UI of the app built using Flutter's widget tree. Each screen in the app (Login, Dashboard, etc.) represents the view layer.

3. **ViewModel**:
   - Acts as an intermediary between the View and Model, handling all the logic and data processing. ViewModels provide data for views and receive updates from models.

### **Service Layer**
- Services such as `AuthService` and `DBService` are responsible for handling communication with external systems (Firebase) and managing user authentication and database interaction.

---

## **Project Setup**

### **Prerequisites**

1. Flutter SDK
2. Firebase Project
3. Dart 3.0 or higher
4. Android Studio/Xcode for running on mobile devices

### **Installation Steps**

1. Clone the repository:
   ```bash
   git clone https://github.com/TheHiddenDeveloper/Consumerplus/.git
   ```
2. Navigate to the project directory:
   ```bash
   cd consumerplus
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Configure Firebase:
   - Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) files to the appropriate directories.
   
5. Run the app:
   ```bash
   flutter run
   ```

---

## **Dependencies**

The project relies on the following packages:

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: latest_version
  cloud_firestore: latest_version
  firebase_auth: latest_version
  shared_preferences: latest_version
  fl_chart: latest_version
  provider: latest_version
```

---

## **Directory Structure**

```
lib/
│
├── main.dart                # App entry point
├── services/                # Application service layer
│   ├── auth_service.dart     # Handles user authentication
│   ├── db_service.dart       # Manages Firestore database operations
│   └── user_preferences.dart # Stores app-related data like onboarding status
├── utils/                   # Utility classes
│   ├── fade_route.dart       # Implements custom page transitions
│   └── custom_theme.dart     # Custom light and dark themes
├── screens/                 # Flutter UI screens
│   ├── splash_screen.dart    # Splash screen logic
│   ├── onboarding_screen.dart# Onboarding screen
│   ├── auth/                # Authentication-related screens
│   │   ├── login_screen.dart # Login screen
│   │   └── sign_up_screen.dart
│   ├── dashboard/           # Dashboard and its components
│   └── permissions/         # Handles app permission checks
├── models/                  # Model classes
└── widgets/                 # Reusable widget components
```

---

## **Services and Utils**

### **Services**

1. **AuthService (`auth_service.dart`)**
   - Handles user authentication with Firebase (sign-in, sign-up, password reset).
   
2. **DBService (`db_service.dart`)**
   - Handles interaction with Firestore, specifically saving and retrieving appliance data.

3. **UserPreferences (`user_preferences.dart`)**
   - Stores user data such as onboarding completion and login status in local storage using `shared_preferences`.

### **Utils**

1. **CustomTheme (`custom_theme.dart`)**
   - Defines both light and dark themes for the app, making the UI responsive to theme changes.
   
2. **FadeRoute (`fade_route.dart`)**
   - A custom transition for smooth navigation between screens.

---

## **Flow and Navigation**

### **App Flow**

1. **Fresh Install**:  
   - **SplashScreen** → **OnboardingScreen** → **LoginScreen**.
   
2. **Existing Users**:
   - If logged in, user navigates directly to the **LoginScreen** after the **SplashScreen**.
   - If not logged in, user is taken to the **LoginScreen**.

3. **Post-Login**:
   - **PermissionScreen**: The app checks for the required permissions before proceeding to the dashboard.
   - **DashboardScreen**: Displays the user's appliance data and analytics.

### **Navigation**

- Navigation between screens is handled using `Navigator.pushReplacement` or `Navigator.push`, with some transitions customized using `FadeRoute`.

---

## **Future Enhancements**

1. **Multi-language Support**:
   - Provide support for multiple languages for global users.
   
2. **Notification System**:
   - Send notifications to users when they exceed their estimated energy consumption.

3. **Enhanced Analytics**:
   - More advanced data visualization for better energy consumption insights.

4. **Offline Mode**:
   - Implement offline data storage to allow users to view previously stored data when they are offline.

5. **User Roles and Admin Panel**:
   - Implement different user roles (e.g., admin) with different levels of app access.

#Screenshots of UI


