package test

import (
	"encoding/json"
	"fmt"
	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"testing"
)

const region string = "eu-west-1"

func TestModuleCreatesLambda(t *testing.T) {
	functionName := fmt.Sprintf("terratest-aws-lambda-example-%s", random.UniqueId())

	terraformOptions := &terraform.Options{
		TerraformDir: "fixtures/default",

		Vars: map[string]interface{}{
			"region":        region,
			"function_name": functionName,
		},

		NoColor: true,
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	fmt.Println("invoking lambda...")

	response := aws.InvokeFunction(t, region, functionName, nil)

	var actual map[string]interface{}

	if err := json.Unmarshal(response, &actual); err != nil {
		panic(err)
	}

	assert.Equal(t, "Hello world!", actual["body"])

}
