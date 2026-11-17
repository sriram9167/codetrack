# CodeTrack Flutter

A Flutter version of the CodeTrack college coding performance dashboard.
This build is a self-contained demo: sample student data is bundled with the
app and no backend or network connection is required.

## Screens

- **Login** — admin sign-in with demo credentials
- **Dashboard** — student count, average score, at-risk count, synced-today
  stats, top performers and students needing attention
- **Students** — searchable directory, add-student dialog, per-student cards
- **Student profile** — platform scores for LeetCode, Codeforces and CodeChef,
  weighted score breakdown, coaching insight and profile sync
- **Leaderboard** — podium plus full ranking by weighted overall score
- **Analytics** — average score by branch, platform averages and at-risk list

## Scoring model

`overall = 0.35·LeetCode + 0.30·Codeforces + 0.15·CodeChef + 0.10·Consistency + 0.10·ProblemSolving`

Each component is scored out of 10.

## Demo credentials

```
Email:    admin@codetrack.local
Password: Admin@12345
```

## Run

```powershell
flutter pub get
flutter run -d chrome
```

Android:

```powershell
flutter run -d <device-id>
```

## Verify

```powershell
flutter analyze
flutter test
flutter build web
```

## Project structure

```
lib/
  data/       sample student data
  models/     Student and PlatformStat models
  screens/    login, dashboard, students, profile, leaderboard, analytics
  state/      AppState (auth, students, sync, analytics) + AppScope
  widgets/    shared cards, score bars, avatars and pills
  theme.dart  dark Material 3 theme
test/         model, state and widget tests
```
