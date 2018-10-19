# -*- coding: utf8 -*-
import socket
import re
import time

BUFSIZE = 1024

serverName = "localhost"
serverPort = 4444
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((serverName, serverPort))

def which_turn(n):
    s.send(('turn\n').encode())
    time.sleep(1)
    line = s.recv(BUFSIZE).rstrip().decode()
    print(line)
    num = re.search(r'\d', line)
    if(num == None):
        return False
    else:
        num = num.group(0) 
        if n == num:
            return True
        else:
            return False

def get_board():
    board_list = list()
    board_dict = dict()

    s.send(("board\n").encode())
    time.sleep(1)
    board_str = s.recv(BUFSIZE).rstrip().decode()
    
    for board_list in board_str.split(','):
        board_list = board_list.strip()
        if board_list != '':
            place_piece = board_list.split(' ')
            board_dict[place_piece[0]] = place_piece[1]

    return board_dict
    

def can_move(num, board_dict):
    can_list = list()
    board_can = list() 
    # 動かせる駒はnumと同じ駒
    for place, piece in board_dict.items():
        print(place + ": " + piece)
        if piece != '--':
            lw = list(place) # lw[0]: A-E, lw[1]: 1-6
            l_list = list()
            w_list = list()
            l_list = lengths(lw[0], lw[1])
            w_list = widths(lw[0])
            for l in l_list:
                for w in w_list:
                    if piece == 'l' + num:
                        can_list.append([place, w + l])
                    elif piece == 'g' + num:
                        if lw[0] == 'D' or lw[0] == 'E':
                            can_list.append([place, w + l])
                        else:
                            if lw[0] == w or lw[1] == l:
                                can_list.append([place, w + l])
                    elif piece == 'e' + num:
                        if lw[0] == 'D' or lw[0] == 'E':
                            can_list.append([place, w + l])
                        else:
                            if lw[0] != w and lw[1] != l:
                                can_list.append([place, w + l])
                    elif piece == 'c' + num:
                        if lw[0] == 'D' or lw[0] == 'E':
                            can_list.append([place, l + w])
                        elif num == '1' and int(l) + 1 == int(lw[1]) and w == lw[0]:
                            can_list.append([place, w + l])
                        elif num == '2' and int(l) - 1 == int(lw[1]) and w == lw[0]:
                            can_list.append([place, w + l])
                    elif piece == 'h' + num:
                        if num == '1' and lw[0] != w and int(lw[1]) != int(l) - 1:
                            can_list.append([place, w + l])
                        elif num == '2' and lw[0] != w and int(lw[1]) != int(l) + 1:
                            can_list.append([place, w + l])

    board_can = check_mv(can_list, board_dict)

    print('board_can')
    print(board_can)
    return board_can

def check_mv(c_list, b_dict):
    board_can = list()
    for mv in c_list:
        v0 = re.search('\d', b_dict[mv[0]])[0]
        v1 = re.search('\d', b_dict[mv[1]])
        if v1 != None:
            v1 = v1[0]
        else:
            v1 = 0

        if re.match('[DE]', mv[0]) and b_dict[mv[1]] == '--' or v0 != v1:
            board_can.append(mv) 
    
    return board_can

def lengths(width, length):
    length_list = list()

    if width != 'D' and width != 'E':
        if length == '1':
            length_list = ['1', '2']
        elif length == '2':
            length_list = ['1', '2', '3']
        elif length == '3':
            length_list = ['2', '3', '4']
        elif length == '4':
            length_list = ['3', '4']
    else:
        length_list = ['1', '2', '3', '4']
    
    return length_list

def widths(width):
    width_list = list()
    if width == 'A':
        width_list = ['A', 'B']
    elif width == 'B' or width == 'D' or width == 'E':
        width_list = ['A', 'B', 'C']
    elif width == 'C':
        width_list = ['B', 'C']

    return width_list
    
def main():
    board_dict = dict()
    board_can = list()
    enemyNum = ''

    # You are Player(1 or 2).
    playerNum = s.recv(BUFSIZE).rstrip().decode()
    print(playerNum)
    playerNum = re.search(r'\d', playerNum)
    playerNum = playerNum.group(0)
    print(playerNum)

    if playerNum == 1:
        enemyNum = 2
    else:
        enemyNum = 1

    while True:
        while True:
            if which_turn(playerNum):
                break
            time.sleep(1)
        print("Your Turn")

        # 盤面を読み取る
        board_dict = get_board()
        print('baord_dict')
        print(board_dict)
        # 打てる手を探す
        can_move(playerNum, board_dict) 

        line = input("")

        if re.match(r"^q*$", line):
            break

        s.send((line + "\n").encode())
        time.sleep(1)
        print(s.recv(BUFSIZE).rstrip().decode())
    
    print("bye")

if __name__ == '__main__':
    main()
