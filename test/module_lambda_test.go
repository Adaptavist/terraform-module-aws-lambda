package test

import (
	"encoding/json"
	"fmt"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/iam"
	testaws "github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestModuleCreatesLambda(t *testing.T) {
	const region string = "eu-west-1"

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

	response := testaws.InvokeFunction(t, region, functionName, nil)

	var actual map[string]interface{}

	if err := json.Unmarshal(response, &actual); err != nil {
		panic(err)
	}

	assert.Equal(t, "Hello world!", actual["body"])

}

func TestModuleAttachesXRayPolicy(t *testing.T) {

	const region string = "eu-west-1"
	functionName := fmt.Sprintf("terratest-aws-lambda-example-%s", random.UniqueId())

	terraformOptions := &terraform.Options{
		TerraformDir: "fixtures/xray",

		Vars: map[string]interface{}{
			"region":        region,
			"function_name": functionName,
		},

		NoColor: true,
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	lambdaRoleName := functionName + "-" + region

	sess, err := session.NewSession(&aws.Config{
		Region: aws.String(region)},
	)

	svc := iam.New(sess)

	foundPolicy := false
	policyName := "AWSXrayWriteOnlyAccess"

	err = svc.ListAttachedRolePoliciesPages(
		&iam.ListAttachedRolePoliciesInput{
			RoleName: &lambdaRoleName,
		},
		func(page *iam.ListAttachedRolePoliciesOutput, lastPage bool) bool {
			if page != nil && len(page.AttachedPolicies) > 0 {
				for _, policy := range page.AttachedPolicies {
					if *policy.PolicyName == policyName {
						foundPolicy = true
						return false
					}
				}
				return true
			}
			return false
		},
	)

	if err != nil {
		fmt.Println("Error", err)
		return
	}

	assert.True(t, true, foundPolicy)

}
