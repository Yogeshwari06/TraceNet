# TraceNet - Hybrid Emergency Communication and Community Safety Platform

## Project Overview

TraceNet is a comprehensive Flutter application designed to provide reliable emergency communication during disasters such as:
- Floods
- Cyclones
- Earthquakes
- Building Collapse
- Fire Accidents
- Temporary Network Failure

The application intelligently selects the best available communication method automatically.

## Communication Priority

The application follows an intelligent communication priority system:

1. **Internet** (Firebase)
2. **SMS** (Cellular)
3. **Wi-Fi Direct**
4. **Bluetooth**
5. **Local Storage** (Hive) - Auto sync later

**No manual switching required** - Everything happens automatically.

## Target Users

- General Public
- Disaster Management Authorities
- Rescue Teams
- Educational Institutions (Colleges)
- Residential Communities
- Trekking Groups

## Main Features

### Core Features
- ✅ User Registration & Authentication
- ✅ User Login
- ✅ Dashboard
- ✅ Chat/Messaging
- ✅ Emergency SOS
- ✅ Emergency Templates
- ✅ Nearby Users Discovery
- ✅ Community Map
- ✅ Alert History
- ✅ User Settings
- ✅ Rescue Dashboard
- ✅ Last Known Location Tracking
- ✅ Emergency Recommendations

## Tech Stack

### Frontend
- **Framework**: Flutter
- **Language**: Dart
- **IDE**: VS Code

### Backend & Services
- **Authentication**: Firebase Authentication
- **Database**: Cloud Firestore
- **Notifications**: Firebase Cloud Messaging (FCM)
- **Maps**: Google Maps API
- **Location**: Geolocator
- **Offline Storage**: Hive
- **Communication**: SMS, Wi-Fi Direct, Bluetooth

### Development Tools
- **Version Control**: Git & GitHub
- **State Management**: Provider
- **Architecture**: Clean Architecture

## Project Structure

```
lib/
├── config/              # App configuration and theme
├── core/                # Core functionality and providers
├── constants/           # App constants (colors, strings, sizes)
├── models/              # Data models and entities
├── providers/           # Business logic providers
├── repositories/        # Data access layer
├── services/            # Application services
├── communication/       # Multi-mode communication module
├── emergency/           # Emergency and SOS module
├── database/            # Local storage (Hive)
├── screens/             # UI Screens
│   ├── splash/
│   ├── auth/           # Login & Register
│   ├── dashboard/
│   ├── chat/
│   ├── sos/
│   ├── map/
│   ├── settings/
│   ├── profile/
│   ├── alert_history/
│   └── nearby_users/
├── widgets/             # Reusable widgets
├── routes/              # Navigation and routing
├── utils/               # Utility functions
└── main.dart            # App entry point
```

## UI Theme

