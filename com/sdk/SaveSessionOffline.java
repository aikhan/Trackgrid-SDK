package com.sdk;

import android.content.ContentValues;
import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteDatabase.CursorFactory;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;

public class SaveSessionOffline extends SQLiteOpenHelper{
	
	public static final String TABLE_SESSION = "session";
	public static final String COLUMN_ID = "_id";
	public static final String COLUMN_DATA = "session_data";

	private static final String DATABASE_NAME = "sdk_pro.db";
	private static final int DATABASE_VERSION = 1;
	
	
	private static final String DATABASE_CREATE = "create table "
			+ TABLE_SESSION + "(" + COLUMN_ID
			+ " integer primary key autoincrement, " + COLUMN_DATA
			+ " text not null);";

	public SaveSessionOffline(Context context) {
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
		Log.w(SaveSessionOffline.class.getName(),
				"Upgrading database from version " + oldVersion + " to "
						+ newVersion + ", which will destroy all old data");
		db.execSQL("DROP TABLE IF EXISTS " + TABLE_SESSION);
		onCreate(db);
		
	}
	
	void addRecord(String data) {
        SQLiteDatabase db = this.getWritableDatabase();
        ContentValues values = new ContentValues();
        values.put(COLUMN_DATA, data); // session data
        // Inserting Row
        db.insert(TABLE_SESSION, null, values);
        db.close(); // Closing database connection
    }
	
	public void deleteRecord(String id) {
        SQLiteDatabase db = this.getWritableDatabase();
        db.delete(TABLE_SESSION, COLUMN_ID + " = ?",
                new String[] { String.valueOf(id) });
        db.close();
    }
	
	public void removeAll()
	{
	    // db.delete(String tableName, String whereClause, String[] whereArgs);
	    // If whereClause is null, it will delete all rows.
	    SQLiteDatabase db = this.getWritableDatabase(); // helper is object extends SQLiteOpenHelper
	    db.delete(this.TABLE_SESSION, null, null);
	    db.close();

	}

}
