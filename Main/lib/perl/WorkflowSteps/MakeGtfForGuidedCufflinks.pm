package ApiCommonWorkflow::Main::WorkflowSteps::MakeGtfForGuidedCufflinks;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use warnings;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;


sub getSequenceOntologyTermString { $_[0]->{_sequence_ontology_term_string} }

sub run {
    my ($self, $test, $undo) = @_;

    # get parameter values
    my $workflowDataDir = $self->getWorkflowDataDir();
    my $gtfDir = $self->getParamValue("gtfDir");
    my $outputFile = $self->getParamValue("outputFile");
    my $project = $self->getParamValue("project");
    my $genomeExtDbRlsSpec = $self->getParamValue("genomeExtDbRlsSpec");
    my $cdsOnly = $self->getBooleanParamValue("cdsOnly");

    my $cmd = "makeGtf.pl --outputFile $workflowDataDir/$gtfDir/$outputFile --project $project --genomeExtDbRlsSpec '$genomeExtDbRlsSpec'";
    if(my $soTermString = $self->getSequenceOntologyTermString()) {
      $cmd .= " --sequence_ontology_term $soTermString";
    }

    if($cdsOnly) {
      $cmd .= " --cds_only";
    }

    if ($undo) {
        $self->runCmd(0, "rm -f $workflowDataDir/$gtfDir/$outputFile");
    }else{
        if($test) {
            $self->runCmd(0, "echo test > $workflowDataDir/$gtfDir/$outputFile");
        }
        $self->runCmd($test, $cmd);
    }
}

1; 
