##!c:/usr/perl/bin/perl


$file_name = url_param('file');
#$download = url_param('download');

check_desc_file_name($file_name);
$file_name .= '.txt';
                        
#print "Content-type: text/html;\n\n";

print qq~
<html>
<head>
<link rel="stylesheet" href="sog.css" type="text/css">
<title>Shades of Gray - Документация: $file_name</title>
</head>
<body background="img/bg.gif"  text=#b0b0b0 alink=#afafaf link=#777777 vlink=#777777 olink=#aaaaaa ovlink=#a9a9a9 margintop=10 marginleft=10 marginright=10 marginbottom=10>
<h1>Документация: $file_name</h1>
<hr width='100%'>
<pre class='map_3'>
~;

if (-e $file_name) {

	open(LIST, "<$file_name");
	#print <LIST>;
	while (<LIST>) {
                s/</&lt;/g; s/>/&gt;/g;
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