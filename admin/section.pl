#!/usr/bin/perl
#####################################################
#
# Copyleft by Max Sokolov aka hOLSe
#
# SoG Home page admin sections script
#
#####################################################

require 'common.pl';

print "Content-type: text/html;\n\n";



$data_dir = $site_dir;




$section = param('section');
#$section = '' if($section eq '[root section]');
$name = param('name');
$name =~ s/(\.\.|\\|\/)//g;
$name .= '.perl';

$prefix = get_prefix($section);



if ($name =~ /^nm/) {
	chdir $prefix;
	do &admin_name($name);

	exit;
};


print_top();
print h2('Администрирование разделов.');

push @sections, '[root section]';

readdirs("$data_dir", \@sections);

#print '<div align=center>';
print "<form>";
print 'Выберите раздел: ', popup_menu('section', \@sections);
print ' ', submit(-name=>'admin_select', -value=>'Выбрать');
print "</form>";
#print '</div>';
&print_hr;


chdir $prefix;
#if (-r ".admin/.perl" || $section eq '[root section]') { do '.admin/.perl' } else { do '../.admin/.perl' };

do &admin_name($name);


chdir $admin_dir;
&print_bottom();




sub readdirs {
	local $dirname = $_[0];
	local $htarray = $_[1];
	local $curdir = cwd();
	chdir $dirname;
	opendir DIR, '.';

	local $file = '1';
	local $i = 0;
	while ($file ne ''){
	  $file = readdir DIR;
	  next if ($file =~/^\./);
	  next if (!-d $file);
	  #$htarray[$i++] = $file;
	  push @$htarray, $file;
	};

	closedir DIR;
	#print $htarray;
	chdir $curdir;
	$_[1] = $htarray;
	
}
