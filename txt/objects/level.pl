##!perl

use CGI qw/:standard/;

$counter = 0;
$limitlist='limit.list';
print '<table border=0 cellspacing=1 cellpadding=5 width="100%">';
print qq~
<tr bgcolor=#3f3f3f>
<td valign=top nowrap>&nbsp;<a href='?section=objects'>Название</a>&nbsp;</td>
<td valign=top>&nbsp;<a href='?section=objects&name=level'>Уровень</a>&nbsp;</td>
<td valign=top>&nbsp;<a href='?section=objects&name=number'>Количество</a>&nbsp;</td>
<td valign=top>&nbsp;<a href='?section=objects&name=type'>Тип</a>&nbsp;</td>
<td valign=top nowrap>&nbsp;<a href='?section=objects&name=area'>Зона</a>&nbsp;</td></tr>~;

open(LIST, "<$limitlist") || die "File $limitlist not found!";

while (<LIST>) {
        check_string_from_file($_);
	next if ($_ eq '');
	($name, $level, $limit, $type, $area) = split(/::/);
	$list{$name}{level} = $level;
	$list{$name}{limit} = $limit;
        $list{$name}{type} = $type;
        $list{$name}{area} = $area;
};
close LIST;

foreach $name (sort {$list{$a}{level} <=> $list{$b}{level}} keys %list) {
        if (($counter % 2) == 0) {
	        $bgcolor = '#202020';
        } else {
        	$bgcolor = '#303030';
        };

	$level = $list{$name}{level};
	$limit = $list{$name}{limit};
	$type = $list{$name}{type};
        $area = $list{$name}{area};
	printline($name, $level, $limit, $type, $area, $bgcolor);
	$counter++;
};

print '</table>';

####subroutinies
sub printline {
	$_[3] = '&nbsp;' if ($_[3] eq '');
	print "<tr bgcolor=$_[5]><td valign=top>";
        print $_[0];
	print '</td><td valign=top>';
	print $_[1];
	print '</td><td valign=top>';
	print $_[2];
	print '</td><td valign=top>';
	print $_[3];
	print '</td><td valign=top>';
	print $_[4];
	print '</td></tr>';
};

