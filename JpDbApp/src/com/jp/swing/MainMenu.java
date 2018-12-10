package com.jp.swing;

import com.jp.JpGui;
import com.jp.SqlStatementExecutionResult;

import javax.swing.*;
import java.awt.*;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;

public class MainMenu {
    public JTabbedPane tabbedPane1;
    private JComboBox selectAllFromTable;
    private JButton selectAllFromTableButton;
    private JTextField dinoSpeciesTextField;
    private JButton selectEnclosureByDinoSpeciesButton;
    private JTextField dinosaurNameTextField;
    private JTextField enclosureIdTextField;
    private JButton insertNewDinosaurButton;
    private JTextField workerSpecialtyTextField;
    private JTextField workerSurnameTextField;
    private JButton insertNewWorkerButton;
    private JTextField workerIdTextField;
    private JTextField dinosaurIdTextField;
    private JButton insertNewWorkerDinoRelationButton;
    private JTextField moneySpenVisitorIdField;
    private JButton moneySpentWhereVisitorButton;
    private JButton dinoButton;

    public void openQueryResultDialog(SqlStatementExecutionResult result)
    {
        var table = new JTable(result);
        var scrollPane = new JScrollPane(table);

        var jdialog = new JDialog();
        jdialog.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        jdialog.setContentPane(scrollPane);

        jdialog.setSize(400, 250);
        jdialog.setPreferredSize(new Dimension(400, 250));
        jdialog.setVisible(true);
    }

    public void showErrorDialog(String message)
    {
        JOptionPane.showMessageDialog(this.tabbedPane1, message, "Error", JOptionPane.ERROR_MESSAGE);
    }

    public MainMenu() {
//        dinoButton.addMouseListener(new MouseAdapter() {
//            @Override
//            public void mouseReleased(MouseEvent e) {
//                super.mouseReleased(e);
//                var query = Main.app.dbCommunicator.getSelectDinoByEnclosureQuery(2);
//                SqlStatementExecutionResult result = null;
//                try {
//                    result = Main.app.dbCommunicator.executeSqlStatement(query, true);
//                } catch (SqlExecFailedException | RollbackFailedException e1) {
//                    e1.printStackTrace();
//                }
//
//                var table = new JTable(result);
//                var scrollPane = new JScrollPane(table);
//
//                var jdialog = new JDialog();
//                jdialog.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
//                jdialog.setContentPane(scrollPane);
//
//                jdialog.setSize(200, 200);
//                jdialog.setPreferredSize(new Dimension(200, 200));
//                jdialog.setVisible(true);
//
//            }
//        });
        selectAllFromTableButton.addMouseListener(new MouseAdapter() {
            @Override
            public void mouseReleased(MouseEvent e) {
                super.mouseReleased(e);
                var tableName = selectAllFromTable.getSelectedItem().toString();
                var result = JpGui.dbCommunicator.executeSelectAllFromTableQuery(tableName);
                openQueryResultDialog(result);
            }
        });
        selectEnclosureByDinoSpeciesButton.addMouseListener(new MouseAdapter() {
            @Override
            public void mouseReleased(MouseEvent e) {
                super.mouseReleased(e);
                var dinoSpecies = dinoSpeciesTextField.getText();
                var result = JpGui.dbCommunicator.executeSelectEnclosureByDinoSpecies(dinoSpecies);
                openQueryResultDialog(result);
            }
        });
        moneySpentWhereVisitorButton.addMouseListener(new MouseAdapter() {
            @Override
            public void mouseReleased(MouseEvent e) {
                super.mouseReleased(e);
                int visitorId;
                try
                {
                    visitorId = Integer.parseInt(moneySpenVisitorIdField.getText());
                }
                catch (NumberFormatException e1)
                {
                    showErrorDialog("Visitor ID must be ant integer!");
                    return;
                }
                var result = JpGui.dbCommunicator.executeSelectEnclosureByVisitorId(visitorId);
                openQueryResultDialog(result);
            }
        });
    }
}
