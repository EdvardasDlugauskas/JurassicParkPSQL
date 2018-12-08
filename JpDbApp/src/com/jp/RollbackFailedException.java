package com.jp;

public class RollbackFailedException extends Exception {
    RollbackFailedException(String errorMessage, Throwable rootException){
        super(errorMessage, rootException);
    }
}
