package com.jp;

import javax.management.Query;
import java.util.LinkedList;
import java.sql.*;

public class JpDbCommunicator {

    private Connection jpDbCon;

    private static final String DB_URL = "jdbc:postgresql://pgsql3.mif:5432/studentu";
    private static final String USER_NAME = "your_username";
    private static final String USER_PASS = "your_password";

    JpDbCommunicator(){
        loadDbDriver();
        jpDbCon = connectToDb();
    }

    public PreparedStatement getSelectAllFromTableQuery(String tableName){
        PreparedStatement prepStatement;
        var query = "SELECT * FROM " + tableName;

        try {
            prepStatement = jpDbCon.prepareStatement(query);
        }
        catch (SQLException e) {
            e.printStackTrace();
            System.out.println(e.getMessage());
            return null;
        }

        return prepStatement;
    }

    public PreparedStatement getSelectDinoByEnclosureQuery(int enclosureId){
        PreparedStatement prepStatement;
        var query = "SELECT * FROM Dinosaur WHERE Enclosure = ?";

        try {
            prepStatement = jpDbCon.prepareStatement(query);
            prepStatement.setInt(1, enclosureId);
        }
        catch (SQLException e) {
            e.printStackTrace();
            System.out.println(e.getMessage());
            return null;
        }

        return prepStatement;
    }

    /**
     * This method executes any Sql statement, be it SELECT, INSERT, UPDATE or DELETE.
     * @param sqlQuery A PreparedStatement that will be executed.
     * @return A QueryExecutionResult object.
     * Note: If updateCount is -1 then a SELECT query was executed, otherwise updateCount represents
     * the number of rows affected by INSERT, UPDATE or DELETE.
     */
    public QueryExecutionResult executeSqlStatement(PreparedStatement sqlQuery){
        var execResult = new QueryExecutionResult();
        try {
            if (sqlQuery.execute()) {
                var queryReader = sqlQuery.getResultSet();

                while(queryReader.next()){
                    var resultRow = new LinkedList<String>();

                    for (int i = 1; i <= queryReader.getMetaData().getColumnCount(); i++ ) {
                        resultRow.add(queryReader.getString(i));
                    }

                    execResult.resultList.add(resultRow);
                }

                execResult.updateCount = -1;
                queryReader.close();
            }
            else{
                execResult.updateCount = sqlQuery.getUpdateCount();
            }
        }
        catch (SQLException e) {
            e.printStackTrace();
            System.out.println(e.getMessage());
            return null;
        }

        return execResult;
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

