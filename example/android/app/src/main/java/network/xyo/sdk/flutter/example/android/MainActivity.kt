package network.xyo.sdk.flutter.example.android

import android.Manifest
import android.app.AlertDialog
import android.content.pm.PackageManager
import android.os.Bundle
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {

  val MY_PERMISSIONS_REQUEST_BLUETOOTH = 1
  val MY_PERMISSIONS_REQUEST_LOCATION = 2

  fun checkBluetoothPermission() {
    if ((ContextCompat.checkSelfPermission(this,
            Manifest.permission.BLUETOOTH)
            != PackageManager.PERMISSION_GRANTED) || (ContextCompat.checkSelfPermission(this,
            Manifest.permission.BLUETOOTH_ADMIN)
            != PackageManager.PERMISSION_GRANTED)) {

      if (ActivityCompat.shouldShowRequestPermissionRationale(this,
              Manifest.permission.BLUETOOTH)) {
        val alert = AlertDialog.Builder(this)
        alert.setTitle("Bluetooth Permission")
        alert.setMessage("Bluetooth is required for XYO to communicate with nearby devices.")
        alert.setPositiveButton("Ok"){dialog, which -> }
        alert.show()

      } else {
        ActivityCompat.requestPermissions(this,
                arrayOf(Manifest.permission.BLUETOOTH, Manifest.permission.BLUETOOTH_ADMIN),
                MY_PERMISSIONS_REQUEST_BLUETOOTH)
      }
    } else {
      // Permission has already been granted
    }
  }

  fun checkLocationPermission() {
    if ((ContextCompat.checkSelfPermission(this,
                    Manifest.permission.ACCESS_FINE_LOCATION)
                    != PackageManager.PERMISSION_GRANTED)) {

      if (ActivityCompat.shouldShowRequestPermissionRationale(this,
                      Manifest.permission.ACCESS_FINE_LOCATION)) {
        val alert = AlertDialog.Builder(this)
        alert.setTitle("Location Permission")
        alert.setMessage("Location is required for XYO to communicate with nearby devices.")
        alert.setPositiveButton("Ok"){dialog, which -> }
        alert.show()

      } else {
        ActivityCompat.requestPermissions(this,
                arrayOf(Manifest.permission.ACCESS_FINE_LOCATION),
                MY_PERMISSIONS_REQUEST_LOCATION)
      }
    } else {
      // Permission has already been granted
    }
  }

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)
    checkBluetoothPermission()
    checkLocationPermission()
  }
}
