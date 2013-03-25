package ApiCommonWorkflow::Main::WorkflowSteps::MakeHtsCoverageSNPs;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;

sub run {
  my ($self, $test, $undo) = @_;

  my $organismAbbrev = $self->getParamValue('organismAbbrev');
  my $coverageSnpsFile = $self->getParamValue('coverageSnpsFile');
  my $varscanConsDir = $self->getParamValue('varscanConsDir');

  my $organismInfo = $self->getOrganismInfo($test, $organismAbbrev);
  my $referenceOrganism = $organismInfo->getFullName();
#  my $workflowDataDir = $self->getWorkflowDataDir();

  my $cmd = "generateHtsCoverageSnpsWithQuality.pl --referenceOrganism '$referenceOrganism' --varscanDir $varscanConsDir --outputFile $coverageSnpsFile";
  
  if ($undo) {
    $self->runCmd(0, "rm -f $coverageSnpsFile");
  } else {
    if ($test) {
      $self->runCmd(0,"echo test > $coverageSnpsFile");
    }else{
      $self->runCmd($test,$cmd);
    }
  }
}

sub getParamDeclaration {
  return ('organismAbbrev',
          'coverageSnpsFile',
          'varscanConsDir',
         );
}

sub getConfigDeclaration {
  return (
      # [name, default, description]
     );
}

1;
