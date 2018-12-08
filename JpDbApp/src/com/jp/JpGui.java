package com.jp;

import com.jcraft.jsch.JSchException;

import java.util.LinkedList;

public class JpGui {
    public void initializeGui() throws JSchException {
        System.out.println("Welcome!");
        var dbCommunicator = new JpDbCommunicator();
        var dinos = dbCommunicator.getSelectDinoByEnclosureQuery(2);
        var results = dbCommunicator.executeSqlStatement(dinos);
        for (String column : results.columnNames){
            System.out.print(column + "\t | \t");
        }
        for (LinkedList<String> row : results.resultList){
            for (String data : row){
                System.out.print(data + "\t | \t");
            }
            System.out.println();
        }
        dbCommunicator.closeConnection();
    }
}

