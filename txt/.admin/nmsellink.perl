#!perl

#use CGI qw/:standard/;
#require 'common.perl';

#print "Content-type: text/html;\n\n";


#chdir $site_dir;

$section = param('ssection');


@files0 = <*>;
$sections[0] = '[root section]';
$i = 1;
for (@files0) { $sections[$i++] = $_ if (-d $_); };

chdir $section;
@files0 =<*.desc>;
@files1 =<*.perl>;

push @files, '[index file]';

for (@files0) {
	push @files, $_ if (! -d $_);
};
for (@files1) {
	push @files, $_ if (! -d $_);
};
for (@files) { s/\.\w*$//gi ; };



print qq`
<html><head>
<script>
function returnResult() {
	//file = document.select.file;
	opener.pasteLink(getUrl());
	window.close();
};
function showLink() {
	winImg = window.open(getUrl(), 'show_file');
};
function getUrl(){
	slfile = document.select.file;
	filename = slfile.options[slfile.selectedIndex].value;
	pmsection = document.form_section.ssection;
	section =   pmsection.options[pmsection.selectedIndex].value;
	if (section == '[root section]') { section = 'index'};
	url = '${site_document_uri}?section=${section}';
	if (filename != '[index file]') { url = url + '&name=' + filename; };
	return url;
}
</script>
</head>
<body>
<center>
`;
print start_form(-name=>'form_section');
print popup_menu('ssection', \@sections);
print hidden('name', 'nksellink');
print submit('Select Section');
print end_form;

print qq`

<form name='select'>

`;

print scrolling_list('file', \@files, -size=>10, -width=>100, -multiple=>'no');
print "<br><input type='BUTTON' value='submit' onclick='returnResult()'>";
print "<br><input type='BUTTON' value='Show Link' onclick='showLink()'>";
print '</center>';

print end_form;
print end_html;

