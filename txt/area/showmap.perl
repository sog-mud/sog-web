##!c:/usr/perl/bin/perl

use CGI qw/:standard/; 
require 'common.pl';

$name = url_param($url_par_area_name);
$map = url_param($url_par_area_map);
$search = url_param($url_par_area_search);
$search =~ s/ /\|/g;

check_desc_file_name($map);
$file_map = $prefix{area} . $map . $map_suf;

print "Content-type: text/html;\n\n";

print qq~
<html>
<head>
<link rel="stylesheet" href="sog.css" type="text/css">
<title>Shades of Gray</title>
</head>
<body background="img/bg.gif"  text=#b0b0b0 alink=#afafaf link=#777777 vlink=#777777 olink=#aaaaaa ovlink=#a9a9a9 margintop=10 marginleft=10 marginright=10 marginbottom=10>
<h1>$name</h1>
<script language='javascript'>
/*if (document.all != null) {
	document.write("<FORM NAME='map_change'>");
	document.write("Ì¡”€‘¡¬:ö");
	document.write("<select name='m' onChange='document.all.mapa.className=this.options[selectedIndex].value'>");
	document.write("<option value='map_0'>0");
	document.write("<option value='map_1' selected>1");
	document.write("<option value='map_2'>2");
	document.write("<option value='map_3'>3");
	document.write("</select></FORM>");
};*/
</script>

<hr width='100%'>
<pre id='mapa' class='map_3'>
~;

if (-e $file_map) {
#print h1($search);

open(LIST, "<$file_map");
while (<LIST>) {
	s/($search)/<u>$1<\/u>/ig unless ($search eq '');
	print ;
};
close LIST;


} else {
 print '<h2>FILE NOT FOUND</h2>';
};

print qq~
</pre>
</body>
</html>
~;