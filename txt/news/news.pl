#!perl

require 'news.cfg';

#use CGI qw/:standard/;
#use CGI::Carp qw(fatalsToBrowser); 
#print "Content-type: text/html;\n\n";



$topic = param('topic');


open FILE, "<$news_data_file" || die "Error: File $data_file not open!";
##flock
@strs = <FILE>;
close FILE;
$count = @strs;
$topic = ($count - 1) if ($topic eq '');

if ($topic eq 'all') {
	for ($i = $count - 1; $i >= 0; $i--) {
		print_topic($strs[$i]);
	};
} else {
	for ($i = $topic ; ($i > $topic - $max_per_page ) && ($i >= 0); $i--) {
		print_topic($strs[$i]);
	};
};

if ($count > $max_per_page) {
	print p;
	$doc_uri = $ENV{REQUEST_URI };
	$doc_uri =~ s/&?topic=.*//gsi;
	$page = 0;
	for ($i = $count - 1; $i >= 0; $i -= $max_per_page) {
		$page ++;
		print("<a href='${doc_uri}&topic=$i'>") if ($topic != $i);
		print $page;
		print("</a>") if ($topic != $i);
		print "&nbsp;&nbsp;&nbsp;";
		
	};
        print "<a href='${doc_uri}&topic=all'>Все Новости</a>"; 
  	print br;
};

