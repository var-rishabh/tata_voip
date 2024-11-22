package com.example.tata_voip;

import io.flutter.plugin.common.MethodChannel;

public class EventNotifier {
    private static MethodChannel channel;

    public static void setChannel(MethodChannel channel) {
        EventNotifier.channel = channel;
    }

    public static void notify(String event, Object data) {
        if (channel != null) {
            channel.invokeMethod(event, data);
        }
    }
}