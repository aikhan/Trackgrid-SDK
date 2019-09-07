package com.sdk;

import android.content.ContentValues;
import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteDatabase.CursorFactory;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;

public class EventMySQLiteHelper extends SQLiteOpenHelper{
	
	public static final String TABLE_EVENT ="events";
	public static final String COLUMN_ID = "_id";
	public static final String COLUMN_DATA = "data";
	
	private static final String DATABASE_NAME = "sdk_pro.db";
	private static final int DATABASE_VERSION = 1;
	
	
	private static final String DATABASE_CREATE = "create table "
			+ TABLE_EVENT + "(" + COLUMN_ID
			+ " integer primary key autoincrement, " + COLUMN_DATA
			+ " text not null);";
	
	public EventMySQLiteHelper(Context context) {
		super(context, DATABASE_NAME, null, DATABASE_VERSION);
		// TODO Auto-generated constructor stub
	}

	@Override
	public void onCreate(SQLiteDatabase db) {
		// TODO Auto-generated method stub
		db.execSQL(DATABASE_CREATE);
	}

	@Override
	public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
		// TODO Auto-generated method stub
		Log.w(EventMySQLiteHelper.class.getName(),"Upgrading database from version " + oldVersion + " to "+ newVersion + ", which will destroy all old data");
		db.execSQL("DROP TABLE IF EXISTS " + TABLE_EVENT);
		onCreate(db);
		
	}
	
	public void addRecord(String data){
		SQLiteDatabase db = this.getWritableDatabase();
		ContentValues values = new ContentValues();
		values.put(COLUMN_DATA, data);  // Event Data
		// Inserting row 
		db.insert(TABLE_EVENT, null, values);
		db.close();
	}
	
	public void deleteRecordById(String id){
		SQLiteDatabase db = this.getWritableDatabase();
		db.delete(TABLE_EVENT, COLUMN_ID + " = ?", new String[] { String.valueOf(id)});
		db.close();
	}
	
	public void removeAllRecord(){
		SQLiteDatabase db = this.getWritableDatabase();
		db.delete(this.TABLE_EVENT, null, null);
		db.close();
	}

}
