package com.example.jonpeck.logsensor;

import android.os.Bundle;
import android.os.ResultReceiver;
import android.os.Handler;
import android.util.Log;


/**
 * Created by Jon Peck on 2/26/2015.
 */

// TODO: Replace with b
public class LoggingStatusReceiver extends ResultReceiver {
    private Receiver mReceiver;

    public LoggingStatusReceiver(Handler handler){
        super(handler);
    }

    public void setReceiver(Receiver receiver){
        mReceiver = receiver;
    }

    public interface Receiver {
        public void onReceiveResult(int resultCode, Bundle resultData);
    }

    @Override
    protected  void onReceiveResult(int resultCode, Bundle resultData)
    {
        String sensor_data = resultData.getString("sensor_data");
        /*
        if (sensor_data != null) {
            Log.i("onReceiveResult()", sensor_data);
        }
        else {
            Log.i("onReceiveResult()","Nothing in bundle");
        }
        */
        if (mReceiver != null) {
            mReceiver.onReceiveResult(resultCode,resultData);
        }

    }


}
