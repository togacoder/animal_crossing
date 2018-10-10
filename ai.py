# -*- coding: utf8 -*-
import socket
import re
import time

BUFSIZE = 1024

def main():
    serverName = ""
    serverPort = 4444
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect((serverName, serverPort))
    print(s,recv(BUFSIZE).rstrip().decode())
    
    while True:
        line = input("")

        if re,match(r"^q*$", line):
            break

        s.send((line + "\n").encode())
        time.sleep(1)
        print(s.recv(BUFSIZE).rstrip().decode())
    
    print("bye")

if __name__ == '__main__':
    main()
