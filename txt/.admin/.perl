
$file = param('file');
$file =~ s/(\.\.|\\|\/)//g;
$state = param('state');
$text = param('text');
$sub = param('sub');
@files;



if ($file ne '') {

        if ($state eq 'create') {
		save_file($file, $text);
		print h3("Файл '$file' создан (обновлен).");
	} elsif ($sub eq 'удалить') {
	#необходимо удалить файл
	    	$file = real_name($file);
		unlink $file;
		print h3("Файл '$file' удален.");
	} else {
		print h3($file);
		print qq~
<script>
function selectImg() {
	win = window.open("section.pl?name=nmselimg", 'select_img', 'status=no,width=150,height=250');
};
function selectLink() {
	win = window.open("section.pl?name=nmsellink", 'select_link', 'status=no,width=200,height=500');
};

function pasteImg(ImgName) {
	//alert(ImgName);
	document.edit.text.value += '<img src="img/' + ImgName + '" border=0> ';
};
function pasteLink(Link) {
	//alert(Link);
	document.edit.text.value += '<a href="' + Link + '">...</a> ';
};
</script>
~;
		print "<form name='edit' method='POST'>";
		print "<textarea name='text' cols=65 rows=20>";
		prn_file($file);
		print '</textarea>';
		print "<input type='hidden' name='section' value='$section'>";
		print "<input type='hidden' name='file' value='$file'>";
		print "<input type='hidden' name='state' value='create'><br><br>";
		print submit('Сохранить');
		print "<br><br><input type='button'  value='Insert Image' onclick='selectImg();'>";
		print "<input type='button'  value='Insert Link' onclick='selectLink();'>";
		print "</form>";
	};

} else {
	&get_files;
	print "<form name='create'>";
	print "Создать файл: <input type='text' name='file' size='30'> ";
	print "<input type='hidden' name='section' value='$section'>";
	print submit('Создать');
	print "</form>";


	print "<form name='select'>";
	print 'Выберите файл: ', popup_menu('file', \@files);
	print "<input type='hidden' name='section' value='$section'>";
	print "<input type='hidden' name='state' value=''>";
	print submit('sub', 'редактировать');
	print submit('sub', 'удалить');
	print "</form>";
};


sub prn_file {
	local $file = shift;
	$file = real_name($file);	
	if (-w $file) {
		open pf_FILE, "<$file";
		while (<pf_FILE>) { print ; };
		close pf_FILE;
	};
};

sub real_name {
	local $file = shift;
	$file = '.desc' if ($file eq '[index]');
	$file = '.menu' if ($file eq '[menu]');
	$file = '.table' if ($file eq '[table]');
	$file = '.css' if ($file eq '[css]');
	$file = '.bann' if ($file eq '[bann]');
	$file = '.index' if ($file eq '[root-index]');
	return $file;
};

sub save_file {
	local $file = shift;
	local $text = shift;
	$file = real_name($file);
	open pf_FILE, ">$file";
	print pf_FILE $text;
	close pf_FILE;
	#print h2($text);
};


sub get_files {
	@files0 = <*>;
	push @files, '[index]' if (-w '.desc');
	push @files, '[menu]' if (-w '.menu');
	push @files, '[table]' if (-w '.table');
	push @files, '[css]' if (-w '.css');
	push @files, '[bann]' if (-w '.bann');
	push @files, '[root-index]' if (-w '.index');

	for (@files0) {
	  push @files, $_ unless -d;
	};

};