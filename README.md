munin-statsd
============
A Perl script to send Munin-node data to a StatD instance. As written, this is designed to be run from cron.

Requirements
============

* Munin::Node::Client from CPAN:
```
    cpan Munin::Node::Client
```

* IO::Socket::INET (If you have Perl, you probably already have this)

Configuration
=============
Change `schemabase`, `graphitehost`, and `graphiteport` as appropriate for your environment, and `muninhost` and `muninport` if you're not using this for the local machine.

Installation
============
1. Clone the repository
```
    cd /usr/local/bin
    git clone https://github.com/Tech-Corps/munin-statsd.git
```

2. Make sure munin-graphite.pl is executable
```
    chmod +x munin-stats/munin-statsd.pl
```

3. Create a crontab entry that calls the script
```
    * * * * * /usr/local/bin/munin-statsd/munin-statsd.pl
```
