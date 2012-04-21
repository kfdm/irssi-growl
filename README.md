# GNTP Growl plugin for irssi

## ORIGINAL
Irssi growl script taken from [here](http://axman6.homeip.net/blog/growl-net-irssi-script-its-back.html)

## Installing

irssi-growl has two main dependencies that you will need to install from CPAN

    cpan IO::Socket::PortState Growl::GNTP

Some dependencies are better installed through your distro. For example with CentOS

    yum install uuid-perl perl-Digest-SHA

Assuming you cloned into ~/.irssi/scripts you would then want to load the plugin in irssi

    /script load irssi-growl/growl-net.pl

and set `growl_net_client` and `growl_net_password`

    /set growl_net_client <Address of the computer receiving growl messages>
    /set growl_net_pass <Password on receiving computer>

If you want to write those settings to your config file, make sure to save.

    /save

Lastly you want to send the registration message to Growl and sending a test message to verify everything is setup properly.

    /growl-register
    /gn-test

## Usage

Most of the settings can be viewed from within irssi

    /growl-net
    Irssi: Growl-net can be configured with these settings:
    ...

Whenever you change the `growl_net_*` properties you will need to "reregister" for
it to properly showup on the receiving computer

    /set growl_net_app new app title
    /set growl_net_pass newpassword
    /set growl_net_icon http://example.com/icon.png
    /growl-register


## Notification Settings

### `growl_show_privmsg`
(ON/OFF/TOGGLE) Send a notification on private messages

### `growl_reveal_privmsg`
(ON/OFF/TOGGLE) Reveal the content of private messages in notifications

### `growl_show_hilight`
(ON/OFF/TOGGLE) Send a notification when your name is hilighted

### `growl_show_topic`
(ON/OFF/TOGGLE) Send a notification when the topic for a channel changes

### `growl_show_notify`
(ON/OFF/TOGGLE) Send a notification when someone on your away list joins or leaves

## Network Settings

### `growl_net_client`
Set to the hostname you want to send notifications to

On a Mac network this may be computer.local

### `growl_net_port`
The port on the destination computer

### `growl_net_name`
The name of the computer running irssi

### `growl_net_pass`
The growl password of the destination computer

### `growl_auto_register`
(ON/OFF/TOGGLE) Send a growl registration message automatically when the script is loaded

## Sticky Settings

### `growl_net_sticky`
(ON/OFF/TOGGLE) Set all messages to be sticky or not

### `growl_net_sticky_away`
(ON/OFF/TOGGLE) Set messages to sticky when set to away
