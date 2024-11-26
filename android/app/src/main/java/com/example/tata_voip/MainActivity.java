package com.example.tata_voip;

import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.embedding.engine.FlutterEngine;

import org.linphone.core.Core;
import org.linphone.core.Factory;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.tata/voip";
    private static final String TAG = "LIN_SDK";

    private static Core linPhoneCore;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        Factory factory = Factory.instance();
        linPhoneCore = factory.createCore(null, null, this);

        Log.i(TAG, "SDK Initialized " + linPhoneCore);

        CallListener callListener = new CallListener();
        linPhoneCore.addListener(callListener);

        requestPermissions();
    }

    private void requestPermissions() {
        if (checkSelfPermission(android.Manifest.permission.RECORD_AUDIO) != android.content.pm.PackageManager.PERMISSION_GRANTED) {
            requestPermissions(new String[]{android.Manifest.permission.RECORD_AUDIO}, 1);
        }
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        MethodChannel methodChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL);
        EventNotifier.setChannel(methodChannel);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler((call, result) -> {
            switch (call.method) {
                case "loginLinSDK":
                    boolean isLoginSuccess = LinOperation.login(
                            linPhoneCore,
                            "0605405970004",
                            "fgabSjMxQv",
                            "sip-bgn-int.ttsl.tel:49868"
                    );
                    if (isLoginSuccess) {
                        result.success("Login successful");
                    } else {
                        result.error("LOGIN_ERROR", "Login failed", null);
                    }
                    break;

                case "makeCall":
                    String number = call.argument("number");
                    Log.d(TAG, "Making call to " + number);
                    boolean isCallSuccess = LinOperation.makeCall(
                            linPhoneCore,
                            number,
                            "sip-bgn-int.ttsl.tel:49868"
                    );
                    if (!isCallSuccess) {
                        result.error("CALL_ERROR", "Call failed", null);
                    }
                    break;

                case "toggleSpeaker":
                    boolean speakerStatus = Boolean.TRUE.equals(call.argument("isSpeakerOn"));
                    boolean isSpeakerOn = LinOperation.toggleSpeaker(linPhoneCore, speakerStatus);
                    result.success(isSpeakerOn);
                    break;

                case "toggleMute":
                    boolean muteStatus = Boolean.TRUE.equals(call.argument("isMute"));
                    boolean isMuteOn = LinOperation.toggleMute(linPhoneCore, muteStatus);
                    result.success(isMuteOn);
                    break;

                case "endCall":
                    int isCallEnded = LinOperation.hangUp(linPhoneCore);
                    if (isCallEnded != 0) {
                        result.error("HANGUP_ERROR", "Failed to end call", null);
                    }
                    break;

                default:
                    result.notImplemented();
                    break;
            }
        });
    }
}
