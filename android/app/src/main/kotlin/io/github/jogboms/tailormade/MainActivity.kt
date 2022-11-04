package io.github.jogboms.tailormade

import android.os.Build
import android.os.Bundle
import android.view.WindowInsets.Type.navigationBars
import android.view.WindowInsets.Type.statusBars
import android.view.WindowManager.LayoutParams.FLAG_FULLSCREEN
import io.flutter.embedding.android.FlutterActivity


class MainActivity : FlutterActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
      window.insetsController?.hide(statusBars() or navigationBars())
    } else {
      window.statusBarColor = 0x00000000
    }
  }

  override fun onFlutterUiDisplayed() {
    super.onFlutterUiDisplayed()

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
      window.insetsController?.show(statusBars() or navigationBars())
    } else {
      window.clearFlags(FLAG_FULLSCREEN)
    }
  }
}
