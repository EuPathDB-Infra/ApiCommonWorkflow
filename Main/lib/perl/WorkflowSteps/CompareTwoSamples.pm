package ApiCommonWorkflow::Main::WorkflowSteps::CompareTwoSamples;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;

sub run {
    my ($self, $test, $undo) = @_;


    my $inputFilesDir = $self->getParamValue('inputFilesDir');
    my $outputDir = $self->getParamValue('outputDir');
    my $sampleNameList = $self->getParamValue('sampleNameList');

    my $workflowDataDir = $self->getWorkflowDataDir();

    my @sampleNames = map { "$_" } split(',', $sampleNameList);
    my $sampleNameNum = $#sampleNames;


    for(my $i =0; $i <= ($sampleNameNum-1); $i++){
	for(my $j =$i+1 ; $j <= $sampleNameNum; $j++){
	    my $command = "compare_two_samples.pl  $workflowDataDir/$inputFilesDir/$sampleNames[i].mappingStats $workflowDataDir/$inputFilesDir/$sampleNames[j].mappingStats $workflowDataDir/$inputFilesDir/$sampleNames[i].count $workflowDataDir/$inputFilesDir/$sampleNames[j].count 0  $workflowDataDir/$outputDir/$sampleNames[i]"."_vs_"."$sampleNames[j]  /home/ganesh/testFischerTest/ min";
	    if ($undo) {
		$self->runCmd(0, "rm -fr $workflowDataDir/$outputDir/*_vs_*");
	    }else{
		if ($test) {
		    $self->runCmd(0,"echo hello > $workflowDataDir/$outputDir/$sampleNames[i]"."_vs_"."$sampleNames[j]");
		}else{		
		    $self->runCmd($test,$command);
		}
	    }
	}
    }

}

sub getParamsDeclaration {
    return ('inputFilesDir',
            'outputDir',
            'sampleNameList',
           );
}


sub getConfigDeclaration {
    return (
            # [name, default, description]

           );
}
