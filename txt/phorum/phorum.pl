##perl

#use CGI;

require 'prlib.pl';
require 'pholib.pl';

$data_dir = './data';
chdir $data_dir;

@months = ('Январь','Февраль','Mарт','Апрель','Май','Июнь','Июль','Август','Сентябрь','Октябрь','Ноябрь','Декабрь');
@days = ('Вс','Пн','Вт','Ср','Чт','Пт','Сб');


##########################################################################################
#
#load needed info
#
##########################################################################################

%phorums;
@topics;
%messages;
$text;

$phorum = url_param('phorum');
$topic_id = url_param('topic');
$mess_id = url_param('id');
$state = url_param('state');

$level = 0;
$level = 1 unless ($phorum eq '');
$level = 2 unless ($phorum eq '' || $mess_id eq '' || $topic_id eq '');

$phorum_url = $root_url . '&phorum=' . $phorum;
$phorum_url =~ s/\s/+/gi;

$message_url = $phorum_url . '&topic='. $topic_id . '&id=' . $mess_id;
#Обрати внимание ?????
$post_url = 'index.pl?' .  'phorum=' . $phorum . '&topic='. $topic_id . '&id=' . $mess_id;
$post_url =~ s/\s/+/gi;



open LIST, "<phorum.db" || die "File phorum.db not found";
###flock
while(<LIST>) {
	check_string_from_file($_);
	next if ($_ eq '');
	($s1, $s2, $s3) = split/==/, $_, 3;
	$phorums{$s2}{name} = $s1;
        $phorums{$s2}{desc} = $s3;
};
close LIST;

if ($state eq 'add') {
	$add_from = param('from');
	$add_email = param('email');
	$add_subject = param('subject');
	$add_text = param('text');
};

if ($level == 2) {
	$ret = load_messages_list($phorum, $topic_id, \%messages);
	if ($ret < 0) { print_error($ioerrors{$ret}); exit };
       	$from = $messages{$mess_id}{from};
        $email = $messages{$mess_id}{email};
       	$subject = $messages{$mess_id}{subj};
	$ret = load_message($phorum, $mess_id, $text);
       	if ($ret < 0) { print_error($ioerrors{$ret}); exit };

} elsif ($level) {
	$ret = load_phorum_topics($phorum, \@topics);
        if ($ret < 0) { print_error($ioerrors{$ret}); exit };
        for (@topics) {
		local $topic_id = $_;
                $ret = load_messages_list($phorum, $topic_id, \%messages);
                if ($ret < 0) { print_error($ioerrors{$ret}); exit };
        };
};



##########################################################################################

##########################################################################################
#
#print header
#
##########################################################################################
print qq`
<style>
a.phorum:hover{
	text-decoration: none;
	color: white
}
</style>
`;
print "<table border=0><tr><td>";

print qq~<a href="$root_url">~ if ($level);
print 'Форумы';
print '</a>&gt;' if ($level);

print qq~<a href="$phorum_url">~ if ($level == 2 || $state eq 'create' || $state eq 'add' || $state eq 'reply');
print "$phorums{$phorum}{name}"  if ($level);
print '</a>' if ($level == 2 || $state eq 'create' || $state eq 'add' || $state eq 'reply');

print "&gt;" if ($level == 2);
print "<a href='$message_url'>" if ($state eq 'reply' || $state eq 'add');
print "$messages{$mess_id}{subj}" if ($level == 2 || $state eq 'add');
print "</a>" if ($state eq 'reply');

print "</td></tr><tr><td>" if ($level);
print "<a href='$phorum_url&state=create'>Создать тему</a>" if ($level == 1 && !($state eq 'create' || $state eq 'add'));
print "<a href='$message_url&state=reply'>Ответить</a>" if ($level == 2 && !($state eq 'reply' || $state eq 'add'));

print "</td></tr></table><br><br>";
##########################################################################################

##########################################################################################
#
#print body
#
##########################################################################################
if ($state eq 'create') {
	print print_message_form($phorum, $mess_id, $topic_id, "phorum", "", "", "", "");
} elsif ($state eq 'reply') {
	$reply_text = $text;
	#$reply_text =~ s/^(.*)$/>$1/gi;
	$reply_text =~ s/(\n\r|\r\n|\n|\r)/\n>/g;
	$reply_text = '>' . $reply_text;
	$reply_text = get_message_time($mess_id) . ", $from сообщил(а):\n" . $reply_text;
        print print_message_form($phorum, $mess_id, $topic_id, "phorum",
        		"", "", "Re: $subject", "$reply_text");
} elsif ($state eq 'add') {
	$err_add = 0;
	if ($add_from eq '') {
		print h2('Не заполнено поле От кого:');
		$err_add = 1;
	};
	if ($add_subject eq '') {
		print h2('Не заполнено поле Subject:');
		$err_add = 2;
        };
        if ($err_add) {
        	print print_message_form($phorum, $mess_id, $topic_id, "phorum",
        			$add_from, $add_email, $add_subject, $add_text);
        } else {
                #print_error($add_email);
 		$mess_id = _add_message($phorum, $topic_id, $mess_id, $add_from, $add_email,
        		$ENV{REMOTE_ADDR}, $add_subject, $add_text);
       		print h2('Ваше сообщение добавлено');
       		prepare_message($add_text);
	        print print_message($add_from, $add_email, $add_subject, $add_text);
	        #print print_messages(0, \%messages, -1);
	}
}else {
	if (!$level) {
		foreach (sort keys %phorums) {
			local $id = $_;
			s/\s/+/gi;
			print "<p><a href='${root_url}&phorum=$_'>$phorums{$id}{name}</a>",
			      "<BLOCKQUOTE>$phorums{$id}{desc}<hr></BLOCKQUOTE></p><br>";
        	};
	} elsif ($level == 1) {
	        print print_messages(0,  \%messages, -1);
	} else {
                prepare_message($text);
                print print_message($from, $email, $subject, $text);

		print print_messages(0,  \%messages, $mess_id);
	}
};



