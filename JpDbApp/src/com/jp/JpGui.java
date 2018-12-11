package com.jp;

import com.jcraft.jsch.JSchException;

import java.util.LinkedList;

public class JpGui {
    public static JpDbCommunicator dbCommunicator;

    public void initializeGui() throws JSchException {
        LinkedList<SqlStatementExecutionResult> queryResults = null;

        System.out.println("Welcome!");
        System.out.println("Connecting to database...");

        dbCommunicator = new JpDbCommunicator();

        var enclosureQuery = dbCommunicator.getSelectEnclosureByDinoSpeciesQuery("Velociraptor");
        var dinoQuery = dbCommunicator.getSelectAllFromTableQuery("Dinosaur");
        var workerQuery = dbCommunicator.getSelectWorkerBySpecialtyQuery("Cleaner");
        var enclosureByVisitorQuery = dbCommunicator.getSelectEnclosureByVisitorIdQuery(9);

        //queryResults = dbCommunicator.executeInsertNewDinoAndCaringWorkerStatement("Johnnyey", "Dogosaurus", 3, 6);

//        for (SqlStatementExecutionResult result : queryResults){
//            for (String column : result.columnNames){
//                System.out.print(column + "\t | \t");
//            }
//            System.out.println();
//
//            for (LinkedList<String> row : result.resultList){
//                for (String data : row){
//                    System.out.print(data + "\t | \t");
//                }
//                System.out.println();
//            }
//            System.out.println("----------------------");
//        }

        //dbCommunicator.closeConnection();
    }
}

