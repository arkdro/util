#!/usr/bin/perl
# read input file with servers info (fields are separated by |)
# xxx.xxx.xxx.xxx|long description|CC|TCP|UDP|
# CC - country code, like us, nl, fi, etc
# choose random server based on the input params
# print result
use strict;
use Data::Dumper;
use Getopt::Long;
use FileHandle;
use vars qw($debug);

sub run {
	my($country, $proto, $string);
	my $infile='-';
	&GetOptions(
	  "i|infile=s" => \$infile,
	  "s|string=s" => \$string, # arbitrary string to search in the desc field
	  "c|country=s" => \$country, # country to choose
	  "p|proto=s" => \$proto,
	  "d|debug:i" => \$debug
	  );
	my $servers = fill($infile, $country, $string);
	return 1 unless $servers;
	return 1 if @$servers < 1;
	my $srv = choose($servers);
	my ($host, $port, $proto2) = get_pars($srv, $proto);
	print STDERR "$host, $port, $proto2\n" if $debug;
	print "remote $host $port\n";
	print "proto $proto2\n";
	return 0;
}

sub choose {
	my($servers) = @_;
	my $idx = int rand scalar @$servers;
	my $srv = $servers->[$idx];
	return $srv;
}

sub fill{
	my($file, $country, $string) = @_;
	my $fd = new FileHandle $file;
	unless($fd){
	  print_log("Can't open input file: '$file': $!\n");
	  return;
	}
	my @srv;
	while(my $str = $fd->getline){
		$str =~ s/[\r\n]+$//;
		my @s = split /\|/, $str;
		next if($country) && ($s[2] ne $country);
		next if($string) && ($s[1] !~ /$string/i);
		next if @s < 5;
		push @srv, \@s
	}
	return \@srv;
}

sub get_pars {
	my($srv, $proto) = @_;
	my $proto2;
	if(lc $proto eq 'tcp' || lc $proto eq 'udp'){
		$proto2 = lc $proto;
	}else{
		if($srv->[4] =~ /UDP/i){
			$proto2 = 'udp';
		}else{
			$proto2 = 'tcp';
		}
	}
	my $port;
	if($proto2 eq 'tcp'){
		$port = 443;
	}else{
		$port = 53;
	}
	return ($srv->[0], $port, $proto2);
}

exit run();

