package com.jonas.coronaalarm;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;

import com.google.android.material.textfield.TextInputEditText;

import java.util.Objects;

public class WelcomeActivity extends AppCompatActivity {

    TextInputEditText inputCode;
    Button submitCode;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_welcome);

        Objects.requireNonNull(getSupportActionBar()).hide();

        inputCode = findViewById(R.id.input_code);
        submitCode = findViewById(R.id.send_code_bt);
    }

    public void onClickSubmit(View view){

        if (!Objects.requireNonNull(inputCode.getText()).toString().equals("")){
            // POST CALL
            Toast.makeText(this, "Okay", Toast.LENGTH_SHORT).show();
            Intent myIntent = new Intent(WelcomeActivity.this, MainActivity.class);
            WelcomeActivity.this.startActivity(myIntent);
        }
    }
}
