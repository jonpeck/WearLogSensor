package com.example.jonpeck.logsensor;

import android.app.IntentService;
import android.app.Service;
import android.content.Intent;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.os.Bundle;
import android.os.Environment;
import android.os.IBinder;
import android.os.PowerManager;
import android.os.ResultReceiver;
import android.util.Log;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

/**
 * Created by Jon Peck on 2/25/2015.
 */
public class LogSensorToCsv extends Service implements SensorEventListener {
    public static final int STATUS_RUNNING = 0;
    public static final int STATUS_STOPPED = 1;
    public static final int STATUS_ERROR = 2;

    public static final boolean LOG_LA = false;
    public static final boolean LOG_G = false;
    public static final boolean LOG_MAG = false;
    public static final boolean LOG_LIGHT = true;

    private SensorManager mSensorManager;
    private Sensor mSensor;
    private long mTimestamp;
    private long mStartTime;
    private SimpleDateFormat mSdf;
    private FileWriter mCsvWrite;
    private ResultReceiver mResultReceiver;
    private PowerManager mPowerManager;
    private PowerManager.WakeLock mWakeLock;
    private int mSensorRequested;

    // Storage for Sensor readings
    private float[] mGravity = null;
    private float[] mAccelerometer = null;
    private float[] mLinearAcceleration = null;
    private float[] mGeomagnetic = null;
    private float mLight;


    public LogSensorToCsv() {
        // super("LogSensorToCsv");

    }

    @Override
    public void onCreate() {
        super.onCreate();


        // Setup formatting of time and get initial time
        mSdf = new SimpleDateFormat("yyyy-MM-dd'T'HHmmss-SSS", Locale.US);
        mStartTime = (new Date()).getTime();// - (System.nanoTime() / 1000000L);
        mLight = 0;
        mGravity = new float[3];
        mLinearAcceleration = new float[3];

        // Setup the sensor
        mSensorManager = (SensorManager) getSystemService(SENSOR_SERVICE);
        //mSensor = Sensor.TYPE_ACCELEROMETER;
        //mAccelerometer = mSensorManager.getDefaultSensor(mSensor);

        // Setup the file output
        /*
        File root = Environment.getExternalStorageDirectory();
        File csv = new File(root,mSdf.format(mStartTime) + "_" + Integer.toString(mSensorRequested) + ".csv");
        try {
            mCsvWrite = new FileWriter(csv);
        } catch(IOException e)
        {
            e.printStackTrace();
        }*/

        // Get stuff for wakelock
        mPowerManager = (PowerManager) getSystemService(POWER_SERVICE);
        mWakeLock = mPowerManager.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK,
                "LoggingSensorToCsvWl");


    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        mSensorManager = (SensorManager) getSystemService(SENSOR_SERVICE);

