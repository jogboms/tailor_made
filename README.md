<div align="center">
  <img src="./assets/images/logo.png" style="margin: auto;display: block;width: 22.5%" />
  <br />
  <h1>TailorMade</h1>
  <strong>Managing a Fashion designer's daily routine</strong>
  <br />
  <sub>Built with ❤︎ by <a href="https://twitter.com/jogboms">jogboms</a></sub>
  <br /><br />
  <a href='https://play.google.com/store/apps/details?id=io.github.jogboms.tailormade'><img alt='Get it on Google Play' src='./screenshots/google_play.png' height='36px'/></a>
  <br />

[![Format, Analyze and Test](https://github.com/jogboms/tailor_made/actions/workflows/main.yml/badge.svg?branch=master)](https://github.com/jogboms/tailor_made/actions/workflows/main.yml) [![codecov](https://codecov.io/gh/jogboms/tailor_made/branch/master/graph/badge.svg)](https://codecov.io/gh/jogboms/tailor_made)
</div>

---

TailorMade is what actually started out as an experiment with [Flutter](https://flutter.io/) and [Firebase Cloud Functions](https://github.com/flutter/plugins/tree/master/packages/cloud_functions) but instead turned out to be a valuable tool for managing a Fashion designer's daily routine. It is clean, easy on the eyes and overall has a very smooth feel. It also handles offline use cases with Firebase Cloud. Logo, Design & Concept by Me.

> For a full description of OSS used, see pubspec.yaml

## Getting Started

After cloning,

### FVM setup

Install `fvm` if not already installed.

```bash
dart pub global activate fvm
```

Install local `flutter` version.

```bash
fvm install
```

### Install, L10n & Riverpod code generation

```bash
fvm flutter pub get 
fvm flutter pub run build_runner build
```

## Running

There are three (3) available environments:
- `mock`: Demo mode with non-persistent data
- `dev`: Development mode connected to firebase dev instance
- `prod`: Production mode connected to firebase production instance

To run in `mock` mode,

```bash
fvm flutter run --flavor mock --dart-define=env.mode=mock
```

## UI Shots

<div style="text-align: center">
  <table>
    <tr>
      <td style="text-align: center">
        <img src="./screenshots/ss01.png" width="200" />
      </td>
      <td style="text-align: center">
        <img src="./screenshots/ss02.png" width="200" />
      </td>
      <td style="text-align: center">
        <img src="./screenshots/ss03.png" width="200" />
      </td>
      <td style="text-align: center">
        <img src="./screenshots/ss04.png" width="200" />
      </td>
      <td style="text-align: center">
        <img src="./screenshots/ss05.png" width="200" />
      </td>
    </tr>
    <tr>
      <td style="text-align: center">
        <img src="./screenshots/ss06.png" width="200" />
      </td>
      <td style="text-align: center">
        <img src="./screenshots/ss07.png" width="200" />
      </td>
      <td style="text-align: center">
        <img src="./screenshots/ss08.png" width="200" />
      </td>
      <td style="text-align: center">
        <img src="./screenshots/ss09.png" width="200" />
      </td>
      <td style="text-align: center">
        <img src="./screenshots/ss10.png" width="200" />
      </td>
    </tr>
    <tr>
      <td style="text-align: center">
        <img src="./screenshots/ss11.png" width="200" />
      </td>
      <td style="text-align: center">
        <img src="./screenshots/ss12.png" width="200" />
      </td>
      <td style="text-align: center">
        <img src="./screenshots/ss13.png" width="200" />
      </td>
      <td style="text-align: center">
        <img src="./screenshots/ss14.png" width="200" />
      </td>
      <td style="text-align: center">
        <img src="./screenshots/ss15.png" width="200" />
      </td>
    </tr>
    <tr>
      <td style="text-align: center">
        <img src="./screenshots/ss16.png" width="200" />
      </td>
      <td style="text-align: center">
        <img src="./screenshots/ss17.png" width="200" />
      </td>
      <td style="text-align: center">
        <img src="./screenshots/ss18.png" width="200" />
      </td>
      <td style="text-align: center">
        <img src="./screenshots/ss19.png" width="200" />
      </td>
      <td style="text-align: center">
        <img src="./screenshots/ss20.png" width="200" />
      </td>
    </tr>
    <tr>
      <td style="text-align: center">
        <img src="./screenshots/ss21.png" width="200" />
      </td>
      <td style="text-align: center">
        <img src="./screenshots/ss22.png" width="200" />
      </td>
    </tr>
  </table>
</div>

## License

MIT License
