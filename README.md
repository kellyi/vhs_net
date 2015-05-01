VHS_NET
=======

VHS_NET is a little messageboard/bbs app written in Sinatra and meant to run on a Raspberry Pi.

It uses the [BOOTSTRAP.386](http://kristopolous.github.io/BOOTSTRA.386/) css/js library.

After `git clone`ing the repo and running `bundle install`, you'll need to set up an initial user:

`$ irb`

`:001 > require './main'`

`:002 > DataMapper.auto_migrate!`

`:003 > u = User.new`

`:004 > u.username = <YOUR_USERNAME>`

`:005 > u.password = <YOUR_PASSWORD>`

`:006 > u.save`

Then, fire it up and login!

It's licensed under the GPL.
