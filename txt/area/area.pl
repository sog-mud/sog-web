##!perl

use CGI qw/:standard/;
require 'common.pl';


#$url_val_section = url_param($url_par_section);

%area_sorts;
$area_sorts{'lh'} = 'уровням';
$area_sorts{'n'} = 'имени';
$area_sorts{'l'} = 'нижнему уровню';
$area_sorts{'h'} = 'верхнему уровню';


#print "Content-type: text/html;\n\n";

#print_main_top('area');

$search = url_param($url_par_area_search);
$search =~ tr/ ?*\/\\[]{}()\./|/ds;

$check_search_n = url_param("${url_par_area_check_search}n");
$check_search_m = url_param("${url_par_area_check_search}m");

if ($check_search_m eq '' && $check_search_n eq '') {
	$check_search_m = 'm';
        $check_search_n = 'n';
}
$check_search_m = 'm' if ($check_search_m ne 'm' && $check_search_m ne '');
$check_search_n = 'n' if ($check_search_n ne 'n' && $check_search_n ne '');

$check_search =  $check_search_m . $check_search_n;
#$check_search = 'mn' if ($check_search eq '');




$sort_order = url_param($url_par_area_sort);
$sort_order = 'lh' if ($sort_order =~ /[^lhn]/);



$pre_show_map_url = $area_uri . "$url_par_name=showmap&$url_par_area_search=$search";

$counter = 0;

print qq~
<h1>Зоны</h1>
<form method=GET>
<input type='hidden' name='$url_par_section' value='area'>
<table border=0>
<tr>
<td>Запрос:&nbsp;</td>
<td><input type='text' size=50 name='$url_par_area_search' value='$search'></td>
</tr><tr>
<tr><td>Искать:&nbsp;</td><td>
~;

%cb;
$cb{'m'} = 'по карте';
$cb{'n'} = 'в названии';

print checkbox_group(-name=>"${url_par_area_check_search}n",
      -values=>['n'], -default=>[$check_search_n], -labels=>\%cb);
print checkbox_group(-name=>"${url_par_area_check_search}m",
      -values=>['m'], -default=>[$check_search_m], -labels=>\%cb);
print qq~
</td></tr>
<td>Сортировать по:&nbsp;</td><td>
~;
print popup_menu(-name=>$url_par_area_sort, -values=>['lh', 'n', 'l', 'h'],
		-labels=>\%area_sorts,  -default=>$sort_order);
print qq~
</td></tr>
<tr><td></td><td>
<input type='submit' value='Поиск'>
</td></tr></table>
</form>
~;


print '<table border=0 cellspacing=0 cellpadding=5 width="100%">';
print qq~
<tr bgcolor=#3f3f3f>
<td valign=top nowrap>&nbsp;Название&nbsp;</td>
<td valign=top>&nbsp;Нижний уровень&nbsp;</td>
<td valign=top>&nbsp;Верхний уровень&nbsp;</td>
<td valign=top nowrap>&nbsp;Путь&nbsp;</td></tr>~;

open(LIST, "<$arealist") || die "File $arealist not found!";

while (<LIST>) {
        check_string_from_file($_);
	next if ($_ eq '');
	($name, $lowlevel, $hilevel, $file, $speedwalk) = split(/::/);
	$list{$name}{llevel} = $lowlevel;
        $list{$name}{hlevel} = $hilevel;
        $list{$name}{file}   = $file;
        $list{$name}{speedwalk} = $speedwalk;
};
close LIST;

for $name (_sort(\%list, $sort_order)) {
        if (($counter % 2) == 0) {
	        $bgcolor = '#202020';
        } else {
        	$bgcolor = '#303030';
        };
        #$founded = 1;
        $founded = 0;
        if ($check_search =~/n/) { $founded = ($name =~ /($search)/gi) };
        $mapfilename =  $list{$name}{file} . $map_suf;
	if (-r $mapfilename) {
		$founded |= checkSearch($mapfilename, $search) if ($check_search =~/m/);
	};

	if($founded) {
		$lowlevel = $list{$name}{llevel};
		$hilevel = $list{$name}{hlevel};
                $speedwalk = $list{$name}{speedwalk};
                $file = $list{$name}{file};
		printline($name, $lowlevel, $hilevel, 
		  $speedwalk, $file, $bgcolor, $mapfilename);
		$counter++;
	};


};

print '</table>';


#print_main_bottom();

####subroutinies
sub printline {
	$_[3] = '&nbsp;' if ($_[3] eq '');
	print "<tr bgcolor=$_[5]><td valign=top>";
	if (-e "$_[6]") {
	local $map_url = $pre_show_map_url .
		"&$url_par_area_map=" . $_[4] . "&$url_par_area_name=" . $_[0];
	$map_url =~ tr/ /+/;
	print "<a href=$map_url target='_blank'>$_[0]</a>";
	} else {
        print $_[0];
	};
	print '</td><td valign=top>';
	print $_[1];
	print '</td><td valign=top>';
	print $_[2];
	print '</td><td valign=top>';
	print $_[3];
	print '</td></tr>';
};
sub checkSearch {
	open(FILE, "<$_[0]");
	local @file = <FILE>;
	$str = join ' ',  @file;
	$str =~ /($_[1])/gi;
#	return 0;
};

sub _sort {
  local $href = $_[0];
  local $sortby = $_[1];
  local $byname, $byllevel, $byhlevel;

	  return sort {
	  	$byname = $a cmp $b;
		$byllevel = $$href{$a}{llevel} <=> $$href{$b}{llevel};
		$byhlevel = $$href{$a}{hlevel} <=> $$href{$b}{hlevel};
               	if ($sortby eq 'n') {
               		if ($byname != 0) {
               			return $byname;
               		} elsif ($byllevel != 0){
               			return $byllevel;
               		} else {return $byhlevel;};
  		} elsif ($sortby eq 'l') {
       		  	if ($byllevel != 0) {
       		  		return $byllevel;
       		  	} elsif ($byname != 0) {
	               		return $byname;
	               	} else {return $byhlevel;};
  		} elsif ($sortby eq 'h') {
       		  	if ($byhlevel != 0) {
       		  		return $byhlevel;
       		  	} elsif ($byname != 0) {
       		  		return $byname;
       		  	} else {return $byllevel; }
                } else {
       		  	if ($byllevel != 0) {
       		  		return $byllevel;
       		  	} elsif ($byhlevel != 0) {
       		  		return $byhlevel;
       		  	} else {return $byname; }
                };
	  } keys %$href;
};
