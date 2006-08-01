package Email::Folder::POP3;
use strict;

use vars qw[$VERSION $POP3];
$VERSION   = '1.011';
$POP3    ||= 'Net::POP3';

use base qw[Email::Folder::Reader];
use Net::POP3;
use URI;

sub _uri {
    my $self = shift;
    return $self->{_uri} ||= URI->new($self->{_file});
}

sub _server {
    my $self = shift;
    return $self->{_server} if $self->{_server};

    my $uri  = $self->_uri;
    my $host = $uri->host;
    my $port = $uri->port || 110;
    my $server = $POP3->new($host, Port => $port, Timeout => 60)
       or die("Net::POP3->new('$host', Port => $port, Timeout => 60): $!");

    my ($user, $pass) = @{$self}{qw[username password]};
    ($user, $pass) = split ':', $uri->userinfo, 2 unless $user;

    $server->login($user, $pass) if $user;
    
    $self->{_next} = 1;
    return $self->{_server} = $server;
}

sub next_message {
    my $self = shift;
    my $message = $self->_server->get($self->{_next});
    if ( $message ) {
        ++$self->{_next};
        return join '', @{$message};
    }
    $self->{_next} = 1;
    return;
}

1;

__END__

=head1 NAME

Email::Folder::POP3 - Email::Folder Access to POP3 Folders

=head1 SYNOPSIS

  use Email::Folder;
  use Email::FolderType::Net;
  
  my $folder = Email::Folder->new('pop://user:pass@example.com:110/');
  
  print $_->header('Subject') for $folder->messages;

=head1 DESCRIPTION

This software adds POP3 functionality to L<Email::Folder|Email::Folder>.
Its interface is identical to the other
L<Email::Folder::Reader|Email::Folder::Reader> subclasses.

=head2 Parameters

C<username> and C<password> parameters may be sent to C<new()>. If
used, they override any user info passed in the connection URI.

=head1 SEE ALSO

L<Email::Folder>,
L<Email::Folder::Reader>,
L<Email::FolderType::Net>,
L<URI::pop>,
L<Net::POP3>.

=head1 PERL EMAIL PROJECT

This module is maintained by the Perl Email Project.

  http://emailproject.perl.org/wiki/Email::Folder::POP3

=head1 AUTHOR

GomoR, <F<netpkt@gomor.org>>.

Casey West, <F<casey@geeknest.com>> (Maintainer).

=head1 COPYRIGHT

  Copyright (c) 2004 GomoR.  All rights reserved.
  This module is free software; you can redistribute it and/or modify it
  under the same terms as Perl itself.

=cut