- **Modern & Minimal Design**
- **Professional Appearance**
- **Emergency-Focused Theme**
- **Colors**:
  - Primary: Dark Blue (#1A237E)
  - Secondary: White (#FFFFFF)
  - SOS Alert: Red (#E53935)
  - Background: Light Grey (#FAFAFA)
  - Cards: White (#FFFFFF)
- **Material 3 Design System**
- **Rounded Cards & Beautiful Animations**
- **Responsive Layout**

## Database Collections

- **Users** - User profiles and information
- **Messages** - Communication messages
- **SOS** - SOS alerts and emergency signals
- **EmergencyContacts** - Emergency contact information
- **Alerts** - Community and system alerts
- **RescueRequests** - Rescue operation requests
- **CommunityAlerts** - Community safety alerts

## Novel Features

1. 🔄 **Hybrid Multi-Mode Communication**
2. 🔍 **Automatic Network Detection**
3. 📋 **Smart Emergency Templates**
4. 🔄 **Intelligent Pending Synchronization**
5. 📢 **Dual Emergency Alert Delivery**
6. 🗺️ **Community Safety Dashboard**
7. 📍 **Smart Nearby Communication**
8. 🚨 **Intelligent SOS Prioritization**
9. 👮 **Rescue Status Tracking**
10. ⚠️ **Dynamic Risk Zone Detection**
11. 📍 **Last Known Location Tracking**
12. 💡 **Emergency Recommendation System**

## Development Phases

### Phase 1: Foundation (Current)
- ✅ Project structure setup
- ✅ Theme configuration (Material 3)
- ✅ Navigation setup
- ✅ Screen scaffolds
- ✅ Reusable widgets
- ✅ Constants and configuration

### Phase 2: Authentication (Coming)
- Firebase setup
- User registration
- User login
- Authentication flow
- User profile management

### Phase 3: Core Features (Coming)
- Chat/Messaging
- SOS system
- Emergency templates
- Community map
- Nearby users

### Phase 4: Communication Module (Coming)
- Internet communication (Firebase)
- SMS communication
- Wi-Fi Direct integration
- Bluetooth integration
- Local storage sync

### Phase 5: Advanced Features (Coming)
- Rescue dashboard
- Alert history
- Emergency recommendations
- Risk zone detection
- Last known location tracking

## Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK
- Firebase project setup
- Google Maps API key
- Android & iOS development environments

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/tracenet.git
   cd tracenet
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase** (Phase 2)
   - Add `google-services.json` (Android)
   - Add `GoogleService-Info.plist` (iOS)

4. **Run the app**
   ```bash
   flutter run
   ```

## Coding Standards

### Clean Code Principles
- ✅ Write clean, readable code
- ✅ Use meaningful variable and function names
- ✅ Add comments for complex logic
- ✅ Create reusable components
- ✅ Avoid code duplication
- ✅ Follow SOLID principles
- ✅ Separate UI and Business Logic

### State Management
- Use **Provider** for state management
- No scattered `setState` calls
- Business logic separated from UI

### Architecture
- Follow **Clean Architecture** pattern
- Feature-based folder structure
- Each module: Models, Services, Providers, Screens, Widgets

## File Organization

### Constants (`lib/constants/`)
- `app_colors.dart` - Color palette
- `app_strings.dart` - String constants
- `app_sizes.dart` - Sizing and spacing constants

### Configuration (`lib/config/`)
- `app_config.dart` - App configuration
- `app_theme.dart` - Theme setup (Material 3)

### Widgets (`lib/widgets/`)
- `custom_app_bar.dart` - App bar component
- `custom_button.dart` - Button components
- `custom_card.dart` - Card components
- `custom_text_field.dart` - Text input components

### Screens (`lib/screens/`)
- Feature-based organization
- Each screen in its own folder
- Self-contained screen modules

## Configuration

### Add Asset Files
Place your asset files in the `assets/` folder:
- Images: `assets/images/`
- Icons: `assets/icons/`
- Animations: `assets/animations/`
- Fonts: `assets/fonts/`

All assets are already configured in `pubspec.yaml`.

### Customize Theme
Edit `lib/config/app_theme.dart` to customize:
- Colors
- Typography
- Button styles
- Input styling
- Card styling

## Best Practices

1. **Always use Provider for state management**
2. **Keep screens simple and focused**
3. **Extract complex widgets into separate files**
4. **Use constants for repeated values**
5. **Add error handling for all operations**
6. **Use descriptive naming conventions**
7. **Follow the folder structure**
8. **Keep business logic separate from UI**

## Dependencies

Core dependencies included:
- `provider` - State management
- `firebase_core` - Firebase initialization
- `firebase_auth` - Authentication
- `cloud_firestore` - Database
- `firebase_messaging` - Push notifications
- `google_maps_flutter` - Maps integration
- `geolocator` - Location services
- `hive` - Local storage
- `connectivity_plus` - Network connectivity
- `http` & `dio` - HTTP requests
- And many more...

See `pubspec.yaml` for complete list.

## Next Steps

1. Complete Phase 2: Firebase Authentication
2. Implement user registration and login
3. Set up Firestore collections
4. Implement chat and messaging
5. Build SOS emergency system
6. Integrate Google Maps
7. Implement communication modes
8. Add offline functionality

## License

This project is proprietary and confidential.

## Support

For support, please contact the development team.

---

**Last Updated**: July 21, 2026  
**Project Status**: Phase 1 - Foundation Complete ✅
