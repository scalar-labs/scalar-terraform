package test

import (
	"testing"

	"modules/prometheus_helper"

	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/ssh"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestPrometheusAlerts(t *testing.T) {
	t.Run("alerts", func(t *testing.T) {
		t.Run("AlertmanagerContainerDown", TestAlertmanagerContainerDownWithPrometheusAPIExpectAlertIsNotFiring)

		t.Run("ScalarDLBlueCount", TestScalarDLBlueCountWithPrometheusAPIExpectCountIsValid)
		t.Run("ScalarDLGreenCount", TestScalarDLGreenCountWithPrometheusAPIExpectCountIsValid)
		t.Run("ScalarDegraded", TestScalarDegradedWithPrometheusAPIExpectAlertAndRecovery)

		t.Run("ReaperContainerDown", TestReaperContainerDownWithPrometheusAPIExpectAlertIsNotFiring)

		t.Run("CassandraCount", TestCassandraCountWithPrometheusAPIExpectCountIsValid)
		t.Run("CassandraDegraded", TestCassandraDegradedWithPrometheusAPIExpectAlertAndRecovery)
		t.Run("CassandraDriveSpaceLow", TestCassandraDriveSpaceLowWithPrometheusAPIExpectAlertIsFiring)

		t.Run("InstanceHighCPU", TestInstanceHighCPUWithPrometheusAPIExpectAlertIsFiring)
	})
}

func TestAlertmanagerContainerDownWithPrometheusAPIExpectAlertIsNotFiring(t *testing.T) {
	host := lookupMonitorHost(t)
	alertname := "AlertmanagerContainerDown"

	verifyAlertNotFiring(t, host, alertname)
}

func TestReaperContainerDownWithPrometheusAPIExpectAlertIsNotFiring(t *testing.T) {
	host := lookupMonitorHost(t)
	alertname := "ReaperContainerDown"

	verifyAlertNotFiring(t, host, alertname)
}

func TestCassandraCountWithPrometheusAPIExpectCountIsValid(t *testing.T) {
	host := lookupMonitorHost(t)
	servicename := `count(node_systemd_unit_state{role="cassandra", name="cassandra.service", state="active"} == 1)`
	expectedCount := "3"

	verifyServiceCount(t, host, servicename, expectedCount)
}

func TestScalarDLBlueCountWithPrometheusAPIExpectCountIsValid(t *testing.T) {
	host := lookupMonitorHost(t)
	servicename := "job:active_scalardl_blue_nodes:count"
	expectedCount := "3"

	verifyServiceCount(t, host, servicename, expectedCount)
}

func TestScalarDLGreenCountWithPrometheusAPIExpectCountIsValid(t *testing.T) {
	host := lookupMonitorHost(t)
	servicename := "job:active_scalardl_green_nodes:count"
	expectedCount := "0"

	verifyServiceCount(t, host, servicename, expectedCount)
}

func TestScalarDegradedWithPrometheusAPIExpectAlertAndRecovery(t *testing.T) {
	host := lookupMonitorHost(t)
	alertname := "ScalarDLContainerDown"

	terraformOptions := &terraform.Options{
		TerraformDir: *terraformDir,
		Vars:         map[string]interface{}{},
		NoColor:      true,
	}

	bastionIP := terraform.OutputRequired(t, terraformOptions, "bastion_ip")
	scalardlIP := terraform.OutputRequired(t, terraformOptions, "scalardl_blue_test_ip_0")

	publicHost := ssh.Host{
		Hostname:    bastionIP,
		SshAgent:    true,
		SshUserName: "centos",
	}
	privateHost := ssh.Host{
		Hostname:    scalardlIP,
		SshAgent:    true,
		SshUserName: "centos",
	}

	commandStop := "docker stop $(docker ps -aq); sleep 120"
	commandStart := "docker start $(docker ps -aq); sleep 60"

	output, _ := ssh.CheckPrivateSshConnectionE(t, publicHost, privateHost, commandStop)
	logger.Logf(t, "Stopping Container: %s", output)

	verifyAlertFiring(t, host, alertname)

	output, _ = ssh.CheckPrivateSshConnectionE(t, publicHost, privateHost, commandStart)
	logger.Logf(t, "Starting Container: %s", output)

	verifyAlertNotFiring(t, host, alertname)
}

