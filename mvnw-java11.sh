#!/bin/bash
# Maven wrapper script to use Java 11 for ysoserial project
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk
mvn "$@"
