package com.jp;

import com.jcraft.jsch.JSch;
import com.jcraft.jsch.JSchException;

import java.util.LinkedList;
import java.sql.*;

public class JpDbCommunicator {

    private Connection jpDbCon;

    private static final String DB_URL = "jdbc:postgresql://localhost:1234/studentu";
    private static final String USER_NAME = username;
    private static final String USER_PASS = password;

    JpDbCommunicator() throws JSchException {
        // SSH connection code taken from:
        // https://www.journaldev.com/235/java-mysql-ssh-jsch-jdbc
        var lport = 1234;
        var rport = 5432;
        var host = "uosis.mif.vu.lt";
        var rhost = "pgsql3.mif";

        //Set StrictHostKeyChecking property to no to avoid UnknownHostKey issue
        java.util.Properties config = new java.util.Properties();
        config.put("StrictHostKeyChecking", "no");
        var jsch = new JSch();
        var session = jsch.getSession(USER_NAME, host, 22);
        session.setPassword(USER_PASS);
        session.setConfig(config);
        session.connect();
        System.out.println("Connected to SSH");

        int assinged_port = session.setPortForwardingL(lport, rhost, rport);
        System.out.println("localhost:" + assinged_port + " -> " + rhost + ":" + rport);
        System.out.println("Port Forwarded");

        loadDbDriver();
        System.out.println("Connecting to database...");
        jpDbCon = connectToDb();
    }

    //region SELECT Statements
    public PreparedStatement getSelectAllFromTableQuery(String tableName){
        var query = "SELECT * FROM " + tableName;

        return prepareSqlStatement(query);
    }

    public PreparedStatement getSelectEnclosureByTypeQuery(String enclosureType){
        var query = "SELECT * FROM Enclosure WHERE enclosuretype = ?";

        return prepareSqlStatement(query, enclosureType);
    }

    public PreparedStatement getSelectEnclosureByDinoSpeciesQuery(String dinoSpecies){
        var query =
                "WITH SpeciesInEnclosure(enclosureId, species) AS " +
                        "(SELECT enclosure, species FROM Dinosaur " +
                        "WHERE species = ? " +
                        "GROUP BY enclosure, species) " +
                        "SELECT id, enclosuretype, size, costnodiscount, costwithdiscount, agelimit, discountage " +
                        "FROM Enclosure, SpeciesInEnclosure AS SpcEn WHERE id = SpcEn.enclosureId";

        return prepareSqlStatement(query, dinoSpecies);
    }

    public PreparedStatement getSelectDinoByNameQuery(String dinoName){
        var query = "SELECT * FROM Dinosaur WHERE name = ?";

        return prepareSqlStatement(query, dinoName);
    }

    public PreparedStatement getSelectDinoByEnclosureQuery(int enclosureId){
        var query = "SELECT * FROM Dinosaur WHERE enclosure = ?";

        return prepareSqlStatement(query, enclosureId);
    }

    public PreparedStatement getSelectWorkerBySpecialtyQuery(String specialty){
        var query = "SELECT * FROM Worker WHERE specialty = ?";

        return prepareSqlStatement(query, specialty);
    }

    public PreparedStatement getSelectWorkerBySpecialtySurnameQuery(String specialty, String workerSurname){
        var query = "SELECT * FROM Worker WHERE specialty = ? AND surname = ?";

        return prepareSqlStatement(query, specialty, workerSurname);
    }

    public PreparedStatement getSelectMonetSpentByVisitorQuery(int visitorId){
        var query = "SELECT moneyspent FROM Visit WHERE citizenid = ?";

        return prepareSqlStatement(query, visitorId);
    }
    //endregion