func TestCassandraDegradedWithPrometheusAPIExpectAlertAndRecovery(t *testing.T) {
	t.Parallel()

	host := lookupMonitorHost(t)
	alertname := "CassandraProcessStopped"

	terraformOptions := &terraform.Options{
		TerraformDir: *terraformDir,
		Vars:         map[string]interface{}{},
		NoColor:      true,
	}

	bastionIP := terraform.OutputRequired(t, terraformOptions, "bastion_ip")
	cassandraIP := terraform.OutputRequired(t, terraformOptions, "cassandra_test_ip_0")

	publicHost := ssh.Host{
		Hostname:    bastionIP,
		SshAgent:    true,
		SshUserName: "centos",
	}
	privateHost := ssh.Host{
		Hostname:    cassandraIP,
		SshAgent:    true,
		SshUserName: "centos",
	}

	commandStop := "sudo systemctl stop cassandra; sleep 120"
	commandStart := "sudo systemctl start cassandra; sleep 120"

	output, _ := ssh.CheckPrivateSshConnectionE(t, publicHost, privateHost, commandStop)
	logger.Logf(t, "Stopping Cassandra: %s", output)

	verifyAlertFiring(t, host, alertname)

	output, _ = ssh.CheckPrivateSshConnectionE(t, publicHost, privateHost, commandStart)
	logger.Logf(t, "Starting Cassandra: %s", output)

	verifyAlertNotFiring(t, host, alertname)

}

func TestInstanceHighCPUWithPrometheusAPIExpectAlertIsFiring(t *testing.T) {
	t.Parallel()

	host := lookupMonitorHost(t)
	alertname := "InstanceHighCPUUtilization"

	terraformOptions := &terraform.Options{
		TerraformDir: *terraformDir,
		Vars:         map[string]interface{}{},
		NoColor:      true,
	}

	bastionIP := terraform.OutputRequired(t, terraformOptions, "bastion_ip")
	cassandraIP := terraform.OutputRequired(t, terraformOptions, "cassandra_test_ip_1")

	publicHost := ssh.Host{
		Hostname:    bastionIP,
		SshAgent:    true,
		SshUserName: "centos",
	}
	privateHost := ssh.Host{
		Hostname:    cassandraIP,
		SshAgent:    true,
		SshUserName: "centos",
	}

	command := "sudo yum -y install stress && stress --cpu 8 --timeout 2m"

	output, _ := ssh.CheckPrivateSshConnectionE(t, publicHost, privateHost, command)
	logger.Logf(t, "%s", output)

	verifyAlertFiring(t, host, alertname)
}

func TestCassandraDriveSpaceLowWithPrometheusAPIExpectAlertIsFiring(t *testing.T) {
	t.Parallel()

	host := lookupMonitorHost(t)
	alertname := "CassandraDriveSpaceLow"

	terraformOptions := &terraform.Options{
		TerraformDir: *terraformDir,
		Vars:         map[string]interface{}{},
		NoColor:      true,
	}

	bastionIP := terraform.OutputRequired(t, terraformOptions, "bastion_ip")
	cassandraIP := terraform.OutputRequired(t, terraformOptions, "cassandra_test_ip_1")

	publicHost := ssh.Host{
		Hostname:    bastionIP,
		SshAgent:    true,
		SshUserName: "centos",
	}
	privateHost := ssh.Host{
		Hostname:    cassandraIP,
		SshAgent:    true,
		SshUserName: "centos",
	}

	commandWrite := "fallocate -l 60G largefile; sleep 60"
	commandClear := "rm largefile; sleep 60"

	output, _ := ssh.CheckPrivateSshConnectionE(t, publicHost, privateHost, commandWrite)
	logger.Logf(t, "%s", output)

	verifyAlertFiring(t, host, alertname)

	output, _ = ssh.CheckPrivateSshConnectionE(t, publicHost, privateHost, commandClear)
	logger.Logf(t, "%s", output)

	verifyAlertNotFiring(t, host, alertname)
}

func verifyAlertFiring(t *testing.T, host string, alertname string) {
	_, count, _ := prometheus_helper.QueryAlert(t, host, alertname)
	assert.True(t, (count >= 1))
}

func verifyAlertNotFiring(t *testing.T, host string, alertname string) {
	_, count, _ := prometheus_helper.QueryAlert(t, host, alertname)
	assert.Equal(t, 0, count)
}

func verifyServiceCount(t *testing.T, host string, servicename string, expected string) {
	_, count, response := prometheus_helper.QueryRule(t, host, servicename)
	if count > 0 {
		assert.Equal(t, expected, response.Data.Result[0].Value[1])
	} else {
		assert.Equal(t, expected, "0")
	}
}

func lookupMonitorHost(t *testing.T) string {
	terraformOptions := &terraform.Options{
		TerraformDir: *terraformDir,
		Vars:         map[string]interface{}{},
		NoColor:      true,
	}

	return terraform.OutputRequired(t, terraformOptions, "monitor_url")
}
