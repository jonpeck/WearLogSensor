package com.example.jonpeck.logsensor;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.hardware.Sensor;
import android.os.Bundle;
import android.os.Handler;
import android.support.wearable.view.WatchViewStub;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

public class MainActivity extends Activity implements LoggingStatusReceiver.Receiver {

    private TextView mStatusTextView;
    private TextView mOutputTextView;
    private Button mButton;
    private boolean mIsLogging;
    private LoggingStatusReceiver mReceiver;
    private Intent mAccelerometer;
    private Intent mMagneticField;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        mIsLogging = false;

        final WatchViewStub stub = (WatchViewStub) findViewById(R.id.watch_view_stub);
        stub.setOnLayoutInflatedListener(new WatchViewStub.OnLayoutInflatedListener() {
            @Override
            public void onLayoutInflated(WatchViewStub stub) {
                mStatusTextView = (TextView) stub.findViewById(R.id.statusText);
                mOutputTextView = (TextView) stub.findViewById(R.id.outputText);
                mButton = (Button) stub.findViewById(R.id.button);
            }
        });
    }

    public void toggleLogging(View view)
    {
        mReceiver = new LoggingStatusReceiver(new Handler());
        mReceiver.setReceiver(this);



        if (mIsLogging) {
            if (mAccelerometer != null) {
                mAccelerometer.putExtra("loggingEnabled", false);
                mMagneticField.putExtra("loggingEnabled", false);
                //stopService(mAccelerometer);
                stopService(mMagneticField);
                Log.i("toggleLogging()","STOPPING!!!!");
            } else {
                Log.i("toggleLogging()","No service to stop");
            }
        } else
        {
            mAccelerometer = new Intent(this, LogSensorToCsv.class);
            mAccelerometer.putExtra("loggingEnabled", true);
            mAccelerometer.putExtra("receiver", mReceiver);
            mAccelerometer.putExtra("sensor", Sensor.TYPE_ACCELEROMETER);

            mMagneticField = new Intent(this, LogSensorToCsv.class);
            mMagneticField.putExtra("loggingEnabled", true);
            mMagneticField.putExtra("receiver", mReceiver);
            mMagneticField.putExtra("sensor", Sensor.TYPE_MAGNETIC_FIELD);

            //startService(mAccelerometer);
            startService(mMagneticField);
        }



    }

    @Override
    public void onReceiveResult(int resultCode,Bundle resultData)
    {
        switch (resultCode) {
            case LogSensorToCsv.STATUS_RUNNING:
                mIsLogging = true;
                mStatusTextView.setText("Logging On");
                mStatusTextView.setTextColor(Color.GREEN);
                // TODO: set logging values to textview
                String sensor_data = resultData.getString("sensor_data");
                mOutputTextView.setText(sensor_data);
                mButton.setText("STOP LOGGING");
                break;
            case LogSensorToCsv.STATUS_STOPPED:
                mIsLogging = false;
                mStatusTextView.setText("Logging Off");
                mButton.setText("RESTART LOGGING");
                mStatusTextView.setTextColor(Color.RED);
                break;
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        // Check to see if logging is running?
    }


}
