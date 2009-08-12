package ApiCommonData::Load::WorkflowSteps::InsertSplign;

@ISA = (ApiCommonData::Load::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonData::Load::WorkflowSteps::WorkflowStep;


sub run {
  my ($self, $test, $undo) = @_;

  my $queryExtDbRlsSpec = $self->getParamValue('queryExtDbRlsSpec');

  my $subjectExtDbRlsSpec = $self->getParamValue('subjectExtDbRlsSpec');

  my $inputFile = $self->getParamValue('inputFile');

  my $queryTable = $self->getParamValue('queryTable');

  my $subjectTable = $self->getParamValue('subjectTable');

  my $args = "--inputFile $inputFile --estTable '$queryTable' --seqTable '$subjectTable' --estExtDbRlsSpec '$queryExtDbRlsSpec' --seqExtDbRlsSpec '$subjectExtDbRlsSpec'";

  my $localDataDir = $self->getLocalDataDir();
  if ($test) {
    $self->testInputFile('inputFile', "$localDataDir/$inputFile");
  }

  $self -> runPlugin ($test, $undo, "ApiCommonData::Load::Plugin::InsertSplignAlignments", $args);
}



sub restart {
}

sub undo {

}

sub getConfigDeclaration {
  my @properties = 
    (
    );
  return @properties;
}

sub getParamDeclaration {
  my @properties = 
    (
     ['queryExtDbRlsSpecc'],
     ['subjectExtDbRlsSpec'],
     ['inputFile'],
     ['queryTable'],
     ['subjectTable'],
    );
  return @properties;
}

sub getDocumentation {
}
