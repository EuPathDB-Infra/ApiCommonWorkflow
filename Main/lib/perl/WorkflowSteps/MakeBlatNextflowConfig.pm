package ApiCommonWorkflow::Main::WorkflowSteps::MakeBlatNextflowConfig;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use warnings;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;

sub run {
    my ($self, $test, $undo) = @_;

    my $clusterWorkflowDataDir = $self->getClusterWorkflowDataDir();
    my $workflowDataDir = $self->getWorkflowDataDir();
    my $outputDir = join("/", $clusterWorkflowDataDir, $self->getParamValue("outputDir")); 
    my $configFileName = $self->getParamValue("configFileName");
    my $configPath = join("/", $workflowDataDir,  $self->getParamValue("analysisDir"), $self->getParamValue("configFileName"));
    my $seqFile = join("/", $clusterWorkflowDataDir, $self->getParamValue("queryFile"));
    my $fastaSubsetSize = $self->getParamValue("fastaSubsetSize");
    my $databasePath = join("/", $clusterWorkflowDataDir, $self->getParamValue("databasePath"));
    my $maxIntronSize = $self->getParamValue("maxIntronSize");
    my $dbType = $self->getParamValue("dbType");
    my $queryType = $self->getParamValue("queryType");
    my $blatParams = $self->getParamValue("blatParams");
    my $trans = $self->getParamValue("trans");
    my $increasedMemory = $self->getParamValue("increasedMemory");
    my $initialMemory = $self->getParamValue("initialMemory");
    my $maxForks = $self->getParamValue("maxForks");
    my $maxRetries = $self->getParamValue("maxRetries");

    my $executor = $self->getClusterExecutor();
    my $queue = $self->getClusterQueue();
  
    if ($undo) {
	$self->runCmd(0,"rm -rf $configPath");
    } else {
	open(F, ">", $configPath) or die "$! :Can't open config file '$configPath' for writing";

    die "TODO:  what is trans variable for when true?  do we need to change type??" if(lc($trans) ne 'false');

    print F
"
params {
  queryFasta = \"$seqFile\"
  fastaSubsetSize = $fastaSubsetSize
  genomeFasta = \"$databasePath\"
  maxIntron = $maxIntronSize
  dbType = \"$dbType\"
  queryType = \"$queryType\"
  blatParams = \"$blatParams\"
  outputDir = \"$outputDir\"
}
                                                                                                                                                                      
process{
  container = 'veupathdb/blat:latest'
  executor = \'$executor\'
  queue = \'$queue\'
  maxForks = $maxForks
  maxRetries = $maxRetries
  withName: 'runBlat' {
    errorStrategy = { task.exitStatus in 130..140 ? \'retry\' : \'finish\' }
    clusterOptions = {
      (task.attempt > 1 && task.exitStatus in 130..140)
        ? \'-M $increasedMemory -R \"rusage [mem=$increasedMemory] span[hosts=1]\"\'
        : \'-M $initialMemory -R \"rusage [mem=$initialMemory] span[hosts=1]\"\'
    }
  }                                                                                                                                                                             \
}

singularity {
  enabled = true
  autoMounts = true
}
";
	close(F);
    }
}

1;
