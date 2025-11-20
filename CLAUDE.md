# YSOSerial Project Documentation

## Overview

YSOSerial is a Java deserialization payload generator tool for security testing and research. It generates serialized objects that exploit various Java deserialization vulnerabilities using different gadget chains.

## Helper Scripts

### mvnw-java11.sh

Maven wrapper script that uses Java 11 for building the project.

**Usage:**

```bash
./mvnw-java11.sh clean install -DskipTests
```

**Purpose:**

- Sets JAVA_HOME to `/usr/lib/jvm/java-11-openjdk`
- Runs Maven commands with Java 11
- Required for building the project as some dependencies need Java 11

### ysoserial.sh

Wrapper script to run the built ysoserial JAR with Java 11.

**Usage:**

```bash
./ysoserial.sh [payload-type] [command]
```

**Example:**

```bash
./ysoserial.sh CommonsCollections1 "calc"
```

**Purpose:**

- Simplifies running ysoserial without typing the full java -jar command
- Automatically uses Java 11 from `/usr/lib/jvm/java-11-openjdk`
- Points to the built JAR at `target/ysoserial-0.0.6-SNAPSHOT-all.jar`

## Building the Project

1. Install dependencies and build (skipping tests):

```bash
./mvnw-java11.sh clean install -DskipTests
```

2. The built JAR will be located at:
    - `target/ysoserial-0.0.6-SNAPSHOT-all.jar` (with all dependencies)
