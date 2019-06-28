package com.sdk;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;

import android.app.Activity;
import android.content.Context;
import android.database.Cursor;
import android.database.SQLException;
import android.database.sqlite.SQLiteDatabase;
import android.os.Build;
import android.telephony.TelephonyManager;

import com.sdkpackage.sdk_application;

public class TrackGrid  {
	
	// Database created .. 
	private SQLiteDatabase database;
	private SaveSessionOffline saveSessionOffline;
	private String[] allColumnsSession = { SaveSessionOffline.COLUMN_ID,
			SaveSessionOffline.COLUMN_DATA };
	private EventMySQLiteHelper eventMySQLiteHelper;
	private String[] allColumnsEvent = { EventMySQLiteHelper.COLUMN_ID,
			EventMySQLiteHelper.COLUMN_DATA };
	private LocationFinder mloc;
	// Public variables..
	public String mobile_app_id;
	public String mobile_event_id;
	public double lat;
	public double lon;
	public double amount;
	public String subid1;
	public String subid2;
	public String subid3;

	private String a;
	private String e;
	private String s1;
	private String s2;
	private String s3;
	private double l;
	private double lo;
	private double am;
	private String od;
	private String di;
	private String av;
	private int os = 2;
	private int osv;
	private String dm;
	private String mod;
	private String dl;
	private String dc;
	private String c;
	private String is;
	private int m;
	private long ed;
	private long st;
	private long en;
	
	
	sdk_application appSetting ;

	
	public TrackGrid(Activity context)throws Exception {
		appSetting = new sdk_application(context);
		saveSessionOffline = new SaveSessionOffline(context);
		eventMySQLiteHelper = new EventMySQLiteHelper(context);
		mloc = new LocationFinder(context);
		OpenUDID_manager.sync(context);
		
		this.l = mloc.getLat(); 
		this.lat = mloc.getLat();
		this.lon = mloc.getLong();
		this.lo = mloc.getLong();
		Build build = new Build();
		this.mod = build.BRAND;
		this.av = build.DEVICE;
		//this.od = appSetting.getUDID();
		if(OpenUDID_manager.isInitialized()){
			this.od=OpenUDID_manager.getOpenUDID();
		}
		else{
			throw new Exception("Problem in generating open UDID");
		}
		this.av = appSetting.getAppVersion();
		this.os= 2;
		this.osv = Build.VERSION.SDK_INT;
		this.dl = Locale.getDefault().getDisplayLanguage();
		this.dc = context.getResources().getConfiguration().locale.getCountry();
		TelephonyManager manager = (TelephonyManager)context.getSystemService(Context.TELEPHONY_SERVICE);
		this.c= manager.getNetworkOperatorName();
		
	}
	
	public void open() throws SQLException {
		//database = saveSessionOffline.getWritableDatabase();
	}
	
