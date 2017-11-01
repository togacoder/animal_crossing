use strict;
use warnings;
use utf8;
use IO::Socket;
use Data::Dumper;
&main();
exit;

sub board {
	my ($msg) = @_;
	my @keep = split /\,/, $msg;
	print "@keep\n";
	
	my @board;
	for(my $i = 0; $i <= $#keep; $i += 2) {
		if($keep[$i] =~ /A./) {
			push(@{$board[0]}, $keep[$i + 1]);
		} elsif($keep[$i] =~ /B./) {
			push(@{$board[1]}, $keep[$i + 1]);
		} elsif($keep[$i] =~ /C./) {
			push(@{$board[2]}, $keep[$i + 1]);
		} elsif($keep[$i] =~ /D./) {
			push(@{$board[3]}, $keep[$i + 1]);
		} elsif($keep[$i] =~ /E./) {
			push(@{$board[4]}, $keep[$i + 1]);
		}
	}
	print Dumper @board;
	return (@board);
}
sub c_mv {
	my ($x, $y, $player) = @_;
	#動ける範囲 $x : $list[$i][0], $y : $list[$i][1] $y
	my @list1 = ([0, 1]);
	my @list2 = ([0, -1]);
	my @ans;
	if($player eq "Player1") {
		for(my $i = 0; $i <= $#list1; $i++) {
			#版内に収まるか
			if((0 <= $y + $list1[$i][1])and($y + $list1[$i][1] < 4)) {
				#動く先に自分の駒がないか
				if($board[$y + $list1[$i]][$x] !~ /.1/) {
					#mv $x$y $x'$y'
					push(@ans, ([$x, $y], [$x + $list1[$i][0], $y + $list1[$i][1]]));
				}
			}
		}
	} else {
		for(my $i = 0; $i <= $#list; $i++) {
			#版内に収まるか
			if((0 <= $y + $list2[$i][1])and($y + $list2[$i][1] < 4)) {
				#動く先に自分の駒がないか
				if($board[$y + $list2[$i]][$x] !~ /.2/) {
					#mv $x$y $x'$y'
					push(@ans, ([$x, $y], [$x + $list2[$i][0], $y + $list2[$i][1]]));
				}
			}
		}
	}
	return (@ans);
}

sub g_mv {
}
sub e_mv {
}
sub h_mv {
}
sub l_mv {
}
sub possible {
	#駒の添え字はプレイヤー番号
	my (@board, $player) = @_;
	#着手可能手のリストをpushしていく ([before], [after])
	my @possible_list;
	for(my $i = 0; $i < 4; $i++) {
		for(my $j = 0; $j < 3; $j++) {
			my @list;
			if($palyer eq "Player1") {
				if($board[$i][$j] eq "c1") {
					@list = &c_mv($j, $i, $player, @board);
					push(@possible_list, @list);
				} elsif($baord[$i][$j] eq "g1") {
					
				} elsif($baord[$i][$j] eq "e1") {
				
				} elsif($baord[$i][$j] eq "l1") {
				
				} elsif($baord[$i][$j] eq "h1") {
					
				}
			} else {
				if($board[$i][$j] eq "c2") {
				
				} elsif($baord[$i][$j] eq "g2") {
				
				} elsif($baord[$i][$j] eq "e2") {
				
				} elsif($baord[$i][$j] eq "l2") {
				
				} elsif($baord[$i][$j] eq "h2") {
					
				}
			}
		}
	}
}

sub main {
	print "IP:";
	my $host = <>; chomp $host;
	#print "port:";
	my $port = 4444;
	my $sock = new IO::Socket::INET(
		PeerAddr => $host,
		PeerPort => $port,
		Proto => 'tcp');
 		die "IO::Socket : $!" unless $sock;	
	#connect message
	my $msg = <$sock>;
	print $msg;
	chomp $msg;
	$msg =~ s/\D//g;
	my $player = "Player" . $msg;
	print "$player\n";
	
	#初期盤面
	print $sock "initboard\n";
	$msg = <$sock>;
	print "$msg\n";
	#盤面を記録していく
	my @log;
	push(@log, "start");
	
	#--------------------------------------------------
	my $mv; #sendするmove message
	my @board;
	#初手
	if(($log[-1] eq "start")and($player eq "Player1")) {
		(@board) = &make_board($msg);
		#着手可能手
		$mv = &possible(@board, $player);
		$mv = &mv_make($msg);
	}
	#2手目以降
	while(1) {
		#get board
		print $sock "board\n";
		$msg = <$sock>; chomp $msg;	
	}	
	
	close($sock);
	print("bye\n");
}
