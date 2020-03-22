package com.jonas.coronaalarm;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;

import com.androidnetworking.AndroidNetworking;
import com.androidnetworking.common.Priority;
import com.androidnetworking.error.ANError;
import com.androidnetworking.interfaces.JSONObjectRequestListener;
import com.androidnetworking.interfaces.StringRequestListener;
import com.google.android.material.textfield.TextInputEditText;

import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

import javax.net.ssl.HttpsURLConnection;

import okhttp3.OkHttpClient;

public class WelcomeActivity extends AppCompatActivity {

    SharedPreferences prefs = null;
    TextInputEditText inputCode;
    Button submitCode;

    Boolean demo = false;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_welcome);

        Objects.requireNonNull(getSupportActionBar()).hide();

        inputCode = findViewById(R.id.input_code);
        submitCode = findViewById(R.id.send_code_bt);

        prefs = getSharedPreferences("com.jonas.coronaalarm", MODE_PRIVATE);

        try {
            AndroidNetworking.initialize(getApplicationContext());
            OkHttpClient okHttpClient = new OkHttpClient()
                    .newBuilder()
                    .build();
            AndroidNetworking.initialize(getApplicationContext(), okHttpClient);
        } catch (Exception e) {
            Toast.makeText(this, "Kein Internet? " + e.getMessage(), Toast.LENGTH_SHORT).show();
        }
    }

    public void onClickSubmit(View view){

        if (!Objects.requireNonNull(inputCode.getText()).toString().equals("")){

            if (demo) {
                String text = Objects.requireNonNull(inputCode.getText()).toString();

                if (text.equals("617254")){
                    prefs.edit().putBoolean("codeOkay", true).apply();
                    Toast.makeText(WelcomeActivity.this, "Okay", Toast.LENGTH_SHORT).show();
                    Intent myIntent = new Intent(WelcomeActivity.this, MainActivity.class);
                    WelcomeActivity.this.startActivity(myIntent);
                } else {
                    Toast.makeText(WelcomeActivity.this, "Dieser Access Code ist nicht gültig", Toast.LENGTH_SHORT).show();
                }

            } else {
                String serverIP = "192.168.178.64:8080";
                String code = Objects.requireNonNull(inputCode.getText()).toString();

                AndroidNetworking.post("http://" + serverIP + "/access_request")
                        .addBodyParameter("access_code", code)
                        .setPriority(Priority.HIGH)
                        .build()
                        .getAsString(new StringRequestListener() {
                            @Override
                            public void onResponse(String response) {
                                prefs.edit().putBoolean("codeOkay", true).apply();

                                Toast.makeText(WelcomeActivity.this, "Okay", Toast.LENGTH_SHORT).show();
                                Intent myIntent = new Intent(WelcomeActivity.this, MainActivity.class);
                                WelcomeActivity.this.startActivity(myIntent);
                            }
                            @Override
                            public void onError(ANError error) {
                                Toast.makeText(WelcomeActivity.this, "Dieser Access Code ist nicht gültig", Toast.LENGTH_SHORT).show();
                            }
                        });
            }
        }
    }
}
