#!/bin/bash
# Wrapper script to run ysoserial with Java 11
/usr/lib/jvm/java-11-openjdk/bin/java -jar "$(dirname "$0")/target/ysoserial-0.0.6-SNAPSHOT-all.jar" "$@"
