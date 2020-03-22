package com.jonas.coronaalarm;

import androidx.annotation.ColorInt;
import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.widget.ImageView;
import android.widget.Toast;

import com.bumptech.glide.Glide;

import java.util.Objects;

public class MainActivity extends AppCompatActivity {

    SharedPreferences prefs = null;

    private static final String warningMessage = "*Automatisierte Warnnachricht* \n"+
            "\n"+
            "Hallo, ich wurde positiv auf das COVID-19-Virus getestet. Falls wir beide innerhalb der letzten zwei Wochen engen Kontakt zueinander hatten, bist auch du verpflichtet, dich in eine 14-tägige Quarantäne zu begeben (siehe www.rki.de/SharedDocs/FAQ/NCOV2019/FAQ_Liste.html). Als enger Kontakt zählen Anhusten, Anniesen oder auch schon ein mehrminütiges Gespräch.\n"+
            "Sollten wir uns ausschließlich im gleichen Raum befunden haben, bist du zu einer Quarantäne nicht verpflichtet. [Stand 17.03.2020]\n"+
            "\n"+
            "Bitte achte in den nächsten 14 Tagen besonders auf mögliche Symtome wie Fieber, Husten und Kurzatmigkeit. Auch Durchfall und Kopfschmerzen können ein Indikator sein. Bitte halte dich in diesem Zeitraum besonders an die Abstandsregeln und verkehre mit so wenigen Menschen wie möglich, um eine Weitergabe zu verhindern. Solltest du Krankheitssymtome bemerken, gehe bitte nicht zum Arzt sondern melde dich telefonisch an. Sollte dein Arzt nicht zu erreichen sein, hilft der ärztliche Bereitschaftsdienst 116117 weiter. \n"+
            "\n"+
            "_Zusätzliche Hinweise des lokalen Testinstituts:_\n"+
            "Die Teststation im darmstädter Klinikum wird ab nächster Woche nur noch bis 13:00 Uhr geöffnet haben, da es sonst zu Personalengpässen in der Pflege kommen kann (weitere Informationen unter _linkToKlinikumDarmstadt_).\n"+
            "\n"+
            "\n"+
            "*Diese Nachricht wurde von “CallMyContacts - Corona Warnnachricht” verschickt*\n";

    ImageView imageButton;
    Window window;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        prefs = getSharedPreferences("com.jonas.coronaalarm", MODE_PRIVATE);

        if (prefs.getBoolean("firstrun", true)) {
            prefs.edit().putBoolean("firstrun", false).apply();

            Intent myIntent = new Intent(MainActivity.this, WelcomeActivity.class);
            MainActivity.this.startActivity(myIntent);
        } 

        setup();
    }

    public void setup(){
        imageButton = findViewById(R.id.imageButton);
        window = getWindow();

        Objects.requireNonNull(getSupportActionBar()).hide();
        Glide.with(this)
                .load(R.drawable.corona)
                .into(imageButton);
    }

    public void onClickWhatsApp(View view) {

        PackageManager pm=getPackageManager();
        try {
            Intent waIntent = new Intent(Intent.ACTION_SEND);
            waIntent.setType("text/plain");

            PackageInfo info = pm.getPackageInfo("com.whatsapp", PackageManager.GET_META_DATA);
            waIntent.setPackage("com.whatsapp");

            waIntent.putExtra(Intent.EXTRA_TEXT, warningMessage);
            startActivity(Intent.createChooser(waIntent, "Share with"));

        } catch (PackageManager.NameNotFoundException e) {
            Toast.makeText(this, "WhatsApp not Installed", Toast.LENGTH_SHORT)
                    .show();
        }

    }
}
