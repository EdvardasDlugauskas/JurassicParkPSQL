package com.jp;

import java.util.LinkedList;

public class JpGui {
    public void initializeGui(){
        System.out.println("Welcome!");
        System.out.println("Connecting to database...");
        var dbCommunicator = new JpDbCommunicator();
        var dinos = dbCommunicator.getSelectDinoByEnclosureQuery(2);
        var results = dbCommunicator.executeSqlStatement(dinos).resultList;
        for (LinkedList<String> row : results){
            for (String data : row){
                System.out.print(data + "\t | \t");
            }
            System.out.println();
        }
        dbCommunicator.closeConnection();
    }
}

