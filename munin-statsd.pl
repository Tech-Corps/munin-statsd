#!/usr/bin/perl -w

#
# munin-statsd.pl
# 
# A Munin-Node to StatsD bridge
#
#    Author:: Brian Staszewski (<brian.staszewski@tech-corps.com>)
# Copyright:: Copyright (c) 2012 Tech-Corps, Inc.
#   License:: GNU General Public License version 2 or later
# 
# This program and entire repository is free software; you can
# redistribute it and/or modify it under the terms of the GNU 
# General Public License as published by the Free Software 
# Foundation; either version 2 of the License, or any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
# 

use warnings;
use strict;

use Munin::Node::Client;
use IO::Socket::INET;

# Configuration
my $schemabase		= "node.";
my $statsdhost		= "statsd.company.com";
my $statsdport		= 8125;
my $muninhost		= "localhost";
my $muninport		= 4949;
my $timeout             = 10;

$SIG{ALRM} = sub { die "Timeout reached.\n" };
alarm $timeout;


$|++;

my $node = Munin::Node::Client->connect(host => $muninhost,
										port => $muninport);

my $version		= $node->version;
my @hostnames	= $node->nodes;
my $fqdn		= join(".", reverse(split(/\./, $hostnames[0])));
my @plugins		= $node->list();

my $statsd_sock	= new IO::Socket::INET (
	PeerAddr	=> $statsdhost.':'.$statsdport,
	Proto		=> 'udp'
) or die "Error creating socket to statsd!\n";

my $packet = "";

foreach my $plugin (@plugins) {
	my %data = $node->fetch($plugin);
	foreach my $stat (keys %data) {
		$packet .= $schemabase."$fqdn.$plugin.$stat:".$data{$stat}."|g\n";
	}
}

$statsd_sock->send($packet);

$statsd_sock->close();
$node->quit;
