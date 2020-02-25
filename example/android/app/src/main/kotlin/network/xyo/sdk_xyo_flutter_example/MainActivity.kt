package network.xyo.sdk_xyo_flutter_example

import android.Manifest
import android.app.AlertDialog
import android.content.pm.PackageManager
import android.os.Bundle
import android.util.SparseIntArray
import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

class MainActivity: FlutterActivity() {
      private var permissionResult = SparseIntArray()

  override fun onRequestPermissionsResult(
          requestCode: Int,
          permissions: Array<out String>,
          grantResults: IntArray
  ) {
    super.onRequestPermissionsResult(requestCode, permissions, grantResults)
    permissionResult.put(requestCode, grantResults[0])
  }

  private suspend fun requestPermissionAsync(permission: String, message: String? = null): Boolean {
    val requestCodeHash = permission.hashCode().and(0xffff)
    if (ContextCompat.checkSelfPermission(this@MainActivity,
                    permission)
            != PackageManager.PERMISSION_GRANTED) {

      if (ActivityCompat.shouldShowRequestPermissionRationale(this@MainActivity,
                      permission)) {
        AlertDialog.Builder(this@MainActivity)
                .setTitle("Permission Needed")
                .setMessage(message ?: "We need $permission to run")
                .create()
      } else {
        // No explanation needed, we can request the permission.
        ActivityCompat.requestPermissions(this@MainActivity,
                arrayOf(permission),
                requestCodeHash)
      }
      while(permissionResult.get(requestCodeHash, -1) == -1) {
        delay(100)
      }
      return permissionResult[requestCodeHash] == PackageManager.PERMISSION_GRANTED
    } else {
      return true
    }
  }

  suspend fun requestPermissions(): Boolean {
    if (!requestPermissionAsync(Manifest.permission.ACCESS_FINE_LOCATION)) {
      return false
    }
    if (!requestPermissionAsync(Manifest.permission.BLUETOOTH, "Bluetooth is required for XYO to communicate with nearby devices.")) {
      return false
    }
    if (!requestPermissionAsync(Manifest.permission.BLUETOOTH_ADMIN, "Bluetooth is required for XYO to communicate with nearby devices.")) {
      return false
    }
    return true
  }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GlobalScope.launch {
            requestPermissions()
        }
    }
}
