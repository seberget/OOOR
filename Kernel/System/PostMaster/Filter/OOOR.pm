# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::PostMaster::Filter::OOOR;

use strict;
use warnings;

use Kernel::System::ObjectManager;

our @ObjectDependencies = (
  'Kernel::System::Log',
);


sub new {
  my ( $Type, %Param ) = @_;

  # allocate new hash for object
  my $Self = {};
  bless( $Self, $Type );

  $Self->{Debug} = $Param{Debug} || 0;

  $Self->{ParserObject} = $Param{ParserObject} || die "Got no ParserObject";

  # Get communication log object.
  $Self->{CommunicationLogObject} = $Param{CommunicationLogObject} || die "Got no CommunicationLogObject!";

  return $Self;
}

sub Run {
  my ( $Self, %Param ) = @_;

  # check needed stuff
  for (qw(GetParam)) {
    if ( !$Param{$_} ) {
      $Kernel::OM->Get('Kernel::System::Log')->Log(Priority => 'error', Message  => "Need $_!");
      return;
    }
  }

  if ($Param{TicketID}) {
    $Kernel::OM->Get('Kernel::System::Log')->Log(Priority => 'error', Message  => "We have lift-off!");
    my %Ticket = $Self->{TicketObject}->TicketGet(
      TicketID => $Param{TicketID},
      UserID   => 1
    );
  }
  else {
    $Kernel::OM->Get('Kernel::System::Log')->Log(Priority => 'error', Message  => "New ticket, skipping");
    return 1;
  }

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
      Name         => 'Auto-Submitted was set to \'auto-replied\', skipping state update',
      HistoryType  => 'FollowUp',
      TicketID     => $Param{TicketID},
      CreateUserID => 1,
    );
    return 1;
  }
  elsif ( $Param{GetParam}->{'Auto-Submitted'} eq 'auto-generated' ) {
    $Param{GetParam}->{'X-OTRS-FollowUp-State'} = $Ticket{State};
    $Self->{TicketObject}->HistoryAdd(
      Name         => 'Auto-Submitted was set to \'auto-generated\', skipping state update',
      HistoryType  => 'FollowUp',
      TicketID     => $Param{TicketID},
      CreateUserID => 1,
    );
    return 1;
  }
  return 1;
}

1;
