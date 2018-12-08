package com.jp;

import com.jcraft.jsch.JSch;
import com.jcraft.jsch.JSchException;

public class Main {
    public static void main(String[] args) throws JSchException {
        JpGui app = new JpGui();
        app.initializeGui();
    }
}
