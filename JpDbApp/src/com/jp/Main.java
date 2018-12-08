package com.jp;

import com.jcraft.jsch.JSch;
import com.jcraft.jsch.JSchException;

public class Main {
    public static void main(String[] args) {
        JpGui app = new JpGui();

        try {
            app.initializeGui();
        } catch (JSchException e) {
            e.printStackTrace();
            System.out.print(e.getMessage());
            System.exit(1);
        }
    }
}
