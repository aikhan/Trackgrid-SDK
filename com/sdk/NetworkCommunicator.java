package com.sdk;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLEncoder;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.drawable.BitmapDrawable;
import android.provider.Settings.Secure;
import android.util.Log;

public class NetworkCommunicator {
	private static final String TAG = "NetworkCommunicator";

	public static String executeGetRequest(String URL) {
		try {
			final HttpClient client = new DefaultHttpClient();
			final HttpGet get = new HttpGet(URL);
			final HttpResponse response = client.execute(get);
			final HttpEntity responseEntity = response.getEntity();
			final BufferedReader reader = new BufferedReader(
					new InputStreamReader(responseEntity.getContent(),"iso-8859-1" ));
			String line = reader.readLine();
			final StringBuffer buff = new StringBuffer();
			while (line != null) {
				buff.append(line);
				line = reader.readLine();
			}
			return buff.toString();
		} catch (Exception e) {
			Log.e(TAG, "Error loading data from " + URL, e);
			return null;
		}
	}
	public static String executeGetRequest(String URL, String qparams)throws Exception {
		try {
			final HttpClient client = new DefaultHttpClient();
			StringBuilder params = new StringBuilder();
			params.append(URL);
			params.append("?");
			params.append(qparams);
			final HttpGet get = new HttpGet(params.toString());
			final HttpResponse response = client.execute(get);
			final HttpEntity responseEntity = response.getEntity();
			final BufferedReader reader = new BufferedReader(
					new InputStreamReader(responseEntity.getContent(),"iso-8859-1" ));
			String line = reader.readLine();
			final StringBuffer buff = new StringBuffer();
			while (line != null) {
				buff.append(line);
				line = reader.readLine();
			}
			return buff.toString();
		} catch (Exception e) {
			throw new Exception("Exception occure.");
		}
	}

	public static String executePostRequest(String URL,
			String postData)throws Exception {
		try {
			final HttpClient client = new DefaultHttpClient();
			final HttpPost post = new HttpPost(URL);
			post.addHeader("Content-Type", "text/json");
			post.setEntity(new StringEntity(postData));
			
			final HttpResponse response;
			try {
				response = client.execute(post);
			}
			catch (Exception e) {
				throw new Exception("Exception occure.");
			}
			//CharsetDecoder.deco
			final HttpEntity responseEntity = response.getEntity();
			final BufferedReader reader = new BufferedReader(
					new InputStreamReader(responseEntity.getContent(),"iso-8859-1"));
			String line = reader.readLine();
			final StringBuffer buff = new StringBuffer();
			while (line != null) {
				buff.append(line);
				line = reader.readLine();
			}
			return buff.toString();
		} catch (Exception e) {
			throw new Exception("Exception occure.");
		}
	}

	public static BitmapDrawable loadEventImage(String imageURL) {
		try {
			final HttpClient client = new DefaultHttpClient();
			Log.d(TAG, "Loading image from url " + imageURL);
			final HttpGet request = new HttpGet(imageURL);
			final HttpResponse response = client.execute(request);
			final HttpEntity responseEntity = response.getEntity();
			final BitmapDrawable drawable = new BitmapDrawable(
					responseEntity.getContent());
			return drawable;
		} catch (Exception e) {
			Log.e(TAG, "Error in reading product image from " + imageURL, e);
			return null;
		}
	}

	public static BitmapDrawable loadScaledImage(String imageURL) {
		try {
			/*final HttpClient client = new DefaultHttpClient();
			Log.d(TAG, "Loading image from url " + imageURL);
			final HttpGet request = new HttpGet(imageURL);
			final HttpResponse response = client.execute(request);
			final HttpEntity responseEntity = response.getEntity();
			BitmapFactory.Options opts = new BitmapFactory.Options();
			opts.inSampleSize =  4;
			Bitmap bmp = BitmapFactory.decodeStream(responseEntity.getContent(), null, opts);
			final BitmapDrawable drawable = new BitmapDrawable(bmp);
			return drawable;*/
			
			URL url = new URL(imageURL);
			BitmapFactory.Options opts = new BitmapFactory.Options();
			opts.inSampleSize =  4;
			Bitmap bmp =  BitmapFactory.decodeStream(url.openConnection().getInputStream(), null, opts);
			final BitmapDrawable drawable = new BitmapDrawable(bmp);
			return drawable;
			
		} catch (Exception e) {
			Log.e(TAG, "Error in reading product image from " + imageURL, e);
			return null;
		}
	}

	public static BitmapDrawable loadImage(String imageName, String imageURL,
			int width, int height) {
		try {
			final HttpClient client = new DefaultHttpClient();
			Log.d(TAG,
					"Loading image from url " + imageURL
							+ URLEncoder.encode(imageName) + "&w=" + width
							+ "&h=" + height + "&zc=0&q=100");
			final HttpGet request = new HttpGet(imageURL
					+ URLEncoder.encode(imageName) + "&w=" + width + "&h="
					+ height + "&zc=0&q=100");
			final HttpResponse response = client.execute(request);
			final HttpEntity responseEntity = response.getEntity();
			final BitmapDrawable drawable = new BitmapDrawable(
					decodeArtistIcons(responseEntity.getContent()));
			return drawable;
		} catch (Exception e) {
			Log.e(TAG, "Error in reading product image", e);
			return null;
		}
	}

	private static Bitmap decodeArtistIcons(InputStream f) {
		Bitmap b = null;
		try {
			// Decode image size
			BitmapFactory.Options o = new BitmapFactory.Options();
			o.inPurgeable = true;
			b = BitmapFactory.decodeStream(f, null, o);
			f.close();
		} catch (IOException e) {
			Log.e(TAG, e.getMessage(), e);
		}
		return b;
	}
	
	
	

}
