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
      @Override public void onClick(View view) {
        startActivity(FlutterActivity.createDefaultIntent(MainActivity.this));
      }
    });
  }
}