package com.jp;

import com.jcraft.jsch.JSch;
import com.jcraft.jsch.JSchException;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.LinkedList;

public class JpDbCommunicator {

    private Connection jpDbCon;

    // "jdbc:postgresql://pgsql3.mif:5432/studentu";
    private static final String DB_URL = "jdbc:postgresql://localhost:1234/studentu";
    private static final String USER_NAME = username;
    private static final String USER_PASS = password;

    JpDbCommunicator() throws JSchException {
        connectToSsh();
        loadDbDriver();
        System.out.println("Connecting to database...");
        jpDbCon = connectToDb();
    }

    private void connectToSsh() throws JSchException {
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
     * @param sqlQuery A PreparedStatement that will be executed.
     * @return A SqlStatementExecutionResult object.
     * Note1: If updateCount is -1 then a SELECT query was executed, otherwise updateCount represents
     * the number of rows affected by INSERT, UPDATE or DELETE.
     * Note2: If a SELECT query was executed then the queried columns' names will be saved in the
     * SqlStatementExecutionResult object's columnNames field.
     */
    public SqlStatementExecutionResult executeSqlStatement(PreparedStatement sqlQuery)
            throws SqlExecFailedException, RollbackFailedException {
        var execResult = new SqlStatementExecutionResult();

        try (sqlQuery){
            if (sqlQuery.execute()) {
                try (var queryReader = sqlQuery.getResultSet()){
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
                execResult.updateCount = sqlQuery.getUpdateCount();
            }

            jpDbCon.commit();
            return execResult;
        }
        catch (SQLException e) {
            try {
                jpDbCon.rollback();
            } catch (SQLException e1) {
                //How do you not lose the first SQLException here?
                throw new RollbackFailedException("The program was unable to rollback changes.", e1);
            }

            throw new SqlExecFailedException("Sql statement execution failed.", e);
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
}
