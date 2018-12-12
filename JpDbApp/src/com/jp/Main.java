package com.jp;

import com.jcraft.jsch.JSchException;
import com.jp.swing.MainMenu;

import javax.swing.*;
import java.awt.*;

public class Main {

    public static JpGui app;

    static {
        app = new JpGui();
        try {
            app.initializeGui();
        } catch (JSchException e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) throws JSchException {
        try {
            for (var info : UIManager.getInstalledLookAndFeels()) {
                if ("Nimbus".equals(info.getName())) {
                    UIManager.setLookAndFeel(info.getClassName());
                    break;
                }
            }
        }
        catch (UnsupportedLookAndFeelException | ClassNotFoundException | IllegalAccessException | InstantiationException e) {
            // ignore
        }

        var root = new JFrame("Jurassic Park PSQL");
        var menu = new MainMenu().mainPanel;
        root.setVisible(true);
        root.add(menu);
        root.setPreferredSize(new Dimension(300, 200));
        root.pack();
    }
}
