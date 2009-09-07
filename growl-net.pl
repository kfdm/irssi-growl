#!/usr/bin/env perl -w
#
# This is a simple irssi script to send out Growl notifications ovet the network using
# Net::Growl. Currently, it sends notifications when your name is
# highlighted, and when you receive private messages.
# Based on the original growl script by Nelson Elhage and Toby Peterson.

use strict;
use vars qw($VERSION %IRSSI $AppName $GrowlHost $GrowlPass $GrowlServ $Sticky $testing $growl $GrowlIcon);

use Irssi;
use Growl::GNTP;

$VERSION = '0.03b1';
%IRSSI = (
	authors		=>	'Alex Mason, Jason Adams (based on the growl.pl script from Growl.info by Nelson Elhage and Toby Peterson)',
	contact		=>	'axman6@gmail.com, kd on irc.freenode.net, (Hanji@users.sourceforge.net, toby@opendarwin.org)',
	name		=>	'growl-net',
	description	=>	'Sends out Growl notifications over the netwotk or internet for Irssi',
	license		=>	'BSD',
	url			=>	'http://axman6.homeip.net/blog/growl-net-irssi-script/ ,http://growl.info/',
);

sub cmd_growl_net {
	Irssi::print('%G>>%n Growl-net can be configured with these settings:');
	Irssi::print('%G>>%n growl_show_privmsg : Notify about private messages.');
	Irssi::print('%G>>%n growl_show_hilight : Notify when your name is hilighted.');
	Irssi::print('%G>>%n growl_show_notify : Notify when someone on your away list joins or leaves.');
	Irssi::print('%G>>%n growl_net_client : Set to the hostname you want to recieve notifications on.');
	Irssi::print('%R>>>>>>%n (computer.local for a Mac network. Your \'localhost\').'); 
	Irssi::print('%G>>%n growl_net_server : Set to the name you want to give the machine irssi is running on. (remote)');
	Irssi::print('%G>>%n growl_net_pass : Set to your destination\'s Growl password. (Your machine)');
	Irssi::print('%G>>%n growl_net_sticky : Whether growls are sticky or not (ON/OFF/TOGGLE)');
	Irssi::print('%G>>%n growl_net_sticky_away : Sets growls to sticky when away (ON/OFF/TOGGLE)');
}

sub cmd_growl_net_test {
	set_sticky();
	
	$growl->notify(
		Event => "Private Message",
		Title => "Test:",
		Message => "This is a test.\n AppName = $AppName \n GrowlHost = $GrowlHost \n GrowlServ = $GrowlServ \n Sticky = $Sticky\n Away = $testing",
		Sticky => "$Sticky",
		Priority => 0,
	);
} 

Irssi::settings_add_bool($IRSSI{'name'}, 'growl_show_privmsg', 1);
Irssi::settings_add_bool($IRSSI{'name'}, 'growl_show_hilight', 1);
Irssi::settings_add_bool($IRSSI{'name'}, 'growl_show_notify', 1);
Irssi::settings_add_str($IRSSI{'name'}, 'growl_net_pass', 'password');
Irssi::settings_add_str($IRSSI{'name'}, 'growl_net_client', 'localhost');
Irssi::settings_add_str($IRSSI{'name'}, 'growl_net_server', 'local');
Irssi::settings_add_str($IRSSI{'name'}, 'growl_net_icon', '');
Irssi::settings_add_bool($IRSSI{'name'}, 'growl_net_sticky', 0);
Irssi::settings_add_bool($IRSSI{'name'}, 'growl_net_sticky_away', 0);


$GrowlHost 	= Irssi::settings_get_str('growl_net_client');
$GrowlPass 	= Irssi::settings_get_str('growl_net_pass');
$GrowlServ 	= Irssi::settings_get_str('growl_net_server');
$GrowlIcon 	= Irssi::settings_get_str('growl_net_icon');

$AppName	= "irssi $GrowlServ";


$growl = Growl::GNTP->new(
	AppName => $AppName,
	PeerHost => $GrowlHost,
	Password => $GrowlPass,
	AppIcon => $GrowlIcon,
);

$growl->register([
	{ Name => "Private Message", },
	{ Name => "Hilight", },
	{ Name => "Join", },
	{ Name => "Part", },
]);

sub sig_message_private ($$$$) {
	return unless Irssi::settings_get_bool('growl_show_privmsg');

	my ($server, $data, $nick, $address) = @_;
	
	set_sticky();
	
	$growl->notify(
		Event => "Private Message",
		Title => "$nick",
		Message => "$data",
		Priority => 0,
		Sticky => "$Sticky",
	);
}

sub sig_print_text ($$$) {
	return unless Irssi::settings_get_bool('growl_show_hilight');

	my ($dest, $text, $stripped) = @_;
	
	set_sticky();
	
	if ($dest->{level} & MSGLEVEL_HILIGHT) {
		
		$growl->notify(
			Event => "Hilight",
			Title => "$dest->{target}",
			Message => "$stripped",
			Priority => 0,
			Sticky => "$Sticky",
		);
	}
}

sub sig_notify_joined ($$$$$$) {
	return unless Irssi::settings_get_bool('growl_show_notify');
	
	my ($server, $nick, $user, $host, $realname, $away) = @_;
	
	set_sticky();
	
	$growl->notify(
		Event => "Join",
		Title => "$realname" || "$nick",
		Message => "<$nick!$user\@$host>\nHas joined $server->{chatnet}",
		Priority => 0,
		Sticky => "$Sticky",
	);
}

sub sig_notify_left ($$$$$$) {
	return unless Irssi::settings_get_bool('growl_show_notify');
	
	my ($server, $nick, $user, $host, $realname, $away) = @_;
	
	set_sticky();
	
	$growl->notify(
		Event => "Part",
		Title => "$realname" || "$nick",
		Message => "<$nick!$user\@$host>\nHas left $server->{chatnet}",
		Priority => 0,
		Sticky => "$Sticky",
	);
}

sub set_sticky {
	my ($server);
	$server = Irssi::active_server();
	
	if (Irssi::settings_get_bool('growl_net_sticky_away')) {
		if (!$server->{usermode_away}) {
			$Sticky = 0;
			
		} else {
			$Sticky = 1;
			
		}
			# $Sticky = Server{'usermode_away'};
		} else {
		$Sticky = Irssi::settings_get_bool('growl_net_sticky');
	}
}

Irssi::command_bind('growl-net', 'cmd_growl_net');
Irssi::command_bind('gn-test', 'cmd_growl_net_test');

Irssi::signal_add_last('message private', \&sig_message_private);
Irssi::signal_add_last('print text', \&sig_print_text);
Irssi::signal_add_last('notifylist joined', \&sig_notify_joined);
Irssi::signal_add_last('notifylist left', \&sig_notify_left);

Irssi::print('%G>>%n '.$IRSSI{name}.' '.$VERSION.' loaded (/growl-net for help. /gn-test to test.)');
