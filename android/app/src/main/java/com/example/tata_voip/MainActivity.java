package com.example.tata_voip;

import android.os.Bundle;
import android.util.Log;

import com.example.tata_voip.lin.Auth;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.embedding.engine.FlutterEngine;

import org.linphone.core.Call;
import org.linphone.core.Core;
import org.linphone.core.CoreListenerStub;
import org.linphone.core.Factory;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.tata/voip";
    private static final String TAG = "LIN_SDK";

    private static Core linPhoneCore;
    private Call currentCall = null;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        Factory factory = Factory.instance();
        linPhoneCore = factory.createCore(null, null, this);

        Log.i(TAG, "SDK Initialized " + linPhoneCore);

        linPhoneCore.addListener(new CoreListenerStub() {
            @Override
            public void onCallStateChanged(@NonNull Core core, @NonNull Call call, Call.State state, @NonNull String message) {
                if (state == Call.State.IncomingReceived) {
                    call.accept();
                    Log.d(TAG, "Incoming call accepted");
                } else if (state == Call.State.Connected) {
                    currentCall = call;
                    Log.d(TAG, "Call connected" + currentCall + " " + message);
                } else if (state == Call.State.End) {
                    currentCall = null;
                    Log.d(TAG, "Call ended");
                } else {
                    Log.d(TAG, "Call state: " + state + ", message: " + message);
                }
            }
        });
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler((call, result) -> {
            switch (call.method) {
                case "loginLinSDK":
                    boolean isLoginSuccess = Auth.login(
                            linPhoneCore,
                            "0605405970002",
                            "$eWPQD!Ypy",
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
                    boolean isCallSuccess = Auth.makeCall(
                            linPhoneCore,
                            number,
                            "sip-bgn-int.ttsl.tel:49868"
                    );
                    if (isCallSuccess) {
                        result.success("Ringing ...");
                    } else {
                        result.error("CALL_ERROR", "Call failed", null);
                    }
                    break;

                default:
                    result.notImplemented();
                    break;
            }
        });
    }
}
