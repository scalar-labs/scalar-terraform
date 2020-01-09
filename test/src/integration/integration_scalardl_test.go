package test

import (
	"fmt"
	"io/ioutil"
	"testing"

	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/stretchr/testify/assert"
	"modules/grpc_helper"
)

func TestScalarDL(t *testing.T) {
	t.Run("scalardl", func(t *testing.T) {
		t.Run("ScalarDLWithJavaClient", TestScalarDLWithJavaClientExpectStatusCodeIsValid)
		t.Run("ScalarDLWithGrpcWebClient", TestScalarDLWithGrpcWebClientExpectStatusCodeIsValid)
	})
}

func TestScalarDLWithJavaClientExpectStatusCodeIsValid(t *testing.T) {
	expectedRegisterCertStatusCode := []int{200, 405}
	expectedRegisterContractStatusCode := []int{200, 406}
	expectedExecuteContractStatusCode := 200
	expectedValidateLedgerStatusCode := 200
	expectedListContractsStatusCode := 200

	contractID := "test-contract1"
	contractBinaryName := "com.org1.contract.StateUpdater"
	contractClassFile := "./resources/StateUpdater.class"
	assetID := "over9000"
	assetArgument := fmt.Sprintf(`{"asset_id": "%s", "state": 9001}`, assetID)
	propertiesFile := "./resources/test.properties"

	scalarurl := lookupTargetValue(t, "scalardl", "envoy_dns")
	logger.Logf(t, "URL: %s", scalarurl)
	writePropertiesFile(t, scalarurl)

	code, _ := grpc_helper.GrpcJavaRegisterCert(t, propertiesFile)
	assert.Contains(t, expectedRegisterCertStatusCode, code)

	code, _ = grpc_helper.GrpcJavaRegisterContract(t, propertiesFile, contractID, contractBinaryName, contractClassFile)
	assert.Contains(t, expectedRegisterContractStatusCode, code)

	code, _ = grpc_helper.GrpcJavaExectueContract(t, propertiesFile, contractID, assetArgument)
	assert.Equal(t, expectedExecuteContractStatusCode, code)

	code, _ = grpc_helper.GrpcJavaValidateAsset(t, propertiesFile, assetID)
	assert.Equal(t, expectedValidateLedgerStatusCode, code)

	code, _ = grpc_helper.GrpcJavaListContracts(t, propertiesFile)
	assert.Equal(t, expectedListContractsStatusCode, code)
}

func TestScalarDLWithGrpcWebClientExpectStatusCodeIsValid(t *testing.T) {
	expectedStatusCode := 200

	scalarurl := lookupTargetValue(t, "scalardl", "envoy_dns")
	logger.Logf(t, "URL: %s", scalarurl)

	//Register Certificate
	requestData := "AAAAAFIKBW1kYm94EAEiRzBFAiEAx4josbxWPEuZ7w/imnl5B/xY0FKbQLkuK/E/UFUHbmwCIGBludc3JD3pkTYqmeT186g+rDaoFkLqHg4xCQ8uCL3w"
	listContractURL := fmt.Sprintf(`http://%s:50051/rpc.Ledger/ListContracts`, scalarurl)

	statuCode, _ := grpc_helper.GrpcWebTest(t, listContractURL, requestData)

	assert.Equal(t, expectedStatusCode, statuCode)
}

func writePropertiesFile(t *testing.T, host string) {
	properties := []byte(fmt.Sprintf(`
	scalar.ledger.client.server_host=%s
	scalar.ledger.client.server_port=50051
	scalar.ledger.client.server_privileged_port=50051
	scalar.ledger.client.cert_holder_id=test
	scalar.ledger.client.cert_version=1
	scalar.ledger.client.cert_path=./resources/Test.pem
	scalar.ledger.client.private_key_path=./resources/Test-key.pem
	`, host))

	err := ioutil.WriteFile("./resources/test.properties", properties, 0644)
	if err != nil {
		t.Fatal(err)
	}
}
