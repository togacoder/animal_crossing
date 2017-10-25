use strict;
use warnings;
use utf8;
use IO::Socket;

&main();
exit;

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
	print "$msg\n";
		
	while(1) {
		my $input = <>;
		last if($input eq "exit");
		print $sock $input;
		my $msg = <$sock>;
		print $msg;
	}
	
	close($sock);
	print("bye\n");
}
