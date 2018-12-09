package com.jp.swing;

import com.jp.Main;
import com.jp.RollbackFailedException;
import com.jp.SqlExecFailedException;
import com.jp.SqlStatementExecutionResult;

import javax.swing.*;
import java.awt.*;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;

public class MainMenu {
    public JTabbedPane tabbedPane1;
    private JButton dinoButton;

    public MainMenu() {
        dinoButton.addMouseListener(new MouseAdapter() {
            @Override
            public void mouseReleased(MouseEvent e) {
                super.mouseReleased(e);
                var query = Main.app.dbCommunicator.getSelectDinoByEnclosureQuery(2);
                SqlStatementExecutionResult result = null;
                try {
                    result = Main.app.dbCommunicator.executeSqlStatement(query, true);
                } catch (SqlExecFailedException | RollbackFailedException e1) {
                    e1.printStackTrace();
                }

                var table = new JTable(result);
                var scrollPane = new JScrollPane(table);

                var jdialog = new JDialog();
                jdialog.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
                jdialog.setContentPane(scrollPane);

                jdialog.setSize(200, 200);
                jdialog.setPreferredSize(new Dimension(200, 200));
                jdialog.setVisible(true);

            }
        });
    }
}
