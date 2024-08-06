# MiniCAB DRIVER App

## Overview

MiniCAB Driver App is a Flutter-based mobile application designed for drivers to manage their rides, view ride details, navigate to destinations, and track earnings. This app provides an intuitive interface for drivers to handle their daily tasks efficiently.

## Features

- **Ride Management**: Accept or reject ride requests.
- **Navigation**: Integrated with Google Maps for easy navigation.
- **Earnings Tracking**: View daily, weekly, and monthly earnings.
- **User Profile**: Manage driver profile and vehicle details.
- **Notifications**: Receive notifications for new ride requests and updates.
- **Support**: In-app support for driver queries and issues.

## Installation

To get started with the MiniCAB Driver App1, follow these steps:

1. **Clone the repository:**

   ```bash
   git clone https://github.com/prenerostudio/minicab_driverapp/
   cd MiniCAB-Driver-App
   ```

2. **Install dependencies:**

   Make sure you have Flutter installed. Then, run the following command:

   ```bash
   flutter pub get
   ```

3. **Run the app:**

   Connect a device or start an emulator, then run:

   ```bash
   flutter run
   ```

## Dependencies

The project uses the following main dependencies:

- `flutter`
- `provider`
- `http`
- `google_maps_flutter`
- `firebase_core`
- `firebase_auth`
- `cloud_firestore`

For the complete list of dependencies, refer to the `pubspec.yaml` file.

## Project Structure

Here's a brief overview of the project structure:

```
MiniCAB-Driver-App/
├── android/
├── ios/
├── Keys/
├── lib/
│   ├── models/
│   ├── Acount Statements
│   ├── All Docoments
│   ├── BidHistory
│   ├── Data
│   ├── JobHistoryDetails
│   ├── Model
│   ├── NameFullScreen
│   ├── NationalInsuranceNumber
│   ├── ProofofAddressTwo
│   ├── SplashScreen
│   ├── VehicleInsurance
│   ├── account_Details
│   ├── add_account
│   ├── add_card
│   ├── add_vehicle
│   ├── auth
│   ├── backend/firebase
│   ├── bid_details
│   ├── bids
│   ├── bids_history
│   ├── changepassword
│   ├── components
│   ├── dashboard
│   ├── documents
│   ├── edit_profile
│   ├── flutter_flow
│   ├── home
│   ├── invoiecs
│   ├── jobshistory
│   ├── login
│   ├── myprofile
│   ├── on_way
│   ├── otp 2
│   ├── otp
│   ├── payment_entery
│   ├── pob
│   ├── signup
│   ├── upcomming
│   ├── welcome
│   ├── zones
│   └── index.dart
│   └── main.dart
├── test/
├── pubspec.yaml
└── README.md
```

- `models/`: Data models used in the app.
- `providers/`: State management using Provider.
- `screens/`: UI screens.
- `services/`: Services like API calls, Firebase interactions, etc.
- `utils/`: Utility classes and functions.
- `main.dart`: Entry point of the application.

## Contributing

We welcome contributions! If you'd like to contribute, please follow these steps:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/YourFeature`).
3. Make your changes.
4. Commit your changes (`git commit -m 'Add some feature'`).
5. Push to the branch (`git push origin feature/YourFeature`).
6. Create a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

## Contact

If you have any questions or suggestions, feel free to reach out to us at [hello@prenero.com](mailto:hello@prenero.com).