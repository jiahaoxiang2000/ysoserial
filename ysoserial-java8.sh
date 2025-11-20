#!/bin/bash
# Wrapper script to run ysoserial with Java 8
# Use this for payloads that require Java 8 (like CommonsCollections1)

JAVA8_HOME="/usr/lib/jvm/java-8-openjdk"

if [ ! -d "$JAVA8_HOME" ]; then
    echo "ERROR: Java 8 not found at $JAVA8_HOME"
    echo "Please install Java 8 first."
    exit 1
fi

$JAVA8_HOME/bin/java -jar "$(dirname "$0")/target/ysoserial-0.0.6-SNAPSHOT-all.jar" "$@"
