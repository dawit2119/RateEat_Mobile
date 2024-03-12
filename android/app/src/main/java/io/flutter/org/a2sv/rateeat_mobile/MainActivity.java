package org.a2sv.rateeat_mobile;

import io.flutter.embedding.android.FlutterActivity;
import android.content.Intent;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        setIntent(intent); // Pass the updated intent to Flutter
    }
}
