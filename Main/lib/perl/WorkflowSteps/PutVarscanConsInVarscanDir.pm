package ApiCommonWorkflow::Main::WorkflowSteps::PutVarscanConsInVarscanDir;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;

sub run {
  my ($self, $test, $undo) = @_;

  my $workflowDataDir = $self->getWorkflowDataDir();
  my $varscanConsDir = $self->getParamValue('varscanConsDir');
  my $strain = $self->getParamValue('strain');
  my $mainResultDir = $self->getParamValue('mainResultDir');


  my $cmd = "ln -s $workflowDataDir/$mainResultDir/result.varscan.cons.gz $workflowDataDir/$varscanConsDir/$strain.varscan.cons.gz";
  my $undoCmd = "/bin/rm $workflowDataDir/$varscanConsDir/$strain.varscan.cons.gz";

  if ($undo) {
    $self->runCmd(0, $undoCmd);
  } else {
    if ($test) {
      $self->runCmd(0,"echo $cmd > $workflowDataDir/$varscanConsDir/$strain.varscan.cons.gz");
    }else{
      $self->runCmd($test,$cmd);
    }
  }
}

sub getParamDeclaration {
  return ('varscanConsDir',
          'strain',
          'mainResultDir'
         );
}

sub getConfigDeclaration {
  return (
      # [name, default, description]
     );
}

1;