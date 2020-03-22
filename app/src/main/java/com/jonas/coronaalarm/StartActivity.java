package com.jonas.coronaalarm;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.widget.Button;

import com.google.android.material.textfield.TextInputEditText;

import java.util.Objects;

public class StartActivity extends AppCompatActivity {

    SharedPreferences prefs = null;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_start);
        Objects.requireNonNull(getSupportActionBar()).hide();

        prefs = getSharedPreferences("com.jonas.coronaalarm", MODE_PRIVATE);

        if (prefs.getBoolean("firstrun", true)) {
            prefs.edit().putBoolean("firstrun", false).apply();

            Intent myIntent = new Intent(StartActivity.this, WelcomeActivity.class);
            StartActivity.this.startActivity(myIntent);
        } else {
            Intent myIntent = new Intent(StartActivity.this, MainActivity.class);
            StartActivity.this.startActivity(myIntent);
        }
    }
}
