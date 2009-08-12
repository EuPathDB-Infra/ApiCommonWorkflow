package ApiCommonData::Load::WorkflowSteps::CopyDataDirFile;

@ISA = (ApiCommonData::Load::WorkflowSteps::WorkflowStep);
use strict;
use ApiCommonData::Load::WorkflowSteps::WorkflowStep;

sub run {
  my ($self, $test,$undo) = @_;

  # get parameters
  my $fromFile = $self->getParamValue('fromFile');
  my $toFile = $self->getParamValue('toFile');

  my $localDataDir = $self->getLocalDataDir();

  if ($undo) {
      $self->runCmd(0, "rm -f $localDataDir/$toFile");
  } else {  
      if ($test) {
	  $self->testInputFile('fromFile', "$localDataDir/$fromFile");
      }
      $self->runCmd(0, "cp $localDataDir/$fromFile $localDataDir/$toFile");
  }
}

sub getParamsDeclaration {
  return (
          'fromFile',
          'toFile',
         );
}

sub getConfigDeclaration {
  return (
         # [name, default, description]
         # ['', '', ''],
         );
}


