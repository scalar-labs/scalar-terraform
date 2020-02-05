package prometheus_helper

import (
  "encoding/json"
  "fmt"
  "io/ioutil"
  "net/http"
  "net/url"
  "testing"

  "github.com/gruntwork-io/terratest/modules/logger"
)

type metric struct {
  Name       string `json:"__name__"`
  Job        string `json:"job"`
  Role       string `json:"role"`
  Instance   string `json:"instance"`
  Alertname  string `json:"alertname"`
  Alertstate string `json:"alertstate"`
}

type result struct {
  Metric metric        `json:"metric"`
  Value  []interface{} `json:"value"`
}

type data struct {
  ResultType string   `json:"resultType"`
  Result     []result `json:"result"`
}

type prometheus struct {
  Status string `json:"status"`
  Data   data   `json:"data"`
}

func QueryRule(t *testing.T, host string, rulename string) (int, int, prometheus) {
  statusCode, count, response, err := QueryRuleE(t, host, rulename)
  if err != nil {
    t.Fatal(err)
  }

  return statusCode, count, response
}

func QueryRuleE(t *testing.T, host string, rulename string) (int, int, prometheus, error) {
  prometheusUrl, err := url.Parse(host)
  if err != nil {
    return -1, -1, prometheus{}, err
  }

  prometheusUrl, err = prometheusUrl.Parse("/api/v1/query")
  if err != nil {
    return -1, -1, prometheus{}, err
  }

  query := prometheusUrl.Query()
  query.Add("query", rulename)
  prometheusUrl.RawQuery = query.Encode()

  statusCode, response, err := CallApiE(t, prometheusUrl.String())
  if err != nil {
    return -1, -1, prometheus{}, err
  }

  count := len(response.Data.Result)

  return statusCode, count, response, nil
}

func QueryAlert(t *testing.T, host string, alertname string) (int, int, prometheus) {
  statusCode, count, response, err := QueryAlertE(t, host, alertname)
  if err != nil {
    t.Fatal(err)
  }

  return statusCode, count, response
}

func QueryAlertE(t *testing.T, host string, alertname string) (int, int, prometheus, error) {
  prometheusUrl, err := url.Parse(host)
  if err != nil {
    return -1, -1, prometheus{}, err
  }

  prometheusUrl, err = prometheusUrl.Parse("/api/v1/query")
  if err != nil {
    return -1, -1, prometheus{}, err
  }

  query := prometheusUrl.Query()
  query.Add("query", fmt.Sprintf(`ALERTS{alertname="%s"}`, alertname))
  prometheusUrl.RawQuery = query.Encode()

  statusCode, response, err := CallApiE(t, prometheusUrl.String())
  if err != nil {
    return -1, -1, prometheus{}, err
  }

  count := len(response.Data.Result)

  return statusCode, count, response, nil
}

func CallApiE(t *testing.T, urlString string) (int, prometheus, error) {
  prometheusUrl, err := url.Parse(urlString)
  if err != nil {
    return -1, prometheus{}, err
  }

  logger.Logf(t, "Making Prometheus API call to URL %s", prometheusUrl.String())

  client := &http.Client{}

  req, err := http.NewRequest("GET", prometheusUrl.String(), nil)
  if err != nil {
    return -1, prometheus{}, err
  }

  resp, err := client.Do(req)
  if err != nil {
    return -1, prometheus{}, err
  }

  defer resp.Body.Close()
  body, err := ioutil.ReadAll(resp.Body)
  if err != nil {
    return -1, prometheus{}, err
  }

  response := prometheus{}

  if err := json.Unmarshal(body, &response); err != nil {
    return -1, prometheus{}, err
  }
  logger.Logf(t, "Prometheus: %+v", response)

  return resp.StatusCode, response, nil
}
