package com.example.tata_voip;

import android.util.Log;

import org.linphone.core.Account;
import org.linphone.core.AccountParams;
import org.linphone.core.Address;
import org.linphone.core.AuthInfo;
import org.linphone.core.CallParams;
import org.linphone.core.Core;
import org.linphone.core.CoreListenerStub;
import org.linphone.core.Factory;
import org.linphone.core.MediaEncryption;
import org.linphone.core.TransportType;

import java.util.Objects;

public class LinOperation extends CoreListenerStub {
    private static final String TAG = "LIN_SDK";

    public static boolean login(Core linPhoneCore, String userName, String password, String domain) {
        try {
            TransportType transportType = TransportType.Tcp;
            AuthInfo authInfo = Factory.instance().createAuthInfo(
                    userName,
                    null,
                    password,
                    null, null,
                    domain,
                    null
            );
            linPhoneCore.addAuthInfo(authInfo);
            AccountParams accountParams = linPhoneCore.createAccountParams();

            Address identity = Factory.instance().createAddress("sip:" + userName + "@" + domain);
            accountParams.setIdentityAddress(identity);

            Address serverAddress = Factory.instance().createAddress("sip:" + domain);
            if (serverAddress != null) {
                serverAddress.setTransport(transportType);
                accountParams.setServerAddress(serverAddress);
            }
            accountParams.setRegisterEnabled(true);

            Account account = linPhoneCore.createAccount(accountParams);
            linPhoneCore.addAccount(account);
            linPhoneCore.setDefaultAccount(account);

            linPhoneCore.start();
            return true;
        } catch (Exception e) {
            Log.e(TAG, "Failed to login", e);
            return false;
        }
    }

    public static boolean makeCall(Core linPhoneCore, String number, String domain) {
        try {
            Address remoteAddress = Factory.instance().createAddress("sip:" + number + "@" + domain);
            if (remoteAddress == null) return false;

            CallParams params = linPhoneCore.createCallParams(null);
            if (params == null) return false;
            params.setMediaEncryption(MediaEncryption.None);

            linPhoneCore.inviteAddressWithParams(remoteAddress, params);
            return true;
        } catch (Exception e) {
            Log.e(TAG, "Failed to make call", e);
            return false;
        }
    }

    public static boolean toggleSpeaker(Core linPhoneCore, boolean speakerStatus) {
        try {
            Log.d(TAG, "Toggling speaker" + Objects.requireNonNull(linPhoneCore.getCurrentCall()).getSpeakerMuted());
            linPhoneCore.getCurrentCall().setSpeakerMuted(speakerStatus);
            return linPhoneCore.getCurrentCall().getSpeakerMuted();
        } catch (Exception e) {
            Log.e(TAG, "Failed to toggle speaker", e);
            return false;
        }
    }

    public static boolean toggleMute(Core linPhoneCore, boolean muteStatus) {
        try {
            linPhoneCore.setMicEnabled(!muteStatus);
            return linPhoneCore.isMicEnabled();
        } catch (Exception e) {
            Log.e(TAG, "Failed to toggle mute", e);
            return false;
        }
    }

    public static int hangUp(Core linPhoneCore) {
        try {
            return linPhoneCore.terminateAllCalls();
        } catch (Exception e) {
            Log.e(TAG, "Failed to hang up", e);
            return -1;
        }
    }
}
