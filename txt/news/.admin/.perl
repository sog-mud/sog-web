
require 'news.cfg';


$topic = param('topic');
@topics = param('topics');
$topic_del_count = @topics;
$state = param('state');
$text = param('text');


prepare_doc_uri();

open FILE, "<$news_data_file" || die "Error: File $data_file not open!";
##flock
@strs = <FILE>;
#while (<FILE>) {
 	#s/(\r|\n)//g;
#push @strs;
#};

close FILE;




if ($topic_del_count > 0) {
	foreach (@topics) {
		$strs[$_] = '';
	};

	open FILE, ">$news_data_file" || die "Error: File $data_file not open for write!";
	##flock
	foreach(@strs) {print FILE if ($_ ne ''); };
	close FILE;
	print "<h2>Сообщения удалены</h2><a href='$doc_uri'>[Назад]</a>";
	
	exit;
};

if ($state eq 'create') {
	print qq~
<h2>Добавление Новости</h2>
<div align='center'>
<form method='post'>
<textarea name='text' cols="80" rows="20">
</textarea><br><br>
<input type='hidden' name='section' value='news'>
<input type='submit' value='Добавить новость'>
<input type='hidden' name='state' value='add'>
</form>
</div>
<br><br><a href='$doc_uri'>[Назад]</a>
~;

} elsif ($state eq 'add') {
        $str = time() . '=' . $text;
	$str =~ s/\r//g;
	$str =~ s/\n/ /g;
	open FILE, ">>$news_data_file" || die "Error: File $data_file not open for write!";
	##flock
	print FILE "$str\n";
	close FILE;
	
	print "<h2>Новость добавлена</h2>";
	print_topic($str);
	print "<br><br><a href='$doc_uri'>[Назад]</a>";


} else {




$count = @strs;
$topic = ($count - 1) if ($topic eq '');


print qq~
<h2>Администрирование Новостей</h2>
<a href='${doc_uri}&state=create'>Создать Новость</a>
<form action='$doc_uri' method='GET'>
<input type='submit' value='Удалить выбранные сообщения'><br>
<input type='hidden' name='section' value='news'>
~;

if ($topic eq 'all') {
	for ($i = $count - 1; $i >= 0; $i--) {
		print_topic($strs[$i], $i);
	};
} else {
	for ($i = $topic ; ($i > $topic - $max_per_page ) && ($i >= 0); $i--) {
		print_topic($strs[$i], $i);
	};
};

if ($count > $max_per_page) {
	print p;
	
	$page = 0;
	for ($i = $count - 1; $i >= 0; $i -= $max_per_page) {
		$page ++;
		print("<a href='${doc_uri}&topic=$i'>") if ($topic != $i);
		print $page;
		print("</a>") if ($topic != $i);
		print "&nbsp;&nbsp;&nbsp;";
		
	};
        print "<a href='${doc_uri}&topic=all'>Все Новости</a>"; 
  	print br;
};

print "</form>";



};