package com.jp;

import java.util.LinkedList;
import java.sql.*;

public class JpDbCommunicator {

    private Connection jpDbCon;

    private static final String DB_URL = "jdbc:postgresql://pgsql3.mif/studentu";
    private static final String USER_NAME = "your_username";
    private static final String USER_PASS = "your_password";

    JpDbCommunicator(){
        loadDbDriver();
        jpDbCon = connectToDb();
    }


    public PreparedStatement getSelectDinoByEnclosureQuery(int enclosure){
        PreparedStatement prepStatement;
        var query = "SELECT * FROM Dinosaur WHERE Enclosure = ?";

        try {
            prepStatement = jpDbCon.prepareStatement(query);
            prepStatement.setInt(1, enclosure);
        }
        catch (SQLException e) {
            e.printStackTrace();
            System.out.println(e.getMessage());
            return null;
        }

        return prepStatement;
    }

    public LinkedList<LinkedList<String>> executeSqlQuery(PreparedStatement sqlQuery){
        var results = new LinkedList<LinkedList<String>>();
        try {
            var queryReader = sqlQuery.executeQuery();

            while(queryReader.next()){
                var resultRow = new LinkedList<String>();

                for (int i = 1; i <= queryReader.getMetaData().getColumnCount(); i++ ) {
                    resultRow.add(queryReader.getString(i));
                }

                results.add(resultRow);
            }
        }
        catch (SQLException e) {
            e.printStackTrace();
            System.out.println(e.getMessage());
            return null;
        }

        return results;
    }

    public void closeConnection(){
        try {
            jpDbCon.close();
        }
        catch (SQLException e) {
            e.printStackTrace();
            System.out.println(e.getMessage());
        }
    }

    private void loadDbDriver(){
        try {
            Class.forName("org.postgresql.Driver");
        }
        catch (ClassNotFoundException e) {
            e.printStackTrace();
            System.out.println(e.getMessage());
        }
    }

    private Connection connectToDb(){
        Connection psqlCon;

        try {
            psqlCon = DriverManager.getConnection(DB_URL, USER_NAME, USER_PASS);
        }
        catch (SQLException e) {
            e.printStackTrace();
            System.out.println(e.getMessage());
            return null;
        }

        return psqlCon;
    }
}

