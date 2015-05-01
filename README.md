VHS_NET
=======

VHS_NET is a little messageboard/bbs app written in Sinatra and meant to run on a Raspberry Pi.

It uses the [BOOTSTRAP.386](http://kristopolous.github.io/BOOTSTRA.386/) css/js library.

After `git clone`ing the repo and running `bundle install`, you'll need to set up an initial user:

    $ irb
    :001 > require './main'
    :002 > DataMapper.auto_migrate!
    :003 > u = User.new
    :004 > u.username = <YOUR_USERNAME>
    :005 > u.password = <YOUR_PASSWORD>
    :006 > u.save

Then, fire it up and login! If it's hosted on a Raspberry Pi for your local network, you'll need to add a line in `main.rb` to bind it to an IP accessible by other web browsers on your network. [Sinatra's Configuring Settings page](http://www.sinatrarb.com/configuration.html) has the necessary instructions for setting the bind, and [this doc on the Raspberry Pi site](https://www.raspberrypi.org/documentation/troubleshooting/hardware/networking/ip-address.md) explains how to find your Pi's IP address.

It's still very much under construction.

VHS_NET is licensed under the [GNU GPL](https://github.com/kellyi/vhs_net/blob/master/LICENSE).
