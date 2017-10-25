use strict;
use warnings;
use utf8;
use IO::Socket;
use Data::Dumper;
&main();
exit;

sub violation {
	my ($msg, $log) = @_;
	

}
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
	my $msg = <$sock>;
	print $msg;
	chomp $msg;
	$msg =~ s/\D//g;
	my $player = "Player" . $msg;
	print "$player\n";

	print $sock "initboard\n";
	$msg = <$sock>;
	print "$msg\n";
	my @log;
	push(@log, "start");
	
	#初手
	my $mv;
	my @board;
	if(($log[-1] eq "start")and($player eq "Player1")) {
		(@board) = &make_board($msg);
		$mv = &mv_make($msg);
	}
	while(1) {
		my $mv;
		print $sock "board\n";
		$msg = <$sock>; chomp $msg;	
	}	
	
	close($sock);
	print("bye\n");
}
