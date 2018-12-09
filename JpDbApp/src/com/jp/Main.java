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
        var root = new JFrame("Jurassic Park PSQL");
        var menu = new MainMenu().tabbedPane1;
        root.setVisible(true);
        root.add(menu);
        root.setPreferredSize(new Dimension(200, 200));
        root.pack();
    }
}
