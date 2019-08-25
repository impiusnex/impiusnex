My personal ebuild repo.

Very specific ebuilds made by me, they might work on your system, feel free to give them a try.

You can add this repo to your gentoo system using layman (with the git USE flag)
Edit the =/etc/layman/layman.cfg= and add =https://github.com/impiusnex/maya-overlay/raw/master/overlay.xml= to the =overlays:= part.

So it looks like this...
: overlays  : http://www.gentoo.org/proj/en/overlays/repositories.xml
:   https://github.com/impiusnex/impiusnex/raw/master/overlay.xml

And then just...
: # layman -L
: # layman -a impiusnex

And make sure to have this at the end of your /etc/make.conf:
: # source /var/lib/layman/make.conf

Or if you just need to use it quick, do it this way: 
: # layman -f -a impiusnex -o https://raw.github.com/impiusnex/impiusnex/master/overlay.xml