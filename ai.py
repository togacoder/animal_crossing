# -*- coding: utf8 -*-
import socket
import re
import time

BUFSIZE = 1024

def which_turn(s, n):
    s.send(('turn\n').encode())
    time.sleep(1)
    line = s.recv(BUFSIZE).rstrip().decode()
    print(line)
    num = re.search(r'\d', line)
    num = num.group(0) 
    if n == num:
        return True
    else:
        return False

def main():
    serverName = ""
    serverPort = 4444
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect((serverName, serverPort))
    # You are Player(1 or 2).
    playerNum = s.recv(BUFSIZE).rstrip().decode()
    print(playerNum)
    playerNum = re.search(r'\d', playerNum)
    playerNum = playerNum.group(0)
    print(playerNum)

    while True:
        while True:
            if which_turn(s, playerNum):
                break
            time.sleep(1)
        print("Your Turn")

        line = input("")

        if re.match(r"^q*$", line):
            break

        s.send((line + "\n").encode())
        time.sleep(1)
        print(s.recv(BUFSIZE).rstrip().decode())
    
    print("bye")

if __name__ == '__main__':
    main()
