package com.jp.swing;

import com.jp.JpGui;
import com.jp.RollbackFailedException;
import com.jp.SqlExecFailedException;
import com.jp.SqlStatementExecutionResult;

import javax.swing.*;
import java.awt.*;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;

public class MainMenu {
    public JTabbedPane tabbedPane1;
    public JPanel mainPanel;

    private JComboBox selectAllFromTable;
    private JButton selectAllFromTableButton;
    private JTextField dinoSpeciesTextField;
    private JButton selectEnclosureByDinoSpeciesButton;
    private JTextField dinosaurNameTextField;
    private JTextField enclosureIdTextField;
    private JButton insertNewDinosaurButton;
    private JTextField workerSurnameTextField;
    private JButton insertNewWorkerButton;
    private JTextField workerIdTextField;
    private JTextField dinosaurIdTextField;
    private JButton insertNewWorkerDinoRelationButton;
    private JTextField moneySpenVisitorIdField;
    private JButton moneySpentWhereVisitorButton;
    private JTextField assignWorkerIdTextField;
    private JButton assignDinoToWorkerButton;
    private JTextField dinosaurSpeciesTextField;
    private JTextField assignDinosaurNameField;
    private JTextField assignDinosaurSpeciesField;
    private JTextField assignEnclosureIdField;
    private JComboBox workerSpecialtyCombobox;
    private JTextField setSpecialtyWorkerId;
    private JButton changeWorkerSpecialtyButton;
    private JTextField setEnclosureDinoId;
    private JButton updateDinoEnclosureButton;
    private JComboBox setSpecialtyCombobox;
    private JTextField deleteDinosaurIdField;
    private JButton deleteDinosaurButton;
    private JTextField deleteWorkerIdField;
    private JButton deleteWorkerButton;
    private JTextField setEnclosureEnclosureField;
    private JTextField setEnclosureNewNoDPrice;
    private JTextField setEnclosureNewWDPrice;

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
        selectAllFromTableButton.addMouseListener(new MouseAdapter() {
            @Override
            public void mouseReleased(MouseEvent e) {
                super.mouseReleased(e);
                var tableName = selectAllFromTable.getSelectedItem().toString();
                SqlStatementExecutionResult result;
                try {
                    result = JpGui.dbCommunicator.executeSelectAllFromTableQuery(tableName);
                } catch (RollbackFailedException | SqlExecFailedException e1) {
                    showErrorDialog(e1.getCause().getMessage());
                    return;
                }
                openQueryResultDialog(result);
            }
        });
        selectEnclosureByDinoSpeciesButton.addMouseListener(new MouseAdapter() {
            @Override
            public void mouseReleased(MouseEvent e) {
                super.mouseReleased(e);
                var dinoSpecies = dinoSpeciesTextField.getText();
                SqlStatementExecutionResult result = null;
                try {
                    result = JpGui.dbCommunicator.executeSelectEnclosureByDinoSpecies(dinoSpecies);
                } catch (RollbackFailedException | SqlExecFailedException e1) {
                    showErrorDialog(e1.getCause().getMessage());
                }
                openQueryResultDialog(result);
            }
        });
        moneySpentWhereVisitorButton.addMouseListener(new MouseAdapter() {
            @Override
            public void mouseReleased(MouseEvent e) {
                super.mouseReleased(e);
                int visitorId;

                var visitorIdStr = moneySpenVisitorIdField.getText();
                if (!checkInt(visitorIdStr, "Visitor ID"))
                {
                    return;
                }

                visitorId = Integer.parseInt(visitorIdStr);
                SqlStatementExecutionResult result = null;
                try {
                    result = JpGui.dbCommunicator.executeSelectEnclosureByVisitorId(visitorId);
                } catch (RollbackFailedException | SqlExecFailedException e1) {
                    showErrorDialog(e1.getCause().getMessage());
                }
                openQueryResultDialog(result);
            }
        });
        insertNewDinosaurButton.addMouseListener(new MouseAdapter() {
            @Override
            public void mouseReleased(MouseEvent e) {
                super.mouseReleased(e);
                var name = dinosaurNameTextField.getText();
                var species = dinosaurSpeciesTextField.getText();
                var enclosureIdText = enclosureIdTextField.getText();
                if (!checkInt(enclosureIdText, "Enclosure ID"))
                {
                    return;
                }
                var enclosureId = Integer.parseInt(enclosureIdText);

                try
                {
                    var result = JpGui.dbCommunicator.executeInsertNewDino(name, species, enclosureId);
                }
                catch (SqlExecFailedException | RollbackFailedException exc)
                {
                    showErrorDialog(exc.getCause().getMessage());
                }
            }
        });

        insertNewWorkerButton.addMouseListener(new MouseAdapter() {
            @Override
            public void mouseReleased(MouseEvent e) {
                super.mouseReleased(e);
                var workerSpecialty = (String) workerSpecialtyCombobox.getSelectedItem();
                var workerSurname = workerSurnameTextField.getText();

                try {
                    JpGui.dbCommunicator.executeInsertNewWorker(workerSpecialty, workerSurname);
                } catch (RollbackFailedException | SqlExecFailedException e1) {
                    showErrorDialog(e1.getCause().getMessage());
                }
            }
        });

