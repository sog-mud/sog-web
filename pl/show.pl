#perl file

#####################################################
#
# Copyleft by Max Sokolov aka hOLSe
#
# SoG Home page main script
#
#####################################################

use CGI qw/:standard/;
use CGI::Carp qw(fatalsToBrowser); 
use Cwd;
require 'show.cfg';

my $tmp;



$query_string = $ENV{'QUERY_STRING'};
$query_string = $ENV{'CHARSET_SAVED_QUERY_STRING'} if ($ENV{'CHARSET_SAVED_QUERY_STRING'});

$request_uri = $ENV{REQUEST_URI};
$request_uri =~ s/\?.*/\?$query_string/;
$document_uri = $ENV{DOCUMENT_URI};
$document_uri = $ENV{SCRIPT_NAME} if ($document_uri eq '');

$section = url_param($url_par_section);
$section = param($url_par_section) if ($section eq '');
$section =~ s/(\.\.|\\|\/)//g;
$filedesc = url_param($url_par_name);
$filedesc = param($url_par_name) if ($filedesc eq '');
$filedesc =~ s/(\.\.|\\|\/)//g;

$root_url = $document_uri . '?' . $url_par_section . '=' . $section;


$root_doc_url = $root_url . '&' . $url_par_name . '=' . $filedesc;





check_desc_file_name($filedesk);
$prefix = get_prefix($section);
$execfile = $prefix . $filedesc . $desc_perl_suf;
local $filedesc = $prefix . $filedesc . $desc_suf;
$filedesc = $prefix . $desc_suf unless (-e $filedesc);





if (-e $execfile) {
	$execfile =~ /(.*)[\\|\/](.*)$/;
	chdir $1;
	do "$2";
} else { 
	print "Content-type: text/html;\n\n";
	open __INDEX__, "<$site_root$index_file" || die "File $index_file not found!";
	@index_cont = <__INDEX__>;
	close __INDEX__;
	$index_cont = join ("", @index_cont); 
	open __CSS__, "<$site_root$css_file" || die "File $css_file not found!";
	@tmp = <__CSS__>;
	close __CSS__;
	$css_cont = join ("", @tmp);
	open __BANN__, "<$site_root$bann_file" || die "File $bann_file not found!";
	@tmp = <__BANN__>;
	close __BANN__;
	$bann_cont = join ("", @tmp);
	$menu_cont = print_menu($section);
	$index_cont =~ s/<$v_index_css>/$css_cont/gi;
	$index_cont =~ s/<$v_index_menu>/$menu_cont/gi;
	$index_cont =~ s/<$v_index_banner>/$bann_cont/gi;
	$index_cont =~ /<$v_index_content>/gi;
	$end_html = $';
	print $`;

	open(__DESC, "<$filedesc") || die "File $filedesc not found!";
	if (get_desc($prefix, \@desc)) {
		$line = <__DESC>;
		check_string_from_file($line);
		@desc_ = split(/::/, $line);
		print h1($desc_[0]);
		while (<__DESC>) { parse_desc_string($_); print};
		print print_desc_table(\@desc, \@desc_) unless (@desc_[1] eq '');
	};
	while (<__DESC>) { parse_desc_string($_); print};
	close(__DESC);
	print $end_html;
};


###




###########################
#subroutines
###########################

sub get_desc {
#$_[0] - dir
#$_[1] - array to put desc
local $hdesc = $_[1];
local $file = $_[0] . $desc_table;
 if (-e $file) {
	open(DESC, "<$file");
	local $line = <DESC>;
        check_string_from_file($line);
	@$hdesc = split /==/, $line;
	close(DESC);
	return 1;
 } else { return 0;};
}

sub get_prefix {
 if(-d "$site_root$_[0]" && !($reserved_prefix =~ m`$_[0]`))
 { return $site_root . $_[0] . '/'; 
 } else { return $site_root };
}

sub print_error {
	print "<h2> Error: $_[0]</h2>";
}

sub parse_desc_string {
#$_[0] - string
	while($_[0] =~ s/<<(.*)>>//) {
		$subst = $1;
		command_desc_substitution($subst) unless ($subst eq '');
	};
	$_[0] =~ s/(<a\s+href\s*=\s*["'])\/\?/$1${document_uri}?/g;
}
sub command_desc_substitution {
#$_[0] - command
	local $command, $str;
        local $cwd = cwd();
	($command, $str) = split/=/, $_[0];
	if ($command eq 'execpl') {
                #$ENV{'SOG_DOCUMENT_URI'} = $ENV{'DOCUMENT_URI'};
                #$ENV{'SOG_REQUEST_URI'} = $ENV{'REQUEST_URI'};
                if ($str =~ /(.*)[\/|\\](.*)$/) {$prefix .= "$1"; $str = $2;};
                chdir $prefix;
                do "$str";
		chdir $cwd;
	};
#        } if ($command eq 'chdir') {
#        	#print_error(chdir $cwd . '/' . $str);
#        	#print_error($str);
#        };
};


sub check_desc_file_name {
#$_[0] - filename
	$_[0] =~ /([^\s\.\/\\]*)$/;
    $_[0] = $1;
#        $_[0] = $main_desc if ($_[0] eq '');
#        return $_[0];
}

sub check_string_from_file {
#$_[0] - tested string
        
	$_[0] =~ s/(\n)|(\r\n)//g; #del all CR LF simbols
        $_[0] =~ s/#.*$//g;  # del all comments
        return $_[0];
}

sub print_desc_table {
        local $hdesc = $_[0];
        local $hdesc_ = $_[1];
		local $result = '';
	$result = "<table border=0 cellspacing=5 cellpadding=3 width='100%'>";
	for($i = 1; $i <= $#$hdesc; $i++) {
		$result .= "<tr><td width='10%' NOWRAP valign=top>";
		$result .= $$hdesc[$i];
		$result .= "</td><td width='90%' valgn=top>";
		$result .= $$hdesc_[$i];
		$result .= "</td></tr>\n";
	};
	$result .= "</table>";
	return $result;
};

#######################
#menus
#######################
sub print_sub_menu {
#$_[0] - section

	local $section = $_[0];
	local $line = '';
	local $name, $url;
	#local $prefix = get_prefix($section);
	return '' if ($prefix eq $site_root);
	local $menu = $prefix . $menu_file;
	return '' unless (-e $menu);
	open _SMENU, "<$menu";
	while(<_SMENU>) {
		check_string_from_file($_);
		($name, $url) = split /==/;
		$url =~ s/^\/\?/${document_uri}?/;
                $line .=  "<a href='$url' class=submenu align=left>$name</a><br>\n";
        }
        close(_SMENU);
        return $line;
}
sub print_menu {
#$_[0] - section
	local $line = '';
	local $menu_section, $name, $url;
	local $menu = $site_root . $menu_file;
	if (!(-e $menu)) { print_error('Can\'t load menu file!'); exit;};
	open _MENU, "<$menu";
	while(<_MENU>) {
		check_string_from_file($_);
		($menu_section, $name, $url) = split/==/;
                $url =~ s/^\/\?/${document_uri}?/;
                $line  .= "<div class=menu align=right><a href='$url'>$name</a></div>\n";
				$line .= print_sub_menu($menu_section) if ($_[0] eq $menu_section);

        };
        close(_MENU);
        return $line;
}



