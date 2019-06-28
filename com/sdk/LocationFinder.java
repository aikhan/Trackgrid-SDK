package com.sdk;

import android.app.Application;
import android.content.Context;
import android.location.Criteria;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;

public class LocationFinder extends Application{
	
	Location mloc = null;
	Context context;
	double latitude;
	double longitude;
	
	LocationFinder(Context _context){
		this.context = _context;
		
		LocationManager mlocManager = (LocationManager) context.getSystemService(context.LOCATION_SERVICE);
		LocationListener mlocListener = new MyLocationListener();
		mlocManager = (LocationManager)  context.getSystemService(context.LOCATION_SERVICE);
		mlocManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 0,
				0, mlocListener);
		mloc = mlocManager.getLastKnownLocation(mlocManager.getBestProvider(new Criteria(), false));
		if (mloc != null) {
			latitude = mloc.getLatitude();
			longitude = mloc.getLongitude();
			
		} else {
			String Latlong = "Your GPS location not detected yet. Please try again.";
		}
		
	}
	
	public double getLat(){
		return latitude;
	}
	
	public double getLong(){
		return longitude;
	}
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
}
