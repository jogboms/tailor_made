xcode:
	open ios/Runner.xcworkspace

prod_ios:
	flutter build ios -t lib/main_prod.dart --flavor prod

prod_android:
	flutter build apk -t lib/main_prod.dart --flavor prod

install_dev:
	flutter build apk -t lib/main_dev.dart --flavor dev && flutter install -d ce041714616c00130c

install_prod:
	make prod_android && flutter install -d ce041714616c00130c
