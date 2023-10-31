package com.meijian.build_flutter_android;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.view.View;

import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        findViewById(R.id.go_flutter).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(FlutterActivity.createDefaultIntent(MainActivity.this));
            }
        });
        findViewById(R.id.go_flutter_second).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(FlutterActivity.withNewEngine().initialRoute("/my_route").build(MainActivity.this));
                //startActivity(FlutterActivity.withCachedEngine("").build(MainActivity.this));
            }
        });
        findViewById(R.id.go_flutter_second_cache).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(FlutterActivity.withCachedEngine("my_engine_id").build(MainActivity.this));

            }
        });
    }
}