	public void close() {
		//saveSessionOffline.close();
	}
	/*
	 * public String getA() { return a; }
	 * 
	 * public void setA(String a) { this.a = a; }
	 * 
	 * public String getE() { return e; }
	 * 
	 * public void setE(String e) { this.e = e; }
	 * 
	 * public String getS1() { return s1; }
	 * 
	 * public void setS1(String s1) { this.s1 = s1; }
	 * 
	 * public String getS2() { return s2; }
	 * 
	 * public void setS2(String s2) { this.s2 = s2; }
	 * 
	 * public String getS3() { return s3; }
	 * 
	 * public void setS3(String s3) { this.s3 = s3; }
	 * 
	 * public double getL() { return l; }
	 * 
	 * public void setL(double l) { this.l = l; }
	 * 
	 * public double getLo() { return lo; }
	 * 
	 * public void setLo(double lo) { this.lo = lo; }
	 * 
	 * public double getAm() { return am; }
	 * 
	 * public void setAm(double am) { this.am = am; }
	 * 
	 * public String getOd() { return od; }
	 * 
	 * public void setOd(String od) { this.od = od; }
	 * 
	 * public String getDi() { return di; }
	 * 
	 * public void setDi(String di) { this.di = di; }
	 * 
	 * public int getAv() { return av; }
	 * 
	 * public void setAv(int av) { this.av = av; }
	 * 
	 * public int getOs() { return os; }
	 * 
	 * public void setOs(int os) { this.os = os; }
	 * 
	 * public String getOsv() { return osv; }
	 * 
	 * public void setOsv(String osv) { this.osv = osv; }
	 * 
	 * public String getDm() { return dm; }
	 * 
	 * public void setDm(String dm) { this.dm = dm; }
	 * 
	 * public String getMod() { return mod; }
	 * 
	 * public void setMod(String mod) { this.mod = mod; }
	 * 
	 * public String getDl() { return dl; }
	 * 
	 * public void setDl(String dl) { this.dl = dl; }
	 * 
	 * public String getDc() { return dc; }
	 * 
	 * public void setDc(String dc) { this.dc = dc; }
	 * 
	 * public String getC() { return c; }
	 * 
	 * public void setC(String c) { this.c = c; }
	 * 
	 * public String getIs() { return is; }
	 * 
	 * public void setIs(String is) { this.is = is; }
	 * 
	 * public int getM() { return m; }
	 * 
	 * public void setM(int m) { this.m = m; }
	 * 
	 * public Timestamp getEd() { return ed; }
	 * 
	 * public void setEd(Timestamp ed) { this.ed = ed; }
	 * 
	 * public Timestamp getSt() { return st; }
	 * 
	 * public void setSt(Timestamp st) { this.st = st; }
	 * 
	 * public Timestamp getEn() { return en; }
	 * 
	 * public void setEn(Timestamp en) { this.en = en; }
	 */

	public String initialize(String a, String e) throws IllegalArgumentException,Exception {
		if (a == null || a.trim().length() == 0) {
			throw new IllegalArgumentException("Invalid mobile app ID");
		}
		if (e == null || e.trim().length() == 0) {
			throw new IllegalArgumentException("Invalid mobile event app ID");
		}

		this.a = a;
		this.e = e;
		return this.trackInstall();
	}

	public void initialize(String a, String e, HashMap<String, String> hm)
			throws IllegalArgumentException,Exception {
		if (hm == null) {
			throw new IllegalArgumentException("Invalid object");
		}
		decode(hm);
		initialize(a, e);
	}

	private void decode(HashMap<String, String> hm) {
		if (hm.get("s1") != null) {
			this.s1 = hm.get("s1");
		}
		if (hm.get("s2") != null) {
			this.s2 = hm.get("s2");
		}
		if (hm.get("s3") != null) {
			this.s3 = hm.get("s3");
		}
		if (hm.get("l") != null) {
			this.l = Double.parseDouble(hm.get("l"));
		}
		if (hm.get("lo") != null) {
			this.lo = Double.parseDouble(hm.get("lo"));
		}
		if (hm.get("am") != null) {
			this.am = Double.parseDouble(hm.get("am"));
		}
		if (hm.get("od") != null) {
			this.od = hm.get("od");
		}
		if (hm.get("di") != null) {
			this.di = hm.get("di");
		}
		if (hm.get("av") != null) {
			this.av = hm.get("av");
		}
		if (hm.get("os") != null) {
			this.os = Integer.parseInt(hm.get("os"));
		}
		if (hm.get("osv") != null) {
			this.osv = Integer.parseInt(hm.get("osv"));
		}
		if (hm.get("dm") != null) {
			this.dm = hm.get("dm");
		}
		if (hm.get("mod") != null) {
			this.mod = hm.get("mod");
		}
		if (hm.get("dl") != null) {
			this.dl = hm.get("dl");
		}
		if (hm.get("dc") != null) {
			this.dc = hm.get("dc");
		}
		if (hm.get("c") != null) {
			this.c = hm.get("c");
		}
		if (hm.get("is") != null) {
			this.is = hm.get("is");
		}
		if (hm.get("m") != null) {
			this.m = Integer.parseInt(hm.get("m"));
		}
		if (hm.get("ed") != null) {
			this.ed =  Long.parseLong(hm.get("ed"));
		}
		if (hm.get("st") != null) {
			this.st = Long.parseLong(hm.get("st"));
		}
		if (hm.get("en") != null) {
			this.en = Long.parseLong(hm.get("en"));
		}
	}

