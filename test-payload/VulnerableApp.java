import java.io.*;

/**
 * Test class to demonstrate CommonsCollections1 deserialization vulnerability
 *
 * This simulates a vulnerable application that deserializes untrusted data.
 * When it deserializes the CommonsCollections1 payload, it will execute
 * the command embedded in the payload.
 *
 * EDUCATIONAL PURPOSE ONLY - For CTF challenges and authorized security testing
 */
public class VulnerableApp {

    /**
     * Simulates a vulnerable deserialization endpoint
     * In real applications, this could be:
     * - REST API accepting serialized objects
     * - RMI endpoints
     * - JMX consoles
     * - Any code calling ObjectInputStream.readObject() on untrusted data
     */
    public static Object deserialize(byte[] data) throws Exception {
        ByteArrayInputStream bais = new ByteArrayInputStream(data);
        ObjectInputStream ois = new ObjectInputStream(bais);
        Object obj = ois.readObject();
        ois.close();
        return obj;
    }

    /**
     * Deserialize from a file
     */
    public static Object deserializeFromFile(String filename) throws Exception {
        System.out.println("[*] Reading serialized payload from: " + filename);
        FileInputStream fis = new FileInputStream(filename);

        // Java 8 compatible way to read all bytes
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        byte[] buffer = new byte[4096];
        int bytesRead;
        while ((bytesRead = fis.read(buffer)) != -1) {
            baos.write(buffer, 0, bytesRead);
        }
        byte[] data = baos.toByteArray();
        fis.close();

        System.out.println("[*] Payload size: " + data.length + " bytes");
        System.out.println("[*] Attempting deserialization...");

        return deserialize(data);
    }

    public static void main(String[] args) {
        if (args.length < 1) {
            System.out.println("Usage: java VulnerableApp <payload.ser>");
            System.out.println("\nExample:");
            System.out.println("  # Generate payload");
            System.out.println("  ./ysoserial.sh CommonsCollections1 'touch /tmp/pwned' > payload.ser");
            System.out.println("  ");
            System.out.println("  # Test deserialization");
            System.out.println("  java -cp test-payload:target/ysoserial-0.0.6-SNAPSHOT-all.jar VulnerableApp payload.ser");
            System.exit(1);
        }

        String payloadFile = args[0];

        try {
            System.out.println("========================================");
            System.out.println("Vulnerable Deserialization Test");
            System.out.println("========================================");
            System.out.println("Java Version: " + System.getProperty("java.version"));
            System.out.println("Java Vendor: " + System.getProperty("java.vendor"));
            System.out.println("========================================\n");

            Object result = deserializeFromFile(payloadFile);

            System.out.println("[+] Deserialization completed");
            System.out.println("[+] Result type: " + result.getClass().getName());
            System.out.println("\n[!] If the payload was successful, your command should have executed!");

        } catch (Exception e) {
            System.err.println("[!] Deserialization failed with exception:");
            e.printStackTrace();
            System.err.println("\nPossible reasons:");
            System.err.println("  - Java version incompatibility (CommonsCollections1 needs specific versions)");
            System.err.println("  - Missing commons-collections library in classpath");
            System.err.println("  - Payload file corrupted or invalid");
        }
    }
}
