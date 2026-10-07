# Skinn - AI-Powered Skincare & Facial Skin Analysis App 🌿✨

**Skinn** is a modern Flutter mobile application designed to analyze skin concerns and skin characteristics using Google's **Gemini AI** (`gemini-3.1-flash-lite`). It allows users to create an account, log in, scan their face using their device's camera, receive immediate AI analysis (detecting concerns like Acne, Redness, Dullness, Skin Type, and Skin Tone), and store analysis history securely in Firebase Cloud Firestore.

---

## 🚀 Features

- 📸 **Live Face Scanning:** Uses device camera to capture high-quality face pictures.
- 🤖 **Gemini AI Skin Analysis:** Leverages Google Gemini AI to detect skin issues (Acne, Redness, Mild Acne, Dullness), skin type (Oily, Dry, Sensitive, Normal), and skin tone (Fair, Light, Medium, Dark).
- 🔐 **Firebase Authentication:** Secure login and sign-up with email and password.
- 📁 **Personalized Skin Records:** Stores user analysis logs in Cloud Firestore so users can track their skin journey over time.
- 🗑️ **Clear History:** Option to delete saved scan records directly from the app.
- 🎨 **Clean & Responsive UI:** Built using Flutter Material 3 with customized themes and user-friendly navigation.

---

## 🔑 IMPORTANT: Setting Up Gemini API Key

> [!IMPORTANT]
> For security reasons, the developer's Gemini API key has been removed from this project.
> **Anyone cloning or using this project must provide their own Google Gemini API key.**

### How to add your Gemini API Key:

1. Obtain a Gemini API key from [Google AI Studio](https://aistudio.google.com/).
2. Open the file `lib/constants.dart` in your code editor.
3. Replace `'YOUR_GEMINI_API_KEY_HERE'` with your actual API key:

```dart
class AppConstants {
  // Replace YOUR_GEMINI_API_KEY_HERE with your Google Gemini API key
  static const String geminiApiKey = 'YOUR_GEMINI_API_KEY_HERE';
}
```

---

## 🛠️ Tech Stack & Dependencies

- **Framework:** [Flutter SDK](https://flutter.dev) (Dart)
- **AI Model:** [Google Generative AI SDK](https://pub.dev/packages/google_generative_ai) (`google_generative_ai`)
- **Backend & Database:** [Firebase Core](https://pub.dev/packages/firebase_core), [Firebase Auth](https://pub.dev/packages/firebase_auth), [Cloud Firestore](https://pub.dev/packages/cloud_firestore)
- **Hardware Integration:** [Camera Package](https://pub.dev/packages/camera)

---

## 📦 How to Run the Project

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) installed on your system.
- An Android device or emulator with camera support.
- A valid Gemini API key from [Google AI Studio](https://aistudio.google.com/).

### Installation Steps

1. **Clone the repository:**
   ```bash
   git clone https://github.com/mughasaad-droid/skincare.git
   cd skincare
   ```

2. **Install Flutter dependencies:**
   ```bash
   flutter pub get
   ```

3. **Configure Gemini API Key:**
   - Follow the instructions in the [Setting Up Gemini API Key](#-important-setting-up-gemini-api-key) section above.

4. **Run the App:**
   ```bash
   flutter run
   ```

---

## 📂 Project Structure

```text
lib/
├── main.dart             # Application entry point & camera initialization
├── constants.dart        # Configuration constants (Gemini API key)
└── screens/
    ├── splash_screen.dart  # Animated splash screen
    ├── welcome_screen.dart # Login / Sign up selection
    ├── login_screen.dart   # Firebase authentication login
    ├── signup_screen.dart  # Firebase account creation
    ├── home_screen.dart    # Dashboard with scan & history options
    ├── camera_screen.dart  # Camera preview & image capture for AI analysis
    ├── result_screen.dart  # Display AI detection results (Issue, Skin Type, Tone)
    └── records_screen.dart # User saved skin history from Cloud Firestore
```

---

## 📄 License

This project is open-source and available under the MIT License.
