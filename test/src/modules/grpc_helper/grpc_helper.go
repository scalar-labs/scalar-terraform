package grpc_helper

import (
	"bytes"
	"encoding/base64"
	"fmt"
	"io/ioutil"
	"net/http"
	"os/exec"
	"strconv"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/logger"
)

func GrpcJavaListContracts(t *testing.T, propertiesFile string) (int, string) {
	action := "list-contracts"

	options := []string{
		"-properties", propertiesFile,
	}

	return GrpcJavaTest(t, action, options...)
}

func GrpcJavaValidateAsset(t *testing.T, propertiesFile string, assetId string) (int, string) {
	action := "validate-ledger"

	options := []string{
		"-properties", propertiesFile,
		"-asset-id", assetId,
	}

	return GrpcJavaTest(t, action, options...)
}

func GrpcJavaExectueContract(t *testing.T, propertiesFile string, contractId string, contractArgument string) (int, string) {
	action := "execute-contract"

	options := []string{
		"-properties", propertiesFile,
		"-contract-id", contractId,
		"-contract-argument", contractArgument,
	}

	return GrpcJavaTest(t, action, options...)
}

func GrpcJavaRegisterContract(t *testing.T, propertiesFile string, contractId string, contractBinaryName string, contractClassFile string) (int, string) {
	action := "register-contract"

	options := []string{
		"-properties", propertiesFile,
		"-contract-id", contractId,
		"-contract-binary-name", contractBinaryName,
		"-contract-class-file", contractClassFile,
	}

	return GrpcJavaTest(t, action, options...)
}

func GrpcJavaRegisterCert(t *testing.T, propertiesFile string) (int, string) {
	action := "register-cert"

	options := []string{
		"-properties", propertiesFile,
	}

	return GrpcJavaTest(t, action, options...)
}

func GrpcJavaTest(t *testing.T, action string, options ...string) (int, string) {
	logger.Logf(t, "Starting Java %s %v", action, options)
	command := fmt.Sprintf(`scalardl-client-sdk/client/bin/%s`, action)
	cmd := exec.Command(command, options...)

	byteOutput, err := cmd.CombinedOutput()
	if err != nil {
		t.Fatal(err)
	}

	output := string(byteOutput)
	statusCode := parseStatusCodeFromOutput(output)

	logger.Logf(t, "%d", statusCode)
	logger.Logf(t, "%s", output)

	return statusCode, output
}

func GrpcWebTest(t *testing.T, url string, data string) (int, string) {
	statusCode, body, err := GrpcWebTestE(t, url, data)
	if err != nil {
		t.Fatal(err)
	}

	return statusCode, body
}

func GrpcWebTestE(t *testing.T, url string, data string) (int, string, error) {
	logger.Logf(t, "Making GRPC_WEB call to URL %s", url)

	client := &http.Client{}
	req, err := http.NewRequest("POST", url, bytes.NewBufferString(data))

	req.Header.Add("Content-Type", "application/grpc-web-text")
	req.Header.Add("X-User-Agent", "grpc-web-javascript/0.1")
	req.Header.Add("Connection", "keep-alive")
	req.Header.Add("Accept", "application/grpc-web-text")
	req.Header.Add("X-Grpc-Web", "1")

	resp, err := client.Do(req)
	if err != nil {
		return -1, "", err
	}

	defer resp.Body.Close()
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return -1, "", err
	}
	
	logger.Logf(t, "%s", string(body))
	message, _ := base64.StdEncoding.DecodeString(string(body))

	logger.Logf(t, "Reponse Status: %s", resp.Status)
	logger.Logf(t, "Reponse Body: %s", string(body))
	logger.Logf(t, "Reponse Message: %s", string(message))

	return resp.StatusCode, string(message), nil
}

// This function assumes the output contains the `status: <code>` on the first line.
func parseStatusCodeFromOutput(output string) int {
	split := strings.Split(output, "\n")

	//Verify at least 1 line in output
	if len(split) < 1 {
		return -1
	}

	splitCode := strings.Split(split[0], " ")

	//Verify the first line contains at least 2 elements
	if len(splitCode) < 2 {
		return -1
	}

	statusCode, err := strconv.Atoi(splitCode[1])
	if err != nil {
		return -1
	}

	return statusCode
}
