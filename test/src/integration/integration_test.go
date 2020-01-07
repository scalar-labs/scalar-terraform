package test

import (
	"testing"
	"time"
	"flag"

	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
)

var terraformDir = flag.String("directory", "", "Directory path of the terraform module to test")

func TestEndToEnd(t *testing.T) {
	t.Parallel()
	logger.Logf(t, "Start End To End Test")

	// terraformOptions := &terraform.Options{
	// 	TerraformDir: *terraformDir,
	// 	Vars:         map[string]interface{}{},
	// 	NoColor:      true,
	// }

	// defer test_structure.RunTestStage(t, "teardown", func() {
	// 	terraform.DestroyE(t, terraformOptions)
	// 	logger.Logf(t, "Finished End To End Test")
	// })

	test_structure.RunTestStage(t, "setup", func() {
		aaaa := []string{"network", "cassandra"}

		for _, b := range aaaa{
			terraformOptions := &terraform.Options{
				TerraformDir: *terraformDir + b,
				Vars:         map[string]interface{}{},
				NoColor:      true,
			}
			terraform.InitAndApply(t, terraformOptions)
		}

		logger.Logf(t, "Finished Creating Infrastructure: Tests will continue in 2 minutes")
		time.Sleep(120 * time.Second)
	})

	// test_structure.RunTestStage(t, "validate", func() {
	// 	t.Run("TestScalarDL", TestScalarDL)
	// 	t.Run("TestPrometheusAlerts", TestPrometheusAlerts)
	// })
}
