#!perl

#use CGI qw/:standard/;

#require 'common.pl';

$dir = param('dir');
$dir = $imgdir;
#print "Content-type: text/html;\n\n";


chdir $dir;
@files0 =<*>;
@files;
for (@files0) {
	push @files, $_ if (! -d $_);
};
print qq`
<html><head>
<script>
function returnResult() {
	file = document.select.file;
	opener.pasteImg(file.options[file.selectedIndex].value);
	//event.returnValue = false;
	window.close();
};
function showImg() {
	file = document.select.file;
	img = new Image();
	img.src = '$site_img_dir/' + file.options[file.selectedIndex].value;
	feat = //'width=' + img.width + ',height=' + img.height +
        'width=250,height=250,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no';
        //alert(feat);
	winImg = window.open('', 'show_image', feat);
	
		winImg.document.open();
		winImg.document.write('<html><head><title>Image</title></head><body>');
		winImg.document.write('<img src="');
                winImg.document.write(img.src);
		winImg.document.write('">');
//		winImg.document.writeln();
//                winImg.document.write(img.width, 'sdfds', img.height);

		winImg.document.write('</body></html>');
		winImg.document.close();

};
</script>
</head>
<body>
<form name='select'>
<center>
`;
print scrolling_list('file', \@files, -size=>10, -width=>100);
print "<br><input type='BUTTON' value='submit' onclick='returnResult()'>";
print "<br><input type='BUTTON' value='Show Image' onclick='showImg()'>";
print '</center><br><br><br><br>';
print '<img name="hidden_image">';

print end_form;
print end_html;

