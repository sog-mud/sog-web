##!c:/usr/perl/bin/perl

$file = url_param('file');

check_desc_file_name($file);
$_file = $file;
$file .= '.group';

if (-e $file) {
	print "Content-Type: text/html\n\n";
	print_header();
};

open(LIST, "<$file");
while (<LIST>) {
	s/</</g; s/>/>/g;
	print ;
};

close LIST;

print_footer();

sub print_footer() {
print qq~
</pre>
</body>
</html>
~;
}


sub print_header() {
print qq~
<html>
<head>
<link rel="stylesheet" href="sog.css" type="text/css">
<title>Shades of Gray</title>
</head>
<body background="img/bg.gif"  text=#b0b0b0 alink=#afafaf link=#777777 vlink=#777777 olink=#aaaaaa ovlink=#a9a9a9 margintop=10 marginleft=10 marginright=10 marginbottom=10>
<pre>
~;
};

