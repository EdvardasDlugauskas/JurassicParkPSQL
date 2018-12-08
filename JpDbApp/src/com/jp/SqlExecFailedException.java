package com.jp;

public class SqlExecFailedException extends Exception {
    SqlExecFailedException(String errorMessage, Throwable rootException){
        super(errorMessage, rootException);
    }
}
