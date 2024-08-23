package com.domtripcode.plugins.video;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.provider.MediaStore;

import com.getcapacitor.annotation.CapacitorPlugin;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.JSObject;

@CapacitorPlugin(name = "VideoRecorder")
public class VideoRecorder extends Plugin {

    static final int REQUEST_VIDEO_CAPTURE = 1;
    private PluginCall call;

    @PluginMethod
    public void recordVideo(PluginCall call) {
        this.call = call;
        Intent takeVideoIntent = new Intent(MediaStore.ACTION_VIDEO_CAPTURE);
        if (takeVideoIntent.resolveActivity(getContext().getPackageManager()) != null) {
            startActivityForResult(call, takeVideoIntent, REQUEST_VIDEO_CAPTURE);
        } else {
            call.reject("Unable to open camera");
        }
    }

    @Override
    protected void handleOnActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == REQUEST_VIDEO_CAPTURE && resultCode == Activity.RESULT_OK) {
            Uri videoUri = data.getData();
            if (videoUri != null) {
                call.resolve(new JSObject().put("videoUri", videoUri.toString()));
            } else {
                call.reject("Video URI is null");
            }
        }
    }
}
