package ApiCommonWorkflow::Main::WorkflowSteps::FindOrthomclPairs;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;
use OrthoMCLEngine::Main::Base;


sub run {
  my ($self, $test, $undo) = @_;

  # note: orthomclPairs supports restart.  to enable that we'd need to change it to look for its
  # restart tag in its config file.   and maybe it would put out an error message suggesting that option.

  my $suffix = $self->getParamValue('suffix');
  my $confFile = $self->getParamValue('configFile');

  my $workflowDataDir = $self->getWorkflowDataDir();

  my $configFile = "$workflowDataDir/$confFile";

  my $suf = $suffix? "suffix=$suffix" : "";

  my $cmd = "orthomclPairs $configFile orthomclPairs.log cleanup=no $suf startAfter=useLog";

  if ($undo) {
    $self->runCmd($test, "mv orthomclPairs.log  orthoMclPairs.log.sv.$PID");  
    $self->runCmd($test, "orthomclPairs $configFile orthomclPairsUndo.log cleanup=all $suf");
  } else {
      $self->runCmd($test,$cmd);
  }
}
