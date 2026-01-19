#!/usr/bin/env python3
"""
Mock vulnerable runtime server.
Listens for connections and parses data with intentional vulnerability.
"""

import socket
import sys
import struct

def vulnerable_parse(data):
    """
    Intentionally vulnerable function.
    Does not check buffer size - leads to buffer overflow.
    """
    buffer = bytearray(64)
    
    # Vulnerable: no bounds checking
    for i in range(len(data)):
        buffer[i] = data[i]
    
    return buffer

def handle_client(conn, addr):
    """Handle incoming client connection."""
    print(f"[*] Client connected: {addr}")
    
    try:
        data = conn.recv(1024)
        if data:
            print(f"[*] Received {len(data)} bytes from {addr}")
            
            # This call can crash if data is larger than 64 bytes
            result = vulnerable_parse(data)
            
            # Send response
            conn.send(b"OK\n")
    except Exception as e:
        print(f"[!] Error: {e}")
    finally:
        conn.close()

def main():
    """Start the server."""
    PORT = 61499
    
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    server.bind(('127.0.0.1', PORT))
    server.listen(5)
    
    print(f"[+] Mock runtime listening on {PORT}")
    print(f"[+] Waiting for connections...")
    
    try:
        while True:
            conn, addr = server.accept()
            handle_client(conn, addr)
    except KeyboardInterrupt:
        print("\n[*] Shutting down...")
    finally:
        server.close()

if __name__ == "__main__":
    main()
