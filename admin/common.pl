#####################################################
#
# Copyleft by Max Sokolov aka hOLSe
#
# SoG Home page admin config 
#
#####################################################


use CGI qw/:standard/;
use CGI::Carp qw(fatalsToBrowser); 
use Cwd;


#change this params this is url path for
$site_document_uri = '/mud/index.pl';
$site_img_dir = '/mud/img';
###################################

$admin_dir = &cwd;
$imgdir = $admin_dir . '/../img';
$site_dir = $admin_dir . '/../txt/';




sub print_top {
	___print_file($admin_dir . '/includes/top.html');
};

sub print_bottom {
	___print_file($admin_dir . '/includes/bottom.html');
};

sub ___print_file {
	local $filename = shift;
	open __F__, "<$filename" || die "File $filename not found";
	local @filecont = <__F__>;
	close __F__;
	#for (@filecont) { print };
	print @filecont;
};

sub print_hr {
	print "<p><img src='$site_img_dir/white.gif' width=100% height=1></p>";
};

sub get_prefix {
 local $section = shift;
 if(-d "$site_dir$section") { 
	return $site_dir . $section . '/'; 
 } else { 
	return $site_dir;
 };
}

sub admin_name {
	local $name = "./.admin/$_[0]";
	return "./.admin/$_[0]" if (-r $name);
	return ".$name";
};

1;