	public String trackInstall() throws Exception{
		
		Date date= new Date();
		long parsedDate = date.getTime();
		String ltos = String.valueOf(parsedDate);
		//int count = ltos.length();
		long new_long= Long.parseLong(ltos.substring(0, 10));
		this.ed = new_long;
		
		try{
			return NetworkCommunicator.executePostRequest(
				"https://mobile.tk2.net/m/install", encodeToJSON());
		}
		catch (Exception e) {
			throw new Exception("Exception occure.");
		}
	}
	
	public void sessionEnd() throws Exception{
		if(isNetworkAvailable())
		{
			Date date= new Date();
			long parsedDate = date.getTime();
			String ltos = String.valueOf(parsedDate);
			//int count = ltos.length();
			long new_long= Long.parseLong(ltos.substring(0, 10));
			 
			//java.sql.Timestamp timeStampDate = new  java.sql.Timestamp(date.getTime());
			this.en = new_long;
			
			try{
				
				String selectQuery = "SELECT  * FROM " + SaveSessionOffline.TABLE_SESSION;
				SQLiteDatabase db = saveSessionOffline.getWritableDatabase();
		        Cursor cursor = db.rawQuery(selectQuery, null);
		        String all_data="["; 
		        if (cursor.moveToFirst()) {
		            do {
		            		//String id = cursor.getString(0);
		            		if(all_data.length()>2){
		            			all_data = all_data + ",";
		            		}
		            		all_data = all_data + cursor.getString(1);
		            		
		                	//data.add(cursor.getString(1));
		                			                	
		               } while (cursor.moveToNext());
		            all_data = all_data + "]";
		            callSendSessionEnd(all_data);
		        }
		        
		        String install_id = NetworkCommunicator.executePostRequest("https://mobile.tk2.net/m/sessionend", encodeSessionJSON());
				saveInstallId(install_id);
		        
			}
			catch (Exception e) {
				throw new Exception("Exception occure.");
			}
		}else
		{
			saveSessionOffline.addRecord(encodeSessionJSON());
			
		}
		
	}

	private void callSendSessionEnd(String data) throws Exception {
		// TODO Auto-generated method stub
		String install_id = NetworkCommunicator.executePostRequest("https://mobile.tk2.net/m/sessionoffline", data);
		saveInstallId(install_id);
		saveSessionOffline.removeAll();
		
	}

	private void saveInstallId(String install_id) {
		// TODO Auto-generated method stub
		appSetting.storeInsatllId(install_id);
	}

	public void sessionStart() throws Exception{
		
		Date date= new Date();
		long parsedDate = date.getTime();
		String ltos = String.valueOf(parsedDate);
		//int count = ltos.length();
		long new_long= Long.parseLong(ltos.substring(0, 10));
		 
		//java.sql.Timestamp timeStampDate = new  java.sql.Timestamp(date.getTime());
		this.st = new_long;
		
		if(appSetting.isNetworkAvailable())
		{
			String install_id = NetworkCommunicator.executePostRequest("https://mobile.tk2.net/m/sessionstart", encodeSessionJSON());
			saveInstallId(install_id);
		}else
		{
			saveSessionOffline.addRecord(encodeSessionJSON());
			
		}
		 
	}
	
		/*java.util.Date date= new java.util.Date();
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss.SSS");
		String parsedDate = dateFormat.format(date);
		java.sql.Timestamp timeStampDate = new  java.sql.Timestamp(date.getTime());
		this.st = timeStampDate;
		
		String install_id = NetworkCommunicator.executePostRequest("https://mobile.tk2.net/m/sessionstart", encodeSessionJSON());
		saveInstallId(install_id);*/
	
	
	public void trackEvent(String e, HashMap<String, String> hm) throws IllegalArgumentException,Exception {
		if (e == null || e.trim().length() == 0) {
			throw new IllegalArgumentException("Invalid mobile event app ID");
		}

		this.e = e;
		if (hm == null) {
			throw new IllegalArgumentException("Invalid object");
		}
		decode(hm);
		callEventJson();
	}

