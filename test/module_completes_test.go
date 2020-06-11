package test

import (
	"fmt"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/lambda"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"os"
	"testing"
)

const region string = "eu-west-1"

func TestModuleCreatesLambda(t *testing.T) {
	terraformOptions := &terraform.Options{
		TerraformDir: "fixtures/default",

		Vars: map[string]interface{}{
			"region": region,
		},

		NoColor: true,
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	fmt.Println("invoking lambda...")

	sess := session.Must(session.NewSessionWithOptions(session.Options{
		SharedConfigState: session.SharedConfigEnable,
	}))

	client := lambda.New(sess, &aws.Config{Region: aws.String(region)})

	result, err := client.Invoke(&lambda.InvokeInput{FunctionName: aws.String("hello-world")})
	if err != nil {
		fmt.Println("Error calling hello-world function")
		os.Exit(0)
	}

	assert.Nil(t, err)
	assert.Equal(t, 200, result.StatusCode)

}
