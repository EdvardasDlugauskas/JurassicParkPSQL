package com.jp;

import java.util.LinkedList;

public class JpGui {
    public void initializeGui(){
        SqlStatementExecutionResult queryResults = null;

        System.out.println("Welcome!");
        System.out.println("Connecting to database...");

        var dbCommunicator = new JpDbCommunicator();
        var dinoQuery = dbCommunicator.getSelectDinoByEnclosureQuery(2);

        try {
            queryResults = dbCommunicator.executeSqlStatement(dinoQuery);
        }
        catch (SqlExecFailedException e) {
            e.printStackTrace();
            System.out.println(e.getMessage());
        }
        catch (RollbackFailedException e) {
            e.printStackTrace();
            System.out.println(e.getMessage());
        }

        if (queryResults != null){

            for (String column : queryResults.columnNames){
                System.out.print(column + "\t | \t");
            }
            System.out.println();

            for (LinkedList<String> row : queryResults.resultList){
                for (String data : row){
                    System.out.print(data + "\t | \t");
                }
                System.out.println();
            }
        }

        dbCommunicator.closeConnection();
    }
}