    /**
     * This method executes any Sql statement, be it SELECT, INSERT, UPDATE or DELETE.
     * When an exception occurs in sql statement execution, this method rolls back the statement changes.
     * @param sqlStatement A PreparedStatement that will be executed.
     * @param commitChanges A boolean value that allows to specify whether you want the changes to be
     * committed to the database or not.
     * @return A SqlStatementExecutionResult object.
     * Note1: If updateCount is -1 then a SELECT query was executed, otherwise updateCount represents
     * the number of rows affected by INSERT, UPDATE or DELETE.
     * Note2: If a SELECT query was executed then the queried columns' names will be saved in the
     * SqlStatementExecutionResult object's columnNames field.
     */
    public SqlStatementExecutionResult executeSqlStatement(PreparedStatement sqlStatement, boolean commitChanges)
            throws SqlExecFailedException, RollbackFailedException {
        var execResult = new SqlStatementExecutionResult();

        try (sqlStatement){
            if (sqlStatement.execute()) {
                try (var queryReader = sqlStatement.getResultSet()){
                    var queryMetaData = queryReader.getMetaData();
                    var columnCount = queryMetaData.getColumnCount();

                    execResult.updateCount = -1;

                    for (int i = 1; i <= columnCount; i++){
                        execResult.columnNames.add(queryMetaData.getColumnName(i));
                    }

                    while(queryReader.next()) {
                        var resultRow = new LinkedList<String>();

                        for (int i = 1; i <= columnCount; i++) {
                            resultRow.add(queryReader.getString(i));
                        }

                        execResult.resultList.add(resultRow);
                    }
                }
            }
            else{
                execResult.updateCount = sqlStatement.getUpdateCount();
            }

            if (commitChanges){
                commitChangesToDb();
            }
            return execResult;
        }
        catch (SQLException e) {
            rollbackNotCommittedChanges();

            throw new SqlExecFailedException("Sql statement execution failed.", e);
        }
    }

    /**
     * This method executes multiple Sql statements of any kind, be it SELECT, INSERT, UPDATE or DELETE.
     * Unlike executeSqlStatement, this method commits changes to the database after it executes
     * all of the Sql statements without any exceptions occurring.
     * @param sqlStatements multiple PreparedStatements that will be executed.
     * @return A LinkedList of SqlStatementExecutionResult objects.
     * Note1: If a SqlStatementExecutionResult's updateCount is -1 then a SELECT query
     * was executed, otherwise updateCount represents
     * the number of rows affected by INSERT, UPDATE or DELETE.
     * Note2: If a SELECT query was executed then the queried columns' names will be saved in the
     * SqlStatementExecutionResult object's columnNames field.
     */
    public LinkedList<SqlStatementExecutionResult> executeSqlStatements(PreparedStatement... sqlStatements)
            throws SqlExecFailedException, RollbackFailedException {
        var execResults = new LinkedList<SqlStatementExecutionResult>();

        for (PreparedStatement sqlStatement : sqlStatements) {
            var execResult = executeSqlStatement(sqlStatement, false);
            execResults.add(execResult);
        }

        commitChangesToDb();
        return execResults;
    }

    public void rollbackNotCommittedChanges()
            throws RollbackFailedException{
        try {
            jpDbCon.rollback();
        }
        catch (SQLException e) {
            e.printStackTrace();
            System.out.println(e.getMessage());
            throw new RollbackFailedException("The program was unable to rollback changes.", e);
        }
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
            psqlCon.setAutoCommit(false);
        }
        catch (SQLException e) {
            e.printStackTrace();
            System.out.println(e.getMessage());
            return null;
        }

        return psqlCon;
    }

    private PreparedStatement prepareSqlStatement(String query, Object... values) {
        PreparedStatement prepStatement;

        try {
            prepStatement = jpDbCon.prepareStatement(query);
            var parameterIndex = 1;

            for (Object value : values){
                if (value instanceof Integer){
                    prepStatement.setInt(parameterIndex, (Integer) value);
                }
                else if (value instanceof Double){
                    prepStatement.setDouble(parameterIndex, (Double) value);
                }
                else if (value instanceof String){
                    prepStatement.setString(parameterIndex, (String) value);
                }
                parameterIndex++;
            }
        }
        catch (SQLException e) {
            e.printStackTrace();
            System.out.println(e.getMessage());
            return null;
        }

        return prepStatement;
    }

    private void commitChangesToDb(){
        try {
            jpDbCon.commit();
        }
        catch (SQLException e) {
            e.printStackTrace();
            System.out.println(e.getMessage());
        }
    }
}