        insertNewWorkerDinoRelationButton.addMouseListener(new MouseAdapter() {
            @Override
            public void mouseReleased(MouseEvent e) {
                super.mouseReleased(e);
                var workerIdText = workerIdTextField.getText();
                if (!checkInt(workerIdText, "Worker ID"))
                {
                    return;
                }
                var workerId = Integer.parseInt(workerIdText);

                var dinoIdText = dinosaurIdTextField.getText();
                if (!checkInt(dinoIdText, "Dino ID"))
                {
                    return;
                }
                var dinoId = Integer.parseInt(dinoIdText);

                try {
                    JpGui.dbCommunicator.executeNewWorkerDinoRelation(workerId, dinoId);
                } catch (RollbackFailedException | SqlExecFailedException e1) {
                    showErrorDialog(e1.getCause().getMessage());
                }
            }
        });

        assignDinoToWorkerButton.addMouseListener(new MouseAdapter() {
            @Override
            public void mouseReleased(MouseEvent e) {
                super.mouseReleased(e);

                var name = assignDinosaurNameField.getText();
                var species = assignDinosaurSpeciesField.getText();
                var enclosureIdText = assignEnclosureIdField.getText();
                if (!checkInt(enclosureIdText, "Enclosure ID"))
                {
                    return;
                }
                var enclosureId = Integer.parseInt(enclosureIdText);

                var workerIdText = assignWorkerIdTextField.getText();
                if (!checkInt(workerIdText, "Worker ID"))
                {
                    return;
                }
                var workerId = Integer.parseInt(workerIdText);

                try {
                    JpGui.dbCommunicator.executeInsertNewDinoAndCaringWorkerStatement(name, species, enclosureId, workerId);
                } catch (RollbackFailedException | SqlExecFailedException e1) {
                    showErrorDialog(e1.getCause().getMessage());
                }
            }
        });
        changeWorkerSpecialtyButton.addMouseListener(new MouseAdapter() {
            @Override
            public void mouseReleased(MouseEvent e) {
                super.mouseReleased(e);
                var specialty = (String) setSpecialtyCombobox.getSelectedItem();

                var workerIdText = setSpecialtyWorkerId.getText();
                if (!checkInt(workerIdText, "Worker ID"))
                {
                    return;
                }
                var workerId = Integer.parseInt(workerIdText);

                try {
                    JpGui.dbCommunicator.executeUpdateWorkerSpecByIdStatement(workerId, specialty);
                } catch (RollbackFailedException | SqlExecFailedException e1) {
                    showErrorDialog(e1.getCause().getMessage());
                }
            }
        });
        updateDinoEnclosureButton.addMouseListener(new MouseAdapter() {
            @Override
            public void mouseReleased(MouseEvent e) {
                super.mouseReleased(e);

                var enclosureIdText = setEnclosureEnclosureField.getText();
                if (!checkInt(enclosureIdText, "Enclosure ID"))
                {
                    return;
                }
                var enclosureId = Integer.parseInt(enclosureIdText);

                var dinoIdText = setEnclosureDinoId.getText();
                if (!checkInt(dinoIdText, "Dino ID"))
                {
                    return;
                }
                var dinoId = Integer.parseInt(dinoIdText);

                var newNoDCostText = setEnclosureNewNoDPrice.getText();
                if (!checkDouble(newNoDCostText, "New Cost without Discount"))
                {
                    return;
                }
                var newNoDCost = Double.parseDouble(newNoDCostText);

                var newWithDCostText = setEnclosureNewWDPrice.getText();
                if (!checkDouble(newWithDCostText, "New Cost with Discount"))
                {
                    return;
                }

                var newWithDCost = Double.parseDouble(newWithDCostText);

                try {
                    JpGui.dbCommunicator.executeUpdateEncAndTicketCost(dinoId, enclosureId, newNoDCost, newWithDCost);
                } catch (RollbackFailedException | SqlExecFailedException e1) {
                    showErrorDialog(e1.getCause().getMessage());
                }
            }
        });
        deleteDinosaurButton.addMouseListener(new MouseAdapter() {
            @Override
            public void mouseReleased(MouseEvent e) {
                super.mouseReleased(e);
                var dinoIdText = deleteDinosaurIdField.getText();
                if (!checkInt(dinoIdText, "Dino ID"))
                {
                    return;
                }
                var dinoId = Integer.parseInt(dinoIdText);

                try {
                    JpGui.dbCommunicator.executeDeleteDino(dinoId);
                } catch (RollbackFailedException | SqlExecFailedException e1) {
                    showErrorDialog(e1.getCause().getMessage());
                }
            }
        });
        deleteWorkerButton.addMouseListener(new MouseAdapter() {
            @Override
            public void mouseReleased(MouseEvent e) {
            var workerIdText = deleteWorkerIdField.getText();
            if (!checkInt(workerIdText, "Worker ID"))
            {
                return;
            }
            var workerId = Integer.parseInt(workerIdText);

                try {
                    JpGui.dbCommunicator.executeDeleteWorker(workerId);
                } catch (RollbackFailedException | SqlExecFailedException e1) {
                    showErrorDialog(e1.getCause().getMessage());
                }
            }
        });
    }

    private boolean checkDouble(String text, String message)
    {
        try
        {
            Double.parseDouble(text);
            return true;
        }
        catch (NumberFormatException e1)
        {
            showErrorDialog(message + " must be a double!");
            return false;
        }
    }

    private boolean checkInt(String text, String message) {
        try
        {
            Integer.parseInt(text);
            return true;
        }
        catch (NumberFormatException e1)
        {
            showErrorDialog(message + " must be an integer!");
            return false;
        }
    }
}
