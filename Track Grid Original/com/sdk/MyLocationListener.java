package com.sdk;

import android.location.Location;
import android.location.LocationListener;
import android.os.Bundle;

public class MyLocationListener implements LocationListener {
	
	Location mloc = null;
	public void onLocationChanged(Location loc) {

		mloc = loc;
	}

	@Override
	public void onStatusChanged(String provider, int status, Bundle extras) {

	}

	@Override
	public void onProviderEnabled(String provider) {

		// Gps Enabled
	}

	@Override
	public void onProviderDisabled(String provider) {

		// Gps Disabled
	}


}
