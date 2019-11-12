xcode:
	open ios/Runner.xcworkspace

built_value_build:
	flutter packages pub run build_runner build --delete-conflicting-outputs

built_value_watch:
	flutter packages pub run build_runner watch --delete-conflicting-outputs

prod_ios:
	flutter build ios -t lib/main_prod.dart --flavor prod

prod_android:
	flutter build apk -t lib/main_prod.dart --flavor prod

install_android_dev:
	flutter build apk -t lib/main_dev.dart --flavor dev && flutter install -d ce041714616c00130c

install_ios_dev:
	flutter build ios -t lib/main_dev.dart --flavor dev && flutter install -d aa61c6e8701a763b7aa199eea33bbc5bb708b039

install_android_prod:
	make prod_android && flutter install -d ce041714616c00130c

install_ios_prod:
	make prod_ios && flutter install -d aa61c6e8701a763b7aa199eea33bbc5bb708b039
