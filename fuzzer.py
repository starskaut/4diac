#!/usr/bin/env python3
"""
Fuzzer that sends mutated data to the vulnerable runtime.
Tries to trigger crashes and generate core dumps.
"""

import socket
import random
import time
import sys

def send_data(data):
    """Send data to the vulnerable runtime server."""
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(2)
        sock.connect(('127.0.0.1', 61499))
        sock.send(data)
        response = sock.recv(1024)
        sock.close()
        return True
    except Exception as e:
        return False

def fuzz():
    """Generate and send fuzzed data."""
    test_num = 0
    
    print("[+] Fuzzer starting...")
    time.sleep(1)
    
    # Test 1: Normal data
    test_num += 1
    print(f"[*] Test {test_num}: Normal payload (32 bytes)")
    send_data(b"A" * 32)
    time.sleep(0.5)
    
    # Test 2: Overflow data (larger than buffer)
    test_num += 1
    print(f"[*] Test {test_num}: Overflow payload (128 bytes) - SHOULD CRASH")
    send_data(b"B" * 128)
    time.sleep(0.5)
    
    # Test 3: Random mutation
    test_num += 1
    print(f"[*] Test {test_num}: Random mutation (96 bytes)")
    random_data = bytes(random.randint(0, 255) for _ in range(96))
    send_data(random_data)
    time.sleep(0.5)
    
    # Test 4: Pattern overflow
    test_num += 1
    print(f"[*] Test {test_num}: Pattern overflow (256 bytes) - SHOULD CRASH")
    pattern = b"\x41\x42\x43\x44" * 64
    send_data(pattern)
    time.sleep(0.5)
    
    # Test 5: All zeros
    test_num += 1
    print(f"[*] Test {test_num}: Null bytes (100 bytes)")
    send_data(b"\x00" * 100)
    time.sleep(0.5)
    
    # Test 6: Maximum size
    test_num += 1
    print(f"[*] Test {test_num}: Maximum payload (1024 bytes) - LIKELY TO CRASH")
    send_data(b"X" * 1024)
    time.sleep(0.5)
    
    print(f"[+] Fuzzing complete. Sent {test_num} tests.")
    print("[+] Check for core dumps and crash reports.")

if __name__ == "__main__":
    fuzz()
