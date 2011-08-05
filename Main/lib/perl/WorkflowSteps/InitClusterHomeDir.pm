package ApiCommonWorkflow::Main::WorkflowSteps::InitClusterHomeDir;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);
use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;

sub run {
  my ($self, $test, $undo) = @_;

  my $clusterDataDir = $self->getClusterWorkflowDataDir();
  my $clusterTaskLogsDir = $self->getComputeClusterTaskLogsDir();



   if ($undo) {
      $self->runCmdOnCluster(0, "rm -fr $clusterDataDir");
      $self->runCmdOnCluster(0, "rm -fr $clusterTaskLogsDir");
   } else {
      $self->runCmdOnCluster(0, "mkdir -p $clusterDataDir");
      $self->runCmdOnCluster(0, "mkdir -p $clusterTaskLogsDir");
   }

}

sub getParamsDeclaration {
  return (
	 );
}

sub getConfigDeclaration {
  return (
	 );
}

