#!/usr/bin/perl
#####################################################
#
# Copyleft by Max Sokolov aka hOLSe
#
# SoG Home page admin image upload script
#
#####################################################

require 'common.pl';

$CGI::POST_MAX=0;
print "Content-type: text/html;\n\n";

$fh = param('image_name');
$img = param('file');

print_top();

print h2('��������/����������/�������� ��������.');


if ($fh ne '') {
	if (!$fh) {
		print "<h3>������ ��� ��������</h3>";
	} else {
	        $filename = $fh;
		while ($filename =~ /(\\|\/)(.*)$/) { $filename = $2; };
		if ($filename =~ /[^a-zA-z0-9\.]/) {
		   print h3("������� ����������� ��� �����: '$filename'.");
		} else {
			$TargetName = "$imgdir/$filename";
                        #print h1($TargetName);
                        #print h1($fh);

			$bytes = 0;
                        open (OUTFILE,">$TargetName"); binmode OUTFILE;
                        while ($bytesread=read($fh, $buffer, 10240)) {
                          #print h1($bytesread);
                          print OUTFILE $buffer;
                          $bytes += $bytesread;
                        };
                        close OUTFILE;
			print h3("���� '$filename' ����������/��������");
			print p("$bytes ���� �����������.");
		};


	};
	print_hr();
} elsif ($img ne '') {
  unlink "$imgdir/$img";
  print h3("���� '$img' ������!");
  print_hr();

};



@images = <${imgdir}/*.*>;
for (@images) { s/$imgdir\///g ;}; 

print "<div align=center><form name='select' method='post'><table border=0 cellspacing=10>";
print '<tr><td valign=top>�������� ��������:</td><td>', scrolling_list('file', \@images, -size=>5, -default=>), '</td></tr>';
print '<tr><td colspan=2 align=center>';
print button(-name=>'showimg', -value=>'����������', -onclick=>"showImg();");
print button(-name=>'delimg', -value=>'�������', -onclick=>"submitDelete();");
print '</td></tr></table></form></div>';

print_hr();
print <<END_HTML;
<h2>��������� ��������</h2>
<div align=center>
<form enctype="multipart/form-data" method="POST">
  <table border=0>
	<tr><td>����</td><td><input type="file" name="image_name" size="20"></td></tr>
	<tr><td></td><td><input type="submit" value="���������"></td></tr>
  </table>
</form>
</div>

<script language='JavaScript'>
function showImg() {
	file = document.select.file;
	img = new Image();
	img.src = '../img/' + file.options[file.selectedIndex].value;
	feat = //'width=' + img.width + ',height=' + img.height +
        'width=350,height=350,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes';
        //alert(feat);
	winImg = window.open('', 'show_image', feat);
		winImg.document.open();
		winImg.document.write('<html><head><title>Image</title></head><body>');
		winImg.document.write('<img src="');
                winImg.document.write(img.src);
		winImg.document.write('" border=3>');

		winImg.document.write('</body></html>');
		winImg.document.close();

};
function submitDelete() {
	file = document.select.file;
	imgsrc = file.options[file.selectedIndex].value;

	if (confirm('�� ������������� ������ ������� ' + imgsrc + '?')) {
		document.select.submit();
	};
};

</script>
END_HTML

#print end_form;

print_bottom();
