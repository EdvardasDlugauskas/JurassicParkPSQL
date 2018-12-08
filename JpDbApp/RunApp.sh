#!/bin/sh
export CLASSPATH=$CLASSPATH:/usr/share/java/postgresql.jar
javac -cp out -d out src/com/jp/Main.java src/com/jp/JpDbCommunicator.java src/com/jp/JpGui.java src/com/jp/QueryExecutionResult.java
java -cp out production/com/jp/Main