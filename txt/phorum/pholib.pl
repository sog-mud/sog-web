#!perl


$topic_suf = '.topic';
$message_suf = '.msg';

$ioerrors{-1} = 'Topic not found!';
$ioerrors{-2} = 'Message not found!';
$ioerrors{-3} = 'Phorum not found';

###subroutines

sub load_phorum_topics {
	local $phorum_pre = shift;
	local $htopics = shift;
	local $i = 0;#$$htopics;
        opendir PHORUM, "$phorum_pre" || {return -3};
        local $file;
        while (1) {
        	$file = readdir PHORUM;
        	next if (-d $file);

        	last if ($file eq '');
               	$file =~ /(.*)${topic_suf}$/;
        	$$htopics[$i++] = $1;
        	#print_error("load_phorum_topics: $1");
        };
        closedir PHORUM;
        return $i;
        #local @htopics = <$phorum_pre/*$topic_suf>;
        #for (@htopics) {
        #	$$htopics[i] = $_;
        #	i += 1;
        #};
};

sub load_messages_list {
        local $phorum_pre = shift;
	local $topic_id = shift;
	local $hmessages_list = shift;
	local $i = 0;

        local $topic_file = $phorum_pre . '/' . $topic_id . $topic_suf;
	local $id, $parent_id, $from, $email, $subj, $ip;
	#print_error("load_messages_list topicfile: $topic_file");
	if (!(-r $topic_file)) { return 0 };
	open MESSAGES_LIST, "<$topic_file" || { return -1 }; #topic not found
	###flock
	while (<MESSAGES_LIST>) {
		check_string_from_file($_);
		next if ($_ eq '');
		($id, $parent_id, $from, $email, $ip, $subj) = split /==/, $_, 6;
		$$hmessages_list{$id}{parent_id} = $parent_id;
                $$hmessages_list{$id}{topic_id} = $topic_id;
                $$hmessages_list{$id}{from} = $from;
                $$hmessages_list{$id}{email} = $email;
                $$hmessages_list{$id}{ip} = $ip;
                $$hmessages_list{$id}{subj} = $subj;
                $i += 1;
        };
        close MESSAGES_LIST;
        return $i;
};

sub load_message {
	local $phorum_pre = $_[0];
	local $mess_id = $_[1];
	local $message = $_[2];
	local $mess_file = $phorum_pre . '/' . $mess_id . $message_suf;
	local @message;
        if (!(-r $mess_file)) { return -2};
	open MESSAGE, "<$mess_file" || return -2;
	###flock
	local @message = <MESSAGE>;
	close MESSAGE;
	local $message = join "", @message; 
	$_[2] = $message;
	return 1;
};

sub prepare_message {
	local $mess = $_[0];
	#запрещение тегов и т.п.
        $mess =~ s/</&lt;/g;
	$mess =~ s/>/&gt;/g;
        $mess =~ s/(\n\r|\r\n|\n|\r)/<br>/g;

        #обработка тегов форума
        $mess =~ s/\[(\/?[bsi])\]/<$1>/gi;
        $mess =~ s/\[link=["'](.*)["']\](.*)\[\/link\]/<a href='$1'>$2<\/a>/gi;

        while ($mess =~ s/\[cit\](.*)\[\/cit\]/<blockquote><i>$1<\/i><\/blockquote>/gi) {};

        $mess =~ s/"/&quot;/g;
        return $_[0] = $mess;
};

sub _add_message {
	local $phorum_pre = shift;
	local $topic_id = shift;
	local $parent_id = shift;
	local $from = shift;
	local $email = shift;
	local $ip = shift;
	local $subj = shift;
	local $message = shift;

	local $mess_id = time;
	if ($topic_id eq '') {
		$topic_id = $mess_id;
		$parent_id = 0;
	};
	local $topic_file = $phorum_pre . '/' . $topic_id . $topic_suf;
	open TOPIC_FILE, ">>$topic_file" || die "Could not open file $topic_file";
	###flock
	print TOPIC_FILE "\n$mess_id==$parent_id==$from==$email==$ip==$subj";
	close TOPIC_FILE;
        local $mess_file = $phorum_pre . '/' . $mess_id . $message_suf;
        $message =~ s/(\n\r|\r\n)/\n/g;
	open MESSAGE, ">$mess_file" || die "Could not write to file $mess_file!";
	###flock
	print MESSAGE $message;
	close MESSAGE;
	return $mess_id;
};

1;