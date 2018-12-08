package com.jp;

import java.util.LinkedList;

public class QueryExecutionResult {
    public LinkedList<LinkedList<String>> resultList;
    public int updateCount;

    QueryExecutionResult(){
        resultList = new LinkedList<LinkedList<String>>();
    }
}
