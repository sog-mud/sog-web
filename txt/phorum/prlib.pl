#!perl

sub print_messages {
	local $parent_id = shift;
	local $hmessages = shift;
	local $cur_id = shift;
	local $id;
	local $resu, $res;
	#print_error("cur_id: $cur_id");
	foreach $id (sort {$b <=> $a } keys %$hmessages) {
		#print_error("print_messages id: '$id', '$parent_id', '$$hmessages{$id}{parent_id}'");
	 if ($$hmessages{$id}{parent_id} eq $parent_id) {
	        $resu .= "<table border='0' cellspacing='0' cellpadding='0' width='100%'><tr><td colspan=2>";
	        #print_error('df');
                $resu .= print_message_line($id, $hmessages, $cur_id);
                $resu .= "<tr><td colspan=2><img src='img/gray.gif' width='100%' height='1'></td></tr>";
		$res = print_messages($id, $hmessages, $cur_id);
		if (!($res eq '')) {
			$resu .= "</td></tr><tr><td width='15'>&nbsp;</td><td>";
			$resu .= $res;
		}
		$resu .= "</td></tr></table>";
         }
        };
        return $resu;
};

sub print_message_line {
	local $id = shift;
	#local $topic_id = shift;
	local $hmessages = shift;
	local $cur_id = shift;
	local $time = get_message_time($id);
	#print_error("line: $id");
	local $result = "<table border='0' cellspacing='0' cellpadding='0' width='100%'><tr><td>";
	$result .= "<a href='$phorum_url&topic=$$hmessages{$id}{topic_id}&id=$id' class='phorum'>" unless ($cur_id == $id);
	$result .= "$$hmessages{$id}{subj}";
	$result .= "</a>" unless ($cur_id == $id);
	$result .= "</td><td align='right' valign='top'>";
	$result .= "<a href='mailto:$$hmessages{$id}{email}'>" unless ($$hmessages{$id}{email} eq '');
	$result .= "$$hmessages{$id}{from}";
	$result .= "</a>" unless ($$hmessages{$id}{email} eq '');
	$result .= "&nbsp;&nbsp;$time";
	$result .= "</td></tr></table>";
	return $result;
};

sub get_message_time {
	local $id = shift;
        #local ($sec,$min,$hour,$mday,$mon,$year,$wday) = (localtime($id))[0,1,2,3,4,5,6];
        local ($sec,$min,$hour,$mday,$mon,$year,$wday) = (gmtime($id))[0,1,2,3,4,5,6];
	$min = sprintf("%.02d",$min);
	$hour = sprintf("%.02d",$hour);
	$mday = sprintf("%.02d",$mday);
	$year += 1900;
        return "$days[$wday], $mday $months[$mon] $year $hour:$min GMT";
};

sub print_message_form {
	local $phorum = shift;
	local $mess_id = shift;
	local $topic_id = shift;
	local $section = shift;

	local $from = shift;
	local $email = shift;
	local $subject = shift;
	local $text = shift;
return qq~
<form action='$post_url&state=add' method=POST>
<input type='hidden' name='phorum' value='$phorum'>
<input type='hidden' name='id' value='$mess_id'>
<input type='hidden' name='topic' value='$topic_id'>
<input type='hidden' name='$url_par_section' value='$section'>
<input type='hidden' name='state' value='add'>
<table border='0'>
<tr><td>От кого:</td><td><input type='text' size='20' name='from' value='$from'></td></tr>
<tr><td>E-mail:</td><td><input type='text' size='30' name='email' value='$email'></td></tr>
<tr><td>Subject:</td><td><input type='text' size='70' name='subject' value='$subject'></td></tr>
<tr><td valign='top'></td><td><textarea name='text' cols='55' rows='15'>$text</textarea></td></tr>
<tr><td></td><td><input type='submit' name='submit' value='Отправить'></td></tr>
<tr><td></td><td>
<p>
В теле сообщения можно использовать теги:
<ul>
<li>[cit]...[/cit] - для обозначения цитат
<li>[link='&lt;url&gt;']&lt;url_name&gt;[/link] - для обозначения ссылок
<li>[i]...[/i] - курсив
<li>[s]...[/s] - перечекнутый текст
</ul>
</p>
</td></tr>
</table>
</form>

~;
};


sub print_message() {
        local $from = shift;
        local $email = shift;
        local $subject = shift;
        local $text = shift;
        local $result = qq`
<table border='0' cellpadding='5' cellspacing='2' width='100%'>
<tr><td width='1%' bgcolor='#333333' align='right'>Subject:</td><td width='99%' bgcolor='#333333'>$subject</td></tr>
<tr><td bgcolor='#333333' align='right'>From:</td><td bgcolor='#333333'>
	`;
	
	$result .= "<a href='mailto:$email'>" unless ($email eq '');
	$result .= $from;
	$result .= "</a>" unless ($email eq '');

	$result .= qq`
</td></tr>
<!--</table><br><br>-->
<tr><td></td><td bgcolor='#333333'><br>
	`;
	$result .= $text;
	$result .= "</td></tr></table><br>";
};



1;