package com.jp;

import java.util.LinkedList;

public class JpGui {
    public void initializeGui(){
        System.out.println("Welcome!");
        System.out.println("Connecting to database...");
        var dbCommunicator = new JpDbCommunicator();
        var allDinos = dbCommunicator.getSelectDinoByEnclosureQuery(2);
        var results = dbCommunicator.executeSqlQuery(allDinos);
        for (LinkedList<String> row : results){
            for (String data : row){
                System.out.print("data");
            }
            System.out.println("");
        }
    }
}
