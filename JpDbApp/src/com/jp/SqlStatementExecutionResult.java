package com.jp;

import java.util.LinkedList;

public class SqlStatementExecutionResult {
    public LinkedList<LinkedList<String>> resultList;
    public LinkedList<String> columnNames;
    public int updateCount;

    SqlStatementExecutionResult(){
        resultList = new LinkedList<LinkedList<String>>();
        columnNames = new LinkedList<String>();
    }
}
