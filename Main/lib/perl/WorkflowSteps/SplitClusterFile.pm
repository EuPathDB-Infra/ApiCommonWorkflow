package ApiCommonWorkflow::Main::WorkflowSteps::SplitClusterFile;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;

sub run {
  my ($self, $test, $undo) = @_;

  my $inputFile = $self->getParamValue('inputFile');
  my $outputSmallFile = $self->getParamValue('outputSmallFile');
  my $outputBigFile = $self->getParamValue('outputBigFile');

  my $localDataDir = $self->getLocalDataDir();

  my $cmd = "splitClusterFile $localDataDir/$inputFile $localDataDir/$outputSmallFile $localDataDir/$outputBigFile";

  if ($undo) {
    $self->runCmd(0, "rm -f $localDataDir/$outputSmallFile");
    $self->runCmd(0, "rm -f $localDataDir/$outputBigFile");
  } else {
      if ($test){
	  $self->testInputFile('inputFile', "$localDataDir/$inputFile");
	  $self->runCmd(0,"echo hello > $localDataDir/$outputSmallFile");
	  $self->runCmd(0,"echo hello > $localDataDir/$outputBigFile");
      }else{
	  $self->runCmd($test,$cmd);
      }
  }
}


sub getConfigDeclaration {
  my @properties = 
    (
     # [name, default, description]
    );
  return @properties;
}

sub getParamDeclaration {
  my @properties = 
    (
     ['inputFile',
      'outputBigFile',
      'outputSmallFile',
     ]
    );
  return @properties;
}


