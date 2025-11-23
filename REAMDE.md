# Cards App

A Flutter app that displays paginated cards from an API. Cards have types (**good**, **bad**, **unknown**) and priorities (1–10). `unknown` is treated as **good** in the UI.

A promo card appears after every 3rd card. It is static in the UI unless provided dynamically by the API.

## Features
- **Pagination:** 5 cards per page
- **Card type handling:** `unknown` → `good`
- **Promo card insertion:** automatically added after every 3rd card
- **Local updates:** stored using SharedPreferences
- **Data refresh:** resets to page 1
- **Networking:** API requests via Dio
- **State management:** Provider
- **Environment config:** flutter_dotenv

## Packages
- `provider: ^6.1.5+1`
- `dio: ^5.9.0`
- `shared_preferences: ^2.5.3`
- `flutter_dotenv: ^6.0.0`

## API Response Example
```json

  [
    {
      "id": "card_021",
      "type": "unknown",
      "priority": 9,
      "data": {
        "title": "Unknown Power",
        "description": "A mysterious force with big potential."
      }
    },
    {
      "id": "card_004",
      "type": "good",
      "priority": 10,
      "data": {
        "title": "High Impact Benefit",
        "description": "A very strong positive card."
      }
    }, 
  ],

```

## Behavior
- Displays cards in the order returned by the API (priority handled backend-side)
- Inserts a promo card after every 3rd card
- Local edits override API data until refreshed
- Refresh clears local overrides and loads page 1

## Run the app
```bash
flutter pub get
flutter run
```

If you want a shorter or more developer-oriented version, just let me know!

