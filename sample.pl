use strict;
use warnings;
use utf8;
use Socket;

&main();
exit;

sub main {
	my $tcpPortNo = getprotobyname('tcp');
	socket(SOCKET, PF_INET, SOCK_STREAM, $tcpPortNo) or die("socket() fail:$!\n");
	my $address = sockaddr_in(4444, inet_aton("10.2.72.184"));
	connect(SOCKET, $address) or die("connect() fail:$!\n");
	my $msg = <SOCKET>;
	chomp $msg;
	print "$msg\n";
	
	while(1) {
		my $input = <>;
		 last if($input =~ m/^q\s*$/);
		
		my $msg = <SOCKET>;
		print $msg;
	}

	print("bye\n");
}
