# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::PostMaster::Filter::OOOR;

use strict;
use warnings;

sub new {
  my ( $Type, %Param ) = @_;

  # allocate new hash for object
  my $Self = {};
  bless( $Self, $Type );

  $Self->{Debug} = $Param{Debug} || 0;

  # get needed objects
  for (qw(ConfigObject LogObject MainObject TicketObject)) {
    $Self->{$_} = $Param{$_} || die "Got no $_!";
  }

  return $Self;
}

sub Run {
  my ( $Self, %Param ) = @_;

  # check needed stuff
  for (qw(GetParam)) {
    if ( !$Param{$_} ) {
      $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
      return;
    }
  }

  my %Ticket = $Self->{TicketObject}->TicketGet(
    TicketID => $Param{TicketID},
    UserID   => 1
  );

  if ($Param{GetParam}->{'X-Autoreply'}) {
    $Param{GetParam}->{'X-OTRS-FollowUp-State'} = $Ticket{State};
    $Self->{TicketObject}->HistoryAdd(
      Name         => 'X-Autoreply was set, skipping state update',
      HistoryType  => 'FollowUp',
      TicketID     => $Param{TicketID},
      CreateUserID => 1,
    );
    return 1;
  }
  elsif ( $Param{GetParam}->{'X-Autorespond'} ) {
    $Param{GetParam}->{'X-OTRS-FollowUp-State'} = $Ticket{State};
    $Self->{TicketObject}->HistoryAdd(
      Name         => 'X-Autorespond was set, skipping state update',
      HistoryType  => 'FollowUp',
      TicketID     => $Param{TicketID},
      CreateUserID => 1,
    );
    return 1;
  }
  elsif ( $Param{GetParam}->{'Auto-Submitted'} eq 'auto-replied' ) {
    $Param{GetParam}->{'X-OTRS-FollowUp-State'} = $Ticket{State};
    $Self->{TicketObject}->HistoryAdd(
      Name         => 'auto-submitted was set to \'auto-replied\', skipping state update',
      HistoryType  => 'FollowUp',
      TicketID     => $Param{TicketID},
      CreateUserID => 1,
    );
    return 1;
  }
  elsif ( $Param{GetParam}->{'Auto-Submitted'} eq 'auto-generated' ) {
    $Param{GetParam}->{'X-OTRS-FollowUp-State'} = $Ticket{State};
    $Self->{TicketObject}->HistoryAdd(
      Name         => 'auto-submitted was set to \'auto-generated\', skipping state update',
      HistoryType  => 'FollowUp',
      TicketID     => $Param{TicketID},
      CreateUserID => 1,
    );
    return 1;
  }
  return 1;
}

1;
