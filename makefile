xcode:
	open ios/Runner.xcworkspace

install:
	fvm flutter pub get

built_value_build:
	fvm flutter packages pub run build_runner build --delete-conflicting-outputs

built_value_watch:
	fvm flutter packages pub run build_runner watch --delete-conflicting-outputs

prod_ios:
	fvm flutter build ios -t lib/main_prod.dart --flavor prod

prod_android:
	fvm flutter build apk -t lib/main_prod.dart --flavor prod

install_android_dev:
	fvm flutter build apk -t lib/main_dev.dart --flavor dev && fvm flutter install -d ce041714616c00130c

install_ios_dev:
	fvm flutter build ios -t lib/main_dev.dart --flavor dev && fvm flutter install -d aa61c6e8701a763b7aa199eea33bbc5bb708b039

install_android_prod:
	make prod_android && fvm flutter install -d ce041714616c00130c

install_ios_prod:
	make prod_ios && fvm flutter install -d aa61c6e8701a763b7aa199eea33bbc5bb708b039
