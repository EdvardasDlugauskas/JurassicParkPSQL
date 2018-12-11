package com.jp;

import javax.swing.table.AbstractTableModel;
import java.util.LinkedList;

public class SqlStatementExecutionResult extends AbstractTableModel {
    public LinkedList<LinkedList<String>> resultList;
    public LinkedList<String> columnNames;
    public int updateCount;

    SqlStatementExecutionResult(){
        resultList = new LinkedList<LinkedList<String>>();
        columnNames = new LinkedList<String>();
    }

    @Override
    public String getColumnName(int col) {
        return columnNames.get(col);
    }


    @Override
    public int getRowCount() {
        return resultList.size();
    }

    @Override
    public int getColumnCount() {
        return columnNames.size();
    }

    @Override
    public Object getValueAt(int i, int i1) {
        return resultList.get(i).get(i1);
    }
}
