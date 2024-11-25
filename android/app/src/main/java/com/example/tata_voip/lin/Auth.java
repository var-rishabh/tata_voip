package com.example.tata_voip.lin;

import android.content.Context;
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

public class Auth extends CoreListenerStub {
    private static final String TAG = "LIN_SDK";

//    public static Core initLinSDK(Context context) {
//        try {
//            Factory factory = Factory.instance();
//            return factory.createCore(null, null, context);
//        } catch (Exception e) {
//            Log.e(TAG, "Failed to initialize Linphone SDK", e);
//            return null;
//        }
//    }

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
}