        Sensor a_sensor = mSensorManager.getDefaultSensor(Sensor.TYPE_LINEAR_ACCELERATION);
        Sensor g_sensor = mSensorManager.getDefaultSensor(Sensor.TYPE_GRAVITY);
        Sensor c_sensor = mSensorManager.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD);
        Sensor l_sensor = mSensorManager.getDefaultSensor(Sensor.TYPE_LIGHT);

        // Setup the file output

        File root = Environment.getExternalStorageDirectory();
        File csv = new File(root,mSdf.format(mStartTime) + "_" + Integer.toString(mSensorRequested) + ".csv");
        try {
            mCsvWrite = new FileWriter(csv);
            Log.i("onStartCommand","Opened file: " + mSdf.format(mStartTime) + "_" + Integer.toString(mSensorRequested) + ".csv");
        } catch(IOException e)
        {
            e.printStackTrace();
        }

        mResultReceiver = intent.getParcelableExtra("receiver");

        if (intent.getExtras().getBoolean("loggingEnabled")) {
            mSensorManager.registerListener(this, a_sensor, SensorManager.SENSOR_DELAY_GAME);
            mSensorManager.registerListener(this, g_sensor, SensorManager.SENSOR_DELAY_GAME);
            mSensorManager.registerListener(this, c_sensor, SensorManager.SENSOR_DELAY_GAME);
            if (LOG_LIGHT) {
                mSensorManager.registerListener(this, l_sensor, SensorManager.SENSOR_DELAY_GAME);
            }
            Bundle bundle = new Bundle();
            String no_data_string = "No data yet";
            bundle.putString("sensor_data",no_data_string);
            Log.i("onHandleIntent()","Started Logging");
            mWakeLock.acquire();
            mResultReceiver.send(STATUS_RUNNING, bundle);
        } else {
            Log.i("onHandleIntent()","Stopped Logging");
            mSensorManager.unregisterListener(this);
            try {
                mCsvWrite.flush();
            } catch (IOException e) {
                e.printStackTrace();
            }
            try {
                mCsvWrite.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
            mResultReceiver.send(STATUS_STOPPED, Bundle.EMPTY);
            mWakeLock.release();
            stopSelf();
        }

        return START_STICKY;
    }

    public void onAccuracyChanged(Sensor sensor, int accuracy) {

    }

    public void onSensorChanged(SensorEvent event) {
        final float alpha = 0.8f;


        if (event.sensor.getType() == Sensor.TYPE_GRAVITY) {

            mGravity = new float[3];
            System.arraycopy(event.values, 0, mGravity, 0, 3);
        }

        // Acquire magnetometer event data
        else if (event.sensor.getType() == Sensor.TYPE_MAGNETIC_FIELD) {

            mGeomagnetic = new float[3];
            System.arraycopy(event.values, 0, mGeomagnetic, 0, 3);

        }
        else if (event.sensor.getType() == Sensor.TYPE_LINEAR_ACCELERATION)
        {
            mLinearAcceleration = new float[3];
            System.arraycopy(event.values, 0, mLinearAcceleration, 0, 3);
        }
        else if (event.sensor.getType() == Sensor.TYPE_LIGHT) {
            mLight = event.values[0];
        }

        // If we have readings from both sensors then
        // use the readings to compute the device's orientation
        // and then update the display.
        String sensor_text = mSdf.format(new Date(mStartTime));

        String line = Long.toString(mTimestamp);

        if (mGravity != null && mGeomagnetic != null) {

            float rotationMatrix[] = new float[9];

            // Users the accelerometer and magnetometer readings
            // to compute the device's rotation with respect to
            // a real world coordinate system

            boolean success = SensorManager.getRotationMatrix(rotationMatrix,
                    null, mGravity, mGeomagnetic);

            if (success) {

                float orientationMatrix[] = new float[3];

                // Returns the device's orientation given
                // the rotationMatrix

                SensorManager.getOrientation(rotationMatrix, orientationMatrix);

                // Get the rotation, measured in radians, around the Z-axis
                // Note: This assumes the device is held flat and parallel
                // to the ground

                float rotationInRadians = orientationMatrix[0];

                // Convert from radians to degrees
                //mRotationInDegress = Math.toDegrees(rotationInRadians);

                mTimestamp = (new Date()).getTime() + (event.timestamp - System.nanoTime()) / 1000000L;//(event.timestamp - System.nanoTime()) / 1000000L;

                sensor_text = sensor_text
                        + " t=" + Long.toString(mTimestamp)
                        + " x=" + Float.toString(orientationMatrix[0])
                        + " y=" + Float.toString(orientationMatrix[1])
                        + " z=" + Float.toString(orientationMatrix[2]);

                line = line
                        + "," + Float.toString(orientationMatrix[0])
                        + "," + Float.toString(orientationMatrix[1])
                        + "," + Float.toString(orientationMatrix[2]);

                if (LOG_G) {
                    line = line
                            + "," + Float.toString(mGravity[0])
                            + "," + Float.toString(mGravity[1])
                            + "," + Float.toString(mGravity[2]);
                }
                if (LOG_LA) {
                    line = line
                            + "," + Float.toString(mLinearAcceleration[0])
                            + "," + Float.toString(mLinearAcceleration[1])
                            + "," + Float.toString(mLinearAcceleration[2]);
                }
                if (LOG_MAG) {
                    line = line
                            + "," + Float.toString(mGeomagnetic[0])
                            + "," + Float.toString(mGeomagnetic[1])
                            + "," + Float.toString(mGeomagnetic[2]);
                }


            }
        }

        if (LOG_LIGHT) {
            line = line + "," + Float.toString(mLight);
            sensor_text = sensor_text + " l=" + Float.toString(mLight);
        }

        line = line + "\n";

        try {
            mCsvWrite.write(line);
        } catch (IOException e) {
            e.printStackTrace();
        }

        //mTextView.setText(sensor_text);
        Bundle bundle = new Bundle();
        bundle.putString("sensor_data", sensor_text);
        Log.i("getAccelerometer()", sensor_text);
        mResultReceiver.send(STATUS_RUNNING, bundle);
    }

    private void getAccelerometer(SensorEvent event) {
        float[] values = event.values;
        // Movement
        float x = values[0];
        float y = values[1];
        float z = values[2];

        mTimestamp = (new Date()).getTime() + (event.timestamp - System.nanoTime()) / 1000000L;//(event.timestamp - System.nanoTime()) / 1000000L;

        String sensor_text = mSdf.format(new Date(mStartTime))
                + " t=" + Long.toString(mTimestamp)
                + " x=" + Float.toString(x)
                + " y=" + Float.toString(y)
                + " z=" + Float.toString(z);

        String line = Long.toString(mTimestamp)
                + "," + Float.toString(x)
                + "," + Float.toString(y)
                + "," + Float.toString(z)
                + "\n";

        try {
            mCsvWrite.write(line);
        } catch (IOException e) {
            e.printStackTrace();
        }

        //mTextView.setText(sensor_text);
        Bundle bundle = new Bundle();
        bundle.putString("sensor_data",sensor_text);
        Log.i("getAccelerometer()", sensor_text);
        mResultReceiver.send(STATUS_RUNNING, bundle);
    }

    @Override
    public IBinder onBind(Intent intent) {
        // We don't provide binding, so return null
        return null;
    }

    @Override
    public void onDestroy() {
        Log.i("onDestroy()","Stopped Logging");
        mSensorManager.unregisterListener(this);
        try {
            mCsvWrite.flush();
        } catch (IOException e) {
            e.printStackTrace();
        }
        try {
            mCsvWrite.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        mResultReceiver.send(STATUS_STOPPED, Bundle.EMPTY);
        mWakeLock.release();
        //stopSelf();
    }


}




