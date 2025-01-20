# WeatherNow

WeatherNow is a SwiftUI-based iOS application that provides weather forecasts for cities around the world. The app fetches data from a weather API, displays weather conditions, and allows users to search for different locations.

## Accomplishments

### 🛠️ **Project Setup**
- Created a SwiftUI-based iOS project using `MVVM` architecture.
- Configured API integration using `WeatherAPI.com`.
- Implemented environment setup for production and UI testing.

### 🔍 **Search Functionality**
- Implemented a search bar to find city weather.
- Added accessibility identifiers for UI testing.
- Enhanced the search result card to include:
  - Dynamic temperature and condition display.
  - Accessibility support for automated testing.
  - Proper padding, layout adjustments, and animations.

### 🖥️ **User Interface Improvements**
- Updated UI layout to match Figma design specifications.
  - Aligned weather image above the city name.
  - Added a location icon next to the city name.
  - Adjusted font sizes and colors for consistency.
  - Implemented conditional spacing when no city is selected.
- Improved design responsiveness with adaptive layouts.
- Implemented animations for error messages (fade out after 2 seconds).

### 📦 **Data Persistence**
- Implemented local persistence using `UserDefaults` to store the last searched city.
- Implemented functions to:
  - Save the selected city.
  - Load the saved city upon app launch.
  - Clear saved city data when necessary.

### 🌐 **Networking and API Handling**
- Integrated `URLSession` for network calls with `async/await`.
- Added error handling for network failures and invalid city inputs.
- Implemented mock API service for UI testing.
- Successfully handled the `is_day` field to dynamically display day/night icons.

### 🧪 **Unit Testing**
Achieved **>90% code coverage** with comprehensive unit tests for:
1. **Weather Model Decoding**
   - Successfully decoded valid JSON responses.
   - Handled missing fields and unexpected JSON structures.
   - Validated extreme weather values.
   - Ensured correct temperature unit conversions (Celsius to Fahrenheit).

2. **WeatherViewModel Functionality**
   - Tested fetching weather success and failure cases.
   - Verified persistence mechanisms (`save`, `load`, `clear` operations).
   - Ensured accurate error message handling.

3. **UserDefaults Persistence**
   - Verified persistence and clearing of saved city data.
   - Ensured reliability through sequential test execution.

### 🧩 **UI Testing**
- Successfully set up `XCUITest` framework with UI tests to verify:
  - Search field input and result card display.
  - City selection persistence across app launches.
  - Error message visibility on invalid search.
  - Navigation to the weather detail screen.
- Used `accessibilityIdentifiers` to locate and assert UI elements reliably.

### 🛠️ **Mocking and Test Setup**
- Integrated a mock API service to bypass real API calls during testing.
- Implemented environment flag-based service switching for UI tests.
- Fixed issues with mock API detection using `ProcessInfo.environment`.
- Used dependency injection for testing flexibility.

### 🚀 **Build and CI Improvements**
- Resolved `Testing` module alias conflicts in the UI Test target.
- Cleaned up test dependencies and ensured smooth execution.
- Ensured a clean CI pipeline with test coverage reports.

## Next Steps
- Further refine the UI tests to cover more complex user interactions.
- Consider implementing snapshot tests for visual validation.
- Improve network request caching for better performance.
- Add localization support for multiple languages.


## New Features

### Temperature Unit Conversion

The app now supports automatic temperature unit conversion based on the device's locale settings. It dynamically displays temperatures in:

- **Celsius (°C)** if the device uses the metric system (e.g., Canada, Europe, Asia).
- **Fahrenheit (°F)** if the device uses the imperial system (e.g., United States).

#### How It Works:
- The app detects the device's locale using the `Locale.current.measurementSystem` API (introduced in iOS 16).
- Based on the detected locale, it displays the appropriate temperature format in the UI.
- The app fetches both Celsius and Fahrenheit values from the API response and selects the appropriate one dynamically.

#### Example Behavior:
| Device Locale         | Displayed Temperature |
|----------------------|----------------------|
| `en_US` (Imperial)    | 68°F                  |
| `en_GB` (Metric)      | 20°C                  |

#### How to Test:

1. **Unit Tests**
    - Run `WeatherNowTests` to verify correct temperature unit selection.
    - Check test cases for both `en_US` and `fr_FR` locales to ensure proper conversion.

2. **Manual Testing**
    - Change your device's region to the US (Settings > General > Language & Region).
    - Launch the app and verify temperature is displayed in Fahrenheit (°F).
    - Switch to a European region and check for Celsius (°C).

---

## How to Run the Project

1. Clone the repository:
   ```bash
   git clone https://github.com/yourrepo/WeatherNow.git
   cd WeatherNow
   ```

2. Open the project in Xcode:
   ```bash
   open WeatherNow.xcodeproj
   ```

## License

This project is licensed under the MIT License.
