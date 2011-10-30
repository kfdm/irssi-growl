# GNTP Growl plugin for irssi

## ORIGINAL
Irssi growl script taken from [here](http://axman6.homeip.net/blog/growl-net-irssi-script-its-back.html)

## Dependencies

    cpan IO::Socket::PortState Growl::GNTP

## Notification Settings

### `growl_show_privmsg`
(ON/OFF/TOGGLE) Send a notification on private messages

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

### `growl_net_server`
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
