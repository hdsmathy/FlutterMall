package com.olj.olamall_app

import android.content.pm.PackageManager
import io.flutter.app.FlutterApplication
import android.content.pm.PackageManager.GET_SIGNATURES
import android.util.Base64
import android.util.Log
import androidx.core.content.ContextCompat.getSystemService
import java.security.MessageDigest
import java.security.NoSuchAlgorithmException


class MainApp : FlutterApplication(){
    override fun onCreate() {
        super.onCreate()
        getKey()
    }

    fun getKey(){
        try {
            var i = 0
            val info = packageManager.getPackageInfo(packageName, PackageManager.GET_SIGNATURES)
            for (signature in info.signatures) {
                i++
                val md = MessageDigest.getInstance("SHA")
                md.update(signature.toByteArray())
                val KeyHash = Base64.encodeToString(md.digest(), Base64.DEFAULT)
                //KeyHash 就是你要的，不用改任何代码  复制粘贴 ;
                Log.e("KeyHash", "KeyHash=$KeyHash")
            }
        } catch (e: PackageManager.NameNotFoundException) {

        } catch (e: NoSuchAlgorithmException) {

        }

    }
}