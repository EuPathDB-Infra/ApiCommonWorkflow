package ApiCommonWorkflow::Main::WorkflowSteps::NextflowResultsCache;
@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;
use File::Basename;


sub run {
    my ($self, $test, $undo) = @_;

    my $mode = $self->getParamValue('mode');

    my $preprocessedDataCache = $self->getSharedConfig('preprocessedDataCache');

    my $foundNextflowResults = $self->getParamValue("foundNextflowResults");
    my $resultsDir = $self->getParamValue("resultsDir");

    my ($genomeName, $genomeVersion) = split(/\|/, $self->getParamValue("genomeSpec"));

    my $projectName = $self->getParamValue("projectName");
    my $nextflowWorkflow = $self->getParamValue("nextflowWorkflow");

    my $databaseVersion;
    if ($nextflowWorkflow eq "VEuPathDB/iprscan5-nextflow") {
	$databaseVersion = $self->getSharedConfig('interproscanDatabaseDirectory');
    }
    if ($nextflowWorkflow eq "VEuPathDB/repeat-masker-nextflow") {
	$databaseVersion = $self->getSharedConfig('repeatMaskerDatabaseDirectory');
    }

    my $nextflowBranch = $self->getSharedConfig("${nextflowWorkflow}.branch");
    $nextflowWorkflow =~ s/\//_/g;
 
    my $nextflowDirectory;
    if ($databaseVersion) {
	$nextflowDirectory = "${nextflowWorkflow}_${nextflowBranch}/${databaseVersion}";
    } 
    else {
	$nextflowDirectory = "${nextflowWorkflow}_${nextflowBranch}";
    }

    my $cacheDirBase = "$preprocessedDataCache/$projectName/${genomeName}_${genomeVersion}";

    my $datasetSpec = $self->getParamValue("datasetSpec");

    my $datasetDirectory = "genome";
    if($datasetSpec) {
	$datasetSpec =~ s/\|/_/g;
	$datasetDirectory = $datasetSpec;
    }

    my $cacheDir = "$cacheDirBase/$datasetDirectory/$nextflowDirectory";

    my $annotationSpec = $self->getParamValue("annotationSpec");
    if($annotationSpec) {
	$annotationSpec =~ s/\|/_/g;

	$datasetDirectory = $datasetSpec ? $datasetSpec : "genesAndProteins";

	$cacheDir = "$cacheDirBase/$annotationSpec/$datasetDirectory/$nextflowDirectory";
    }

    my $resultsPath = $self->getWorkflowDataDir() . "/" . $resultsDir;
    my $foundNextflowResultsFile = $self->getWorkflowDataDir() . "/" . $foundNextflowResults;

    if($mode eq "copyTo") {
	$self->copyTo($test, $undo, $cacheDir, $resultsPath);
    }
    else {
	$self->checkAndCopyFrom($test, $undo, $cacheDir, $resultsPath, $foundNextflowResultsFile);
    }
}


sub checkAndCopyFrom {

  my ($self, $test, $undo, $cacheDir, $resultsPath, $foundNextflowResultsFile) = @_;

  my $hasCacheFile = $self->hasCacheFile($cacheDir);
  if($undo) {
    $self->runCmd($test, "rm -f $foundNextflowResultsFile");
    $self->runCmd($test, "rm -rf $resultsPath/*");
  }
  else {
    if($hasCacheFile) {

      $self->runCmd($test, "touch $foundNextflowResultsFile");
      $self->runCmd($test, "cp -r $cacheDir/* $resultsPath");
    }
}


sub hasCacheFile {
    my ($self, $cacheDir) = @_;

    if(-d $cacheDir) {
	opendir(my $dh, $cacheDir) or die "Can't open $cacheDir for reading: $!";
	while (readdir($dh)) {
	    next if ($_ eq '.' or $_ eq '..');

	    closedir($dh);
	    return 1;
	}
	closedir($dh);
    }

    return 0;
}



sub copyTo {
  my ($self, $test, $undo, $cacheDir, $resultsPath) = @_;


  if($undo) {} #nothing to see here
  else {
	if ($test) {
	      $self->runCmd(0, "mkdir -p $cacheDir");
        $self->runCmd(0, "cp -r $resultsPath/* $cacheDir/");
    }
    $self->runCmd($test, "mkdir -p $cacheDir");
    $self->runCmd($test, "cp -r $resultsPath/* $cacheDir/");
  }


}

1;