	/*{
		String install_id = NetworkCommunicator.executePostRequest("https://mobile.tk2.net/m/event", encodeSessionJSON());
		saveInstallId(install_id);
	}*/
	
	
	private void callEventJson() throws Exception {
		
		// TODO Auto-generated method stub
		
		Date date= new Date();
		long parsedDate = date.getTime();
		String ltos = String.valueOf(parsedDate);
		//int count = ltos.length();
		long new_long= Long.parseLong(ltos.substring(0, 10));
		this.ed = new_long;
		
		if(isNetworkAvailable())
		{
			
		try{	
				trackOffline();
				String install_id = NetworkCommunicator.executePostRequest("https://mobile.tk2.net/m/event", encodeEventJSON());
				saveInstallId(install_id);
	        }catch (Exception e) {
				throw new Exception("Exception occure.");
			}
			
		}else
		{
			eventMySQLiteHelper.addRecord(encodeSessionJSON());
			
		}
		
	}

	private boolean isNetworkAvailable() throws Exception {
		boolean checkConnection;
		try{
			String responce = NetworkCommunicator.executePostRequest(
				"https://www.google.co.in/", encodeToJSON());
			checkConnection =  true;
		}
		catch (Exception e) {
			checkConnection =  false;
		}
		return checkConnection;
	}

	private void callSendOfflineEvent(String all_data) throws Exception {
		// TODO Auto-generated method stub
		String install_id = NetworkCommunicator.executePostRequest("https://mobile.tk2.net/m/eventoffline", all_data);
		saveInstallId(install_id);
		eventMySQLiteHelper.removeAllRecord();
		
	}
	
	
	private void trackOffline() throws Exception{
		String selectQuery = "SELECT  * FROM " + EventMySQLiteHelper.TABLE_EVENT;
		SQLiteDatabase db = saveSessionOffline.getWritableDatabase();
        Cursor cursor = db.rawQuery(selectQuery, null);
        String all_data="["; 
        if (cursor.moveToFirst()) {
            do {
            		//String id = cursor.getString(0);
            		if(all_data.length()>2){
            			all_data = all_data + ",";
            		}
            		all_data = all_data + cursor.getString(1);
            		
                	//data.add(cursor.getString(1));
                			                	
               } while (cursor.moveToNext());
            all_data = all_data + "]";
            callSendOfflineEvent(all_data);
        }
		
	}

	private String encodeToJSON() {
		return "{\"m\" : " + this.m + ",\"a\" : \"" + this.a + "\",\"e\" : \""
				+ this.e + "\",\"av\" : \"" + this.av + "\",\"am\" : \""
				+ this.am + "\",\"os\" : " + this.os + ",\"osv\" : \""
				+ this.osv + "\",\"dm\" : \"" + this.dm + "\",\"mod\" : \""
				+ this.mod + "\",\"dl\" : \"" + this.dl + "\",\"dc\" : \""
				+ this.dc + "\",\"od\" :\"" + this.od
				+ "\",\"di\" : \"di\",\"c\" : \"" + this.c + "\",\"l\" : "
				+ this.l + ",\"lo\" : " + this.lo + ",\"s1\" :\"" + this.s1
				+ "\",\"s2\" : \"" + this.s2 + "\",\"s3\" : \"" + this.s3
				+ "\",\"ed\" : " + this.ed + "}";
	}
	
	
		
	private String encodeSessionJSON(){
			return "{\"m\" : " + this.m + 
					", \"a\" : \""+ this.a +"\", " +
					"\"od\" : \"" + this.od +"\", " +
					" \"di\" : \" "  + this.di +"\", " +
					"\"st\" : " + this.st + 
					", \"en\" : " + this.en + "}";
		
	}
	
	private String encodeEventJSON(){
		
		return "{\"m\" : " + this.m + 
				", \"a\" : \""+ this.a +"\", " +
				"\"e\" : \""+ this.e +"\", " +
				"\"am\" : \""+ this.am +"\", " +
				"\"od\" : \"" + this.od +"\", " +
				"\"di\" : \" "  + this.di +"\", " +
				"\"l\" : "  + this.l + ", " +
				"\"lo\" :  "  + this.lo + ", " +
				"\"s1\" : \" "  + this.s1 +"\", " +
				"\"s2\" : \" "  + this.s2 +"\", " +
				"\"s3\" : \" "  + this.s3 +"\", " +
				"\"ed\" : " + this.ed + "}";
	}
	
	
	
}

