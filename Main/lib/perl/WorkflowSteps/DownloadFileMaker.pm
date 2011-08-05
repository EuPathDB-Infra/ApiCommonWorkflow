package ApiCommonWorkflow::Main::WorkflowSteps::DownloadFileMaker;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);
use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;

# An abstract super class for making download files

##############################################################################################
#abstract methods available to subclasses.  the subclass must override each of these methods by
#providing a version of them which returns the correct thing for that subclass


# optional. return a list of config names to add to the config declaration.  these are in addition
# to the standard ones provided by this superclass
# only needed if the subclass has extra config
sub getExtraConfig {
    my ($self) = @_;
    return ();
}

# required. return a command that will create the download file, given the full download file name
# return "NONE" if there is no command to run.  this is the case for writing only a descrip file.
sub getDownloadFileCmd {
    my ($self, $downloadFileName, $test) = @_;
}

##############################################################

sub run {
  my ($self, $test, $undo) = @_;

  # standard parameters for making download files
  my $organismAbbrev = $self->getParamValue('organismAbbrev');
  my $projectName = $self->getParamValue('projectName');
  my $projectVersion = $self->getParamValue('projectVersion');
  my $relativeDir = $self->getParamValue('relativeDir');
  my $fileType = $self->getParamValue('fileType');
  my $dataName = $self->getParamValue('dataName');
  my $descripString= $self->getParamValue('descripString');

  my $websiteFilesDir = $self->getWebsiteFilesDir($test);
  my $organismNameForFiles = $self->getOrganismInfo($test, $organismAbbrev)->getNameForFiles();
  my $outputDir = "$websiteFilesDir/$relativeDir/$organismNameForFiles/$fileType";

  $dataName = "_$dataName" if $dataName; # gff does not use $dataName, so allow it to be empty

  my $downloadFile = "$outputDir/$projectName-${projectVersion}_${organismNameForFiles}$dataName.$fileType";
  my $descripFile = "$outputDir/.$projectName-${projectVersion}_${organismNameForFiles}$dataName.$fileType.desc";

  my $downloadFileCmd =  $self->getDownloadFileCmd($downloadFile, $test);

  my $descripFileCmd =  "writeDownloadFileDecripWithDescripString --descripString '$descripString' --outputFile $descripFile";

  if($undo){
    $self->runCmd(0, "rm -f $downloadFile") unless $downloadFileCmd eq 'NONE';
    $self->runCmd(0, "rm -f $descripFile");
  }else {
      if ($test) {
	  $self->runCmd(0, "echo test > $downloadFile") unless $downloadFileCmd eq 'NONE';
	  $self->runCmd(0, "echo test > $descripFile");
      }else {
	  $self->runCmd($test, $downloadFileCmd) unless $downloadFileCmd eq 'NONE';
	  $self->runCmd($test, $descripFileCmd);
      }
  }
}


sub getConfigDeclaration {
    my ($self) = @_;

    my @baseConfig = (
	);
    my @extraConfig = $self->getExtraConfig();
    return (@baseConfig, @extraConfig);

}
