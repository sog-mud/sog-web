#!/usr/bin/perl

#####################################################
#
# Copyleft by Max Sokolov aka hOLSe
#
# SoG Home page run script
#
#####################################################


#require 'pl/show.cfg';
chdir 'pl';

$ENV{'REDIRECT_STATUS'} = 200;
$ENV{'REDIRECT_ERROR_NOTES'} = '';

$redirect_url = $ENV{'REDIRECT_URL'};

#print $redirect_url , '<br>';

$redirect_url =~ /\/([^.]+)\..*/;
#print $1 , '<br>';


if ($1 ne '') {
	$ENV{'QUERY_STRING'} = $url_par_section . '=' . $1 . '&' . $ENV{'REDIRECT_QUERY_STRING'};
	$ENV{'CHARSET_SAVED_QUERY_STRING'} = $url_par_section . '=' . $1 . '&' . $ENV{'REDIRECT_CHARSET_SAVED_QUERY_STRING'} if ($ENV{'CHARSET_SAVED_QUERY_STRING'});

};

do 'show.pl';

