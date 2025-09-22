# 🚀 Pupilica AI Hackathon Project - RocketLica

**AI-Powered Document to PDF Converter**

A modern Flutter application developed for the Pupilica AI Hackathon that converts documents to PDF using OCR technology.

## 📋 Table of Contents

- [About the Project](#about-the-project)
- [Features](#features)
- [Technology Stack](#technology-stack)
- [Project Structure](#project-structure)
- [Installation](#installation)
- [Used Packages](#used-packages)
- [Services and Helpers](#services-and-helpers)
- [UI Components](#ui-components)
- [Data Models](#data-models)
- [Navigation](#navigation)
- [Platform Support](#platform-support)
- [Development Notes](#development-notes)
- [Contributing](#contributing)
- [License](#license)
- [License Notice](#important-license-notice)
- [Team Members](#team-members)

## 🎯 About the Project

RocketLica is a mobile application that allows users to upload photos and PDF documents, extract text using AI-powered OCR technology, and create professional PDFs.

### Key Features:
- 📸 Take photos with camera
- 📁 Upload documents via gallery and file picker
- 🤖 AI-powered OCR text extraction
- 📄 Professional PDF creation
- 💾 Local storage for data persistence
- 📤 PDF download, open, and share functionality

## ✨ Features

### 🔧 Core Features
- **Multi-Document Upload**: Upload multiple images and PDF files
- **OCR Processing**: Text extraction using Tesseract OCR
- **PDF Generation**: Create professional PDFs from extracted text
- **Local Storage**: Data persistence using SharedPreferences
- **Platform Support**: iOS, Android, and Web support

### 🎨 UI/UX Features
- **Modern Design**: Consistent design with Osmea Components
- **Gradient Backgrounds**: Visually appealing interface
- **Responsive Layout**: Adapts to different screen sizes
- **Loading States**: Loading indicators for better user experience
- **Error Handling**: Comprehensive error management

### 📱 Platform Features
- **iOS Simulator Support**: Development support for simulator
- **Web Support**: Runs in browsers
- **Device Frame**: iPhone frame display on web
- **File System**: Platform-specific file operations

## 🛠 Technology Stack

### Frontend
- **Flutter**: 3.8.1+ SDK
- **Dart**: Modern Dart programming language
- **Material Design 3**: Modern UI design system

### State Management
- **Flutter Bloc**: 9.1.1 - Reactive state management
- **Bloc**: 9.0.0 - Business logic layer
- **Equatable**: 2.0.5 - Value equality

### Navigation
- **Go Router**: 16.2.1 - Declarative routing

### Dependency Injection
- **Get It**: 8.2.0 - Service locator
- **Injectable**: 2.5.1 - Code generation

### Internationalization
- **Slang**: 4.8.1 - i18n code generation

### OCR & Document Processing
- **Flutter Tesseract OCR**: 0.4.29 - OCR processing
- **PDF Text**: 0.5.0 - PDF text extraction
- **PDF**: 3.10.7 - PDF creation
- **Image**: 4.1.7 - Image processing

### File Handling
- **File Picker**: 8.0.0+1 - File selection
- **Image Picker**: 1.0.7 - Image selection
- **Path Provider**: 2.1.5 - File path management
- **Open File**: 3.3.2 - File opening

### Storage & Sharing
- **Shared Preferences**: 2.2.2 - Local storage
- **Share Plus**: 7.2.2 - File sharing

### UI Components
- **Osmea Components**: Custom component library (AGPLv3) - *Used as Osmea Teams member*
- **Device Frame**: 1.4.0 - Device frame display

## 📁 Project Structure

```
lib/
├── main.dart                          # Application entry point
├── app/                              # Application layer
│   ├── routes/
│   │   └── app_router.dart           # Go Router configuration
│   └── views/                        # UI screens
│       ├── splash/                   # Splash screen
│       ├── onboarding/               # Onboarding flow
│       ├── home/                     # Home screen
│       ├── document_upload/          # Document upload
│       └── pdf_preview/              # PDF preview
├── core/                             # Core layer
│   ├── constants/                    # Constants
│   ├── helpers/                      # Helper classes
│   ├── models/                       # Data models
│   └── services/                     # Business logic services
└── assets/                           # Static files
    ├── images/                       # Images
    └── tessdata/                     # OCR model files
```

## 🚀 Installation

### Requirements
- Flutter SDK 3.8.1+
- Dart SDK
- iOS 12.0+ (for iOS)
- Android API 21+ (for Android)

### Steps

1. **Clone the repository:**
```bash
git clone https://github.com/NurhayatYurtaslan/pupilica_hackathon.git
cd pupilica_hackathon
```

2. **Install dependencies:**
```bash
flutter pub get
```

3. **Additional setup for iOS:**
```bash
cd ios
pod install
cd ..
```

4. **Run the application:**
```bash
# iOS Simulator
flutter run -d ios

# Android Emulator
flutter run -d android

# Web
flutter run -d web
```

## 📦 Used Packages

### UI & Navigation
| Package | Version | Description |
|---------|---------|-------------|
| `cupertino_icons` | ^1.0.8 | iOS icons |
| `device_frame` | ^1.4.0 | Device frame display |
| `osmea_components` | git (AGPLv3) | Custom UI components (*Osmea Teams member*) |
| `go_router` | ^16.2.1 | Declarative routing |

### State Management
| Package | Version | Description |
|---------|---------|-------------|
| `flutter_bloc` | ^9.1.1 | Bloc state management |
| `bloc` | ^9.0.0 | Bloc pattern |
| `equatable` | ^2.0.5 | Value equality |

### Dependency Injection
| Package | Version | Description |
|---------|---------|-------------|
| `get_it` | ^8.2.0 | Service locator |
| `injectable` | ^2.5.1 | DI code generation |

### OCR & Document Processing
| Package | Version | Description |
|---------|---------|-------------|
| `flutter_tesseract_ocr` | ^0.4.29 | OCR processing |
| `pdf_text` | ^0.5.0 | PDF text extraction |
| `pdf` | ^3.10.7 | PDF creation |
| `image` | ^4.1.7 | Image processing |

### File Handling
| Package | Version | Description |
|---------|---------|-------------|
| `file_picker` | ^8.0.0+1 | File selection |
| `image_picker` | ^1.0.7 | Image selection |
| `path_provider` | ^2.1.5 | File path management |
| `open_file` | ^3.3.2 | File opening |
| `mime` | ^1.0.5 | MIME type control |

### Storage & Sharing
| Package | Version | Description |
|---------|---------|-------------|
| `shared_preferences` | ^2.2.2 | Local storage |
| `share_plus` | ^7.2.2 | File sharing |

### Development
| Package | Version | Description |
|---------|---------|-------------|
| `flutter_lints` | ^5.0.0 | Linting rules |
| `build_runner` | ^2.7.1 | Code generation |
| `injectable_generator` | ^2.8.1 | DI code generation |
| `slang_build_runner` | ^4.8.1 | i18n code generation |

## 🔧 Services and Helpers

### Core Services

#### 📄 DocumentService
Service for document upload and management:
- **pickMultipleDocuments()**: Multiple document selection
- **pickSingleDocument()**: Single document selection
- **takePhoto()**: Take photo with camera
- **pickImageFromGallery()**: Select image from gallery
- **copyFileToAppDirectory()**: Copy file to app directory

#### 🤖 OCRService
Service for OCR operations:
- **extractTextFromImage()**: Extract text from image
- **extractTextFromPDF()**: Extract text from PDF
- **preprocessImage()**: Image preprocessing for OCR
- **extractTextFromFile()**: Extract text based on file type
- **isValidFileType()**: File type validation

#### 📚 LessonService
Service for lesson notes management:
- **addLessonNote()**: Add new lesson note
- **processLessonNote()**: Process lesson note with OCR
- **updateLessonNote()**: Update lesson note
- **deleteLessonNote()**: Delete lesson note
- **searchLessonNotes()**: Search lesson notes
- **getStatistics()**: Get statistics information

#### 📄 PDFService
Service for PDF creation and management:
- **createPDF()**: Create PDF
- **savePDFToDevice()**: Save PDF to device
- **sharePDF()**: Share PDF
- **getPDFPreview()**: Get PDF preview

#### 🖥️ PlatformOCRService
Platform-specific OCR control:
- **isOCRAvailable**: OCR availability check
- **platformErrorMessage**: Platform error messages
- **logPlatformInfo()**: Log platform information

### Core Helpers

#### 💾 LocalStorageHelper
Local storage management:
- **String operations**: String data operations
- **Int operations**: Integer data operations
- **Bool operations**: Boolean data operations
- **Double operations**: Double data operations
- **List operations**: List data operations
- **JSON operations**: JSON data operations
- **Lesson Note operations**: Special lesson note operations

#### 📁 FileDownloadHelper
File download and sharing:
- **savePDFToDevice()**: Save PDF to device
- **sharePDF()**: Share PDF
- **saveAndSharePDF()**: Save and share
- **openPDF()**: Open PDF
- **saveAndOpenPDF()**: Save and open

#### 📝 Logger
Logging system:
- **LogLevel**: Debug, Info, Warning, Error, Success
- **LogCategory**: Category-based logging
- **Emoji mapping**: Emoji support for categories

## 🎨 UI Components

### Views

#### 🚀 SplashView
- Application startup screen
- Gradient background
- Loading animation
- Logo display

#### 📖 OnboardingView
- 4-page onboarding flow
- PageView transitions
- Skip and navigation buttons
- Gradient backgrounds

#### 🏠 HomeView
- Home screen
- Quick action buttons
- Information section
- Modern card design

#### 📤 DocumentUploadView
- Document upload interface
- Multiple upload options
- Progress indicators
- File list

#### 👁️ PDFPreviewView
- PDF preview and editing
- Form fields (title, subject)
- Action buttons (download, open, share)
- Modal options

### Widgets

#### Onboarding Widgets
- **OnboardingPageWidget**: Page content
- **OnboardingNavigationWidget**: Navigation controls
- **OnboardingSkipButtonWidget**: Skip button

## 📊 Data Models

### LessonNote
Lesson note data model:
```dart
class LessonNote {
  final String id;
  final String title;
  final String subject;
  final String description;
  final List<DocumentFile> documents;
  final String extractedText;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isProcessed;
}
```

### DocumentFile
Document file model:
```dart
class DocumentFile {
  final String name;
  final String path;
  final int size;
  final DocumentType type;
}
```

### OnboardingPage
Onboarding page model:
```dart
class OnboardingPage {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
}
```

## 🧭 Navigation

### Go Router Configuration
```dart
static final GoRouter router = GoRouter(
  initialLocation: splash,
  routes: [
    GoRoute(path: splash, builder: (context, state) => const SplashView()),
    GoRoute(path: onboarding, builder: (context, state) => const OnboardingView()),
    GoRoute(path: home, builder: (context, state) => const HomeView()),
    GoRoute(path: documentUpload, builder: (context, state) => const DocumentUploadView()),
    GoRoute(path: pdfPreview, builder: (context, state) => PDFPreviewView(...)),
  ],
);
```

### Route Definitions
- `/` - Splash screen
- `/onboarding` - Onboarding flow
- `/home` - Home screen
- `/document-upload` - Document upload
- `/pdf-preview` - PDF preview

## 📱 Platform Support

### iOS
- ✅ iOS 12.0+
- ✅ Simulator support
- ✅ Real device support
- ✅ Files app integration

### Android
- ✅ API 21+
- ✅ Emulator support
- ✅ Real device support

### Web
- ✅ Modern browsers
- ✅ iPhone frame display
- ✅ Responsive design

## 🔧 Development Notes

### State Management
- **Bloc Pattern**: Bloc usage for all views
- **Event-Driven**: Event-based state changes
- **Immutable State**: Immutable state structure

### Error Handling
- **Try-Catch**: Comprehensive error catching
- **Logger Integration**: Error logging
- **User Feedback**: User error notifications

### Performance
- **Lazy Loading**: Load when needed
- **Image Optimization**: Image optimization
- **Memory Management**: Memory management

### Code Quality
- **Linting**: Flutter lints rules
- **Code Generation**: Automatic code generation
- **Type Safety**: Strong type system

## 🚀 Future Features

- [ ] Cloud storage integration
- [ ] Batch processing
- [ ] Advanced OCR settings
- [ ] PDF template system
- [ ] User authentication
- [ ] Offline mode improvements
- [ ] Multi-language support

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Create Pull Request

## 📄 License

This project is licensed under the [MIT License](LICENSE).

### ⚠️ Important License Notice

This project contains dependencies with **different license requirements**:

- **Most dependencies**: MIT, Apache 2.0, BSD licenses (permissive)
- **Osmea Components**: AGPLv3 license (**copyleft with network clause**)

**AGPLv3 Impact**: If you deploy this application where users access it over a network (web/server), you must provide the complete source code to users.

For detailed license information and compliance requirements, see [LICENSES.md](LICENSES.md).

### Third-Party Licenses

This project uses the following third-party packages with their respective licenses:

#### BSD 3-Clause License
- **flutter_tesseract_ocr**: Copyright (c) 2019, Ahmet Tok
- **equatable**: Copyright (c) 2019, Felix Angelov

#### Apache License 2.0
- **Flutter SDK**: Copyright 2014 The Flutter Authors
- **Dart SDK**: Copyright 2012 The Dart Authors
- **go_router**: Copyright 2022 The go_router Authors
- **flutter_bloc**: Copyright 2018 Felix Angelov
- **bloc**: Copyright 2018 Felix Angelov
- **get_it**: Copyright 2018 Thomas Buchner
- **injectable**: Copyright 2018 Thomas Buchner
- **path_provider**: Copyright 2013 The Flutter Authors
- **shared_preferences**: Copyright 2013 The Flutter Authors
- **file_picker**: Copyright 2018 Miguel Ruivo
- **image_picker**: Copyright 2013 The Flutter Authors
- **open_file**: Copyright 2019 wemgl
- **share_plus**: Copyright 2020 Kasper
- **pdf**: Copyright 2019 David PHAM-VAN
- **pdf_text**: Copyright 2020 David PHAM-VAN
- **image**: Copyright 2013 The Dart Authors
- **mime**: Copyright 2013 The Dart Authors
- **device_frame**: Copyright 2020 Alois Daniel
- **slang**: Copyright 2022 Simon Choi
- **path**: Copyright 2013 The Dart Authors
- **cupertino_icons**: Copyright 2019 The Flutter Authors

#### MIT License
- **build_runner**: Copyright 2018 Dart Team
- **injectable_generator**: Copyright 2018 Thomas Buchner
- **slang_build_runner**: Copyright 2022 Simon Choi
- **flutter_lints**: Copyright 2021 The Flutter Authors

#### AGPLv3 License
- **osmea_components**: Copyright Osmea Teams - [View License](https://github.com/masterfabric-mobile/osmea/blob/main/LICENSE)

**📋 Usage Notice**: Osmea Components has been used as an Osmea Teams member.

**⚠️ Important AGPLv3 Notice**: The Osmea Components library uses AGPLv3 license, which requires:
- Source code disclosure for network/web deployments
- Any modifications must be shared under AGPLv3
- Affects SaaS and web applications
- See [LICENSES.md](LICENSES.md) for complete compliance details

## 🙏 Acknowledgments

- **flutter_tesseract_ocr**: For OCR processing capabilities
- **Osmea Components**: For UI components library (AGPLv3) - *Used as Osmea Teams member*
- **Flutter Team**: For the amazing framework
- **Pupilica**: For organizing the hackathon
- **💙 Osmea Teams**: Special thanks to Osmea Teams for their support

## 📞 Contact

- **Project**: Pupilica AI Hackathon
- **Repository**: [pupilica_hackathon](https://github.com/NurhayatYurtaslan/pupilica_hackathon)
- **Developer**: Nurhayat Yurtaslan
- **GitHub**: [@NurhayatYurtaslan](https://github.com/NurhayatYurtaslan)
- **License Details**: See [LICENSES.md](LICENSES.md) for complete information

### 👥 Team Members

| Name | GitHub Profile | Role |
|------|----------------|------|
| **Nurhayat Yurtaslan** | [@NurhayatYurtaslan](https://github.com/NurhayatYurtaslan) | Team Lead & Developer |
| **Melih Alkabak** | [@melihalkbk](https://github.com/melihalkbk) | Developer |
| **Sultan Kayı** | [@sultannkayi](https://github.com/sultannkayi) | Developer |

**Team:** RocketLica Development Team  
**Hackathon:** Pupilica Yapay Zeka Hackathonu

---

**RocketLica** - AI-Powered Document to PDF Converter 🚀📄

*This project was created for the Pupilica Yapay Zeka Hackathonu by the RocketLica Development Team.*

**Team:** [@NurhayatYurtaslan](https://github.com/NurhayatYurtaslan) • [@melihalkbk](https://github.com/melihalkbk) • [@sultannkayi](https://github.com/sultannkayi)