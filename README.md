# Discogs Twitter Bot

this twitter bot iterates through all [discogs](http://discogs.com) releases (well, the first 1000000 ; ) and post every release on twitter under [@lp__bot](http://twitter.com/lp__bot) with 100 seconds delay. To run it on a server i use the handy ruby gem 'daemons'. to start the daemon: `ruby runrun.rb start`
