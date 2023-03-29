package ApiCommonWorkflow::Main::WorkflowSteps::MakeDnaSeqSingleExperimentNextflowConfig;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use warnings;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;

sub run {
  my ($self, $test, $undo) = @_;

  my $clusterWorkflowDataDir = $self->getClusterWorkflowDataDir();
  my $input = join("/", $clusterWorkflowDataDir, $self->getParamValue("input"));
  my $geneSourceIdOrthologFile = join("/", $clusterWorkflowDataDir, $self->getParamValue("geneSourceIdOrthologFile"));
  my $chrsForCalcFile = join("/", $clusterWorkflowDataDir, $self->getParamValue("chrsForCalcFile"));
  my $taxonId = $self->getParamValue("taxonId");
  my $fromBAM = $self->getParamValue("fromBAM");
  my $isLocal= $self->getParamValue("isLocal");
  my $isPaired = $self->getParamValue("isPaired");
  my $analysisDir = $self->getParamValue("analysisDir");
  my $genomeFastaFile = join("/", $clusterWorkflowDataDir, $self->getParamValue("genomeFastaFile"));
  my $gtfFile = join("/", $clusterWorkflowDataDir, $self->getParamValue("gtfFile"));
  my $clusterResultDir = join("/", $clusterWorkflowDataDir, $self->getParamValue("clusterResultDir"));
  my $configFileName = $self->getParamValue("configFileName");
  my $ploidy = $self->getParamValue("ploidy");
  my $organismAbbrev = $self->getParamValue("organismAbbrev");
  my $footprintFile = join("/", $clusterWorkflowDataDir, $self->getParamValue("footprintFile"));
  my $configPath = join("/", $self->getWorkflowDataDir(),  $self->getParamValue("analysisDir"), $self->getParamValue("configFileName"));
  my $hisat2Threads = $self->getConfig("hisat2Threads");
  my $samtoolsThreads = $self->getConfig("samtoolsThreads");
  my $minCoverage = $self->getConfig("minCoverage");
  my $winLen = $self->getConfig("winLen");
  my $varscanPValue = $self->getConfig("varscanPValue");
  my $varscanMinVarFreqSnp = $self->getConfig("varscanMinVarFreqSnp");
  my $varscanMinVarFreqCons = $self->getConfig("varscanMinVarFreqCons");
  my $maxNumberOfReads = $self->getConfig("maxNumberOfReads");
  my $hisat2Index = $self->getConfig("hisat2Index");
  my $createIndex = $self->getConfig("createIndex");
  my $trimmomaticAdaptorsFile = $self->getConfig("trimmomaticAdaptorsFile");  
  my $ebiFtpUser = $self->getConfig("ebiFtpUser");  
  my $ebiFtpPassword = $self->getConfig("ebiFtpPassword");  
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

    print F
"
params {
  input = \"$input\"
  fromBAM = $fromBAM
  hisat2Threads = $hisat2Threads
  isPaired = $isPaired
  local = $isLocal
  organismAbbrev = \"$organismAbbrev\"
  minCoverage = $minCoverage
  genomeFastaFile = \"$genomeFastaFile\"
  gtfFile = \"$gtfFile\"
  footprintFile = \"$footprintFile\"
  winLen = $winLen 
  ploidy= $ploidy
  hisat2Index = $hisat2Index
  createIndex = $createIndex
  outputDir = \"$clusterResultDir\"
  trimmomaticAdaptorsFile = $trimmomaticAdaptorsFile
  varscanPValue = $varscanPValue
  varscanMinVarFreqSnp = $varscanMinVarFreqSnp
  varscanMinVarFreqCons = $varscanMinVarFreqCons
  maxNumberOfReads = $maxNumberOfReads
  taxonId = \"$taxonId\"
  geneSourceIdOrthologFile = \"$geneSourceIdOrthologFile\"
  chrsForCalcFile = \"$chrsForCalcFile\"
}

process {
  executor = \'$executor\'
  queue = \'$queue\'
  maxForks = $maxForks
  maxRetries = $maxRetries
  withName: \'blastSimilarity\' {
    errorStrategy = { task.exitStatus in 130..140 ? \'retry\' : \'finish\' } 
    clusterOptions = { 
      (task.attempt > 1 && task.exitStatus in 130..140)
        ? \'-M $increasedMemory -R \"rusage [mem=$increasedMemory] span[hosts=1]\"\'
        : \'-M $initialMemory -R \"rusage [mem=$initialMemory] span[hosts=1]\"\'                                                                                                                      
    }                                                                                                                                                                                                    
  }
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

