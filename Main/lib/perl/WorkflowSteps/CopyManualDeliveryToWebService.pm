 package ApiCommonWorkflow::Main::WorkflowSteps::CopyManualDeliveryToWebService;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);
use strict;
use warnings;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;
use ApiCommonWorkflow::Main::Util::OrganismInfo;

sub run {
    my ($self, $test, $undo) = @_;

    #get parameters
    my $copyFromDir = $self->getParamValue('inputsDir');
    my $organismAbbrev = $self->getParamValue('organismAbbrev');
    my $relativeDir = $self->getParamValue('relativeDir');
    my $experimentResourceName = $self->getParamValue('experimentDatasetName');
    my $fileType = $self->getParamValue('fileType');
    my $websiteFilesDir = $self->getWebsiteFilesDir($test);
    my $gusConfigFile = $self->getParamValue('gusConfigFile');
    $gusConfigFile = $self->getWorkflowDataDir() . "/$gusConfigFile";

    my $organismNameForFiles = $self->getOrganismInfo($test, $organismAbbrev, $gusConfigFile)->getNameForFiles();
    my $workflowDataDir = $self->getWorkflowDataDir();


    my $copyToDir = "$websiteFilesDir/$relativeDir/$organismNameForFiles/$fileType/$experimentResourceName";
    my $cmd_mkdir = "mkdir -p $copyToDir";

    my $cmd_copy = "cp $workflowDataDir/$copyFromDir/* $copyToDir";
    
    $self->testInputFile('copyFromDir', "$workflowDataDir/$copyFromDir");

    if ($undo) {
        $self->runCmd(0,"rm -rf $copyToDir");
    }else{
        $self->runCmd($test, $cmd_mkdir);
        $self->runCmd($test, $cmd_copy);
    }
}

1;
