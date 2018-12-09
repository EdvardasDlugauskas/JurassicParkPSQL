package com.jp;

import com.jcraft.jsch.JSchException;

public class JpGui {
    public static JpDbCommunicator dbCommunicator;

    public void initializeGui() throws JSchException {
        SqlStatementExecutionResult queryResults = null;

        System.out.println("Welcome!");
        System.out.println("Connecting to database...");

        dbCommunicator = new JpDbCommunicator();
        var dinoQuery = dbCommunicator.getSelectEnclosureByDinoSpeciesQuery("Velociraptor");

        try {
            queryResults = dbCommunicator.executeSqlStatement(dinoQuery);
        }
        catch (SqlExecFailedException | RollbackFailedException e) {
            e.printStackTrace();
            System.out.println(e.getMessage());
        }

        if (queryResults != null){

            for (var column : queryResults.columnNames){
                System.out.print(column + "\t | \t");
            }
            System.out.println();

            for (var row : queryResults.resultList){
                for (var data : row){
                    System.out.print(data + "\t | \t");
                }
                System.out.println();
            }
        }

        // Don't close since it's still needed for the actual GUI
        //dbCommunicator.closeConnection();
    }
}

