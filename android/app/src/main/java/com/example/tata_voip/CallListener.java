package com.example.tata_voip;

import org.linphone.core.Call;
import org.linphone.core.Core;
import org.linphone.core.CoreListenerStub;
import org.linphone.core.Reason;

import android.util.Log;

import androidx.annotation.NonNull;

import java.util.HashMap;

public class CallListener extends CoreListenerStub {
    private static final String TAG = "LIN_SDK";

    private static Call currentCall;

    public CallListener() {}

    @Override
    public void onCallStateChanged(@NonNull Core core, @NonNull Call call, Call.State state, @NonNull String message) {
        switch (state) {
            case Idle:
                Log.d(TAG, "Idle");
                break;
            case IncomingReceived:
                if (currentCall != null) {
                    call.terminate();
                }
                currentCall = call;
                String userName = currentCall.getRemoteAddress().getUsername();
                EventNotifier.notify("INCOMING_RECEIVED", userName);
                Log.d(TAG, "IncomingReceived");
                break;
            case PushIncomingReceived:
                Log.d(TAG, "PushIncomingReceived");
                break;
            case OutgoingInit:
                Log.d(TAG, "OutgoingInit");
                break;
            case OutgoingProgress:
                Log.d(TAG, "OutgoingProgress");
                break;
            case OutgoingRinging:
                EventNotifier.notify("OUTGOING_RINGING", true);
                Log.d(TAG, "OutgoingRinging");
                break;
            case OutgoingEarlyMedia:
                Log.d(TAG, "OutgoingEarlyMedia");
                break;
            case Connected:
                currentCall = call;
                EventNotifier.notify("CALL_CONNECTED", true);
                Log.d(TAG, "Connected");
                break;
            case StreamsRunning:
                EventNotifier.notify("STREAMS_RUNNING", true);
                Log.d(TAG, "StreamsRunning");
                break;
            case Pausing:
                Log.d(TAG, "Pausing");
                break;
            case Paused:
                Log.d(TAG, "Paused");
                break;
            case Resuming:
                Log.d(TAG, "Resuming");
                break;
            case Referred:
                Log.d(TAG, "Referred");
                break;
            case Error:
                Log.d(TAG, "Error");
                break;
            case End:
                EventNotifier.notify("CALL_ENDED", true);
                Log.d(TAG, "End");
                break;
            case PausedByRemote:
                Log.d(TAG, "PausedByRemote");
                break;
            case UpdatedByRemote:
                Log.d(TAG, "UpdatedByRemote");
                break;
            case IncomingEarlyMedia:
                Log.d(TAG, "IncomingEarlyMedia");
                break;
            case Updating:
                Log.d(TAG, "Updating");
                break;
            case Released:
                EventNotifier.notify("CALL_RELEASED", true);
                Log.d(TAG, "Released");
                break;
            case EarlyUpdatedByRemote:
                Log.d(TAG, "EarlyUpdatedByRemote");
                break;
            case EarlyUpdating:
                Log.d(TAG, "EarlyUpdating");
                break;
            default:
                Log.d(TAG, "Unknown state" + state);
                break;
        }
    }

    public static Call getCurrentCall() {
        return currentCall;
    }

    public static void setCurrentCall(Call call) {
        currentCall = call;
    }
}
