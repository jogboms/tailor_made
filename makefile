xcode:
	open ios/Runner.xcworkspace

install:
	fvm flutter pub get

ci:
	make format && make analyze && make test_coverage

format:
	fvm dart format --set-exit-if-changed -l 120 lib

analyze:
	fvm flutter analyze lib

test_coverage:
	fvm flutter test --no-pub --coverage --test-randomize-ordering-seed random

clean_coverage:
	lcov --remove coverage/lcov.info 'lib/generated/*' 'lib/**/*_mock_impl.dart' 'lib/presentation/theme/*' 'lib/presentation/constants/*' -o coverage/lcov.info

build_coverage:
	make test_coverage && make clean_coverage && genhtml -o coverage coverage/lcov.info

open_coverage:
	make build_coverage && open coverage/index.html

build_runner_build:
	fvm flutter packages pub run build_runner build --delete-conflicting-outputs

build_runner_watch:
	fvm flutter packages pub run build_runner watch --delete-conflicting-outputs

# iOS
mock_ios:
	fvm flutter build ios --flavor mock --dart-define=env.mode=mock

dev_ios:
	fvm flutter build ios --flavor dev --dart-define=env.mode=dev

prod_ios:
	fvm flutter build ios --flavor prod --dart-define=env.mode=prod

# Android
mock_android:
	fvm flutter build apk --flavor mock --dart-define=env.mode=mock

dev_android:
	fvm flutter build apk --flavor dev --dart-define=env.mode=dev

prod_android:
	fvm flutter build apk --flavor prod --dart-define=env.mode=prod

prod_android_bundle:
	fvm flutter build appbundle --flavor prod --dart-define=env.mode=prod

# Web
mock_web:
	fvm flutter build web --release --dart-define=env.mode=mock

serve_web:
	python3 -m http.server 8000 -d ./build/web/
