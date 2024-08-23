package com.yourpackage.videorecorderplugin;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.provider.MediaStore;
import android.util.Base64;

import com.getcapacitor.annotation.CapacitorPlugin;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.JSObject;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;

@CapacitorPlugin(name = "VideoRecorder")
public class VideoRecorder extends Plugin {

    static final int REQUEST_VIDEO_CAPTURE = 1;
    private PluginCall ongoingCall;

    @PluginMethod
    public void recordVideo(PluginCall call) {
        if (ongoingCall != null) {
            call.reject("Another video recording is already in progress.");
            return;
        }

        this.ongoingCall = call;

        Intent takeVideoIntent = new Intent(MediaStore.ACTION_VIDEO_CAPTURE);
        if (takeVideoIntent.resolveActivity(getContext().getPackageManager()) != null) {
            startActivityForResult(call, takeVideoIntent, REQUEST_VIDEO_CAPTURE);
        } else {
            ongoingCall = null;
            call.reject("Unable to open camera");
        }
    }

    @Override
    protected void handleOnActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == REQUEST_VIDEO_CAPTURE) {
            if (resultCode == Activity.RESULT_OK && data != null) {
                Uri videoUri = data.getData();
                if (videoUri != null) {
                    try {
                        // Convert URI to Base64
                        String base64Video = convertUriToBase64(videoUri);
                        JSObject ret = new JSObject();
                        ret.put("videoUri", videoUri.toString());
                        ret.put("base64Video", base64Video);
                        ongoingCall.resolve(ret);
                    } catch (IOException e) {
                        ongoingCall.reject("Failed to convert video to Base64", e);
                    }
                } else {
                    ongoingCall.reject("Video URI is null");
                }
            } else {
                ongoingCall.reject("Video recording failed or was cancelled");
            }
        }

        ongoingCall = null; // Clear the ongoing call after handling the result
    }

    private String convertUriToBase64(Uri videoUri) throws IOException {
        InputStream inputStream = getContext().getContentResolver().openInputStream(videoUri);
        byte[] bytes = getBytesFromInputStream(inputStream);
        return Base64.encodeToString(bytes, Base64.DEFAULT);
    }

    private byte[] getBytesFromInputStream(InputStream inputStream) throws IOException {
        ByteArrayOutputStream byteBuffer = new ByteArrayOutputStream();
        int bufferSize = 1024;
        byte[] buffer = new byte[bufferSize];

        int len;
        while ((len = inputStream.read(buffer)) != -1) {
            byteBuffer.write(buffer, 0, len);
        }

        return byteBuffer.toByteArray();
    }
}
