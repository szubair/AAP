resource "aws_api_gateway_rest_api" "example" {
  name        = "ServerlessExample"
  description = "Terraform Serverless Application Example"
}

resource "aws_api_gateway_resource" "test" {
  rest_api_id = "${aws_api_gateway_rest_api.example.id}"
  parent_id   = "${aws_api_gateway_rest_api.example.root_resource_id}"
  path_part   = "test"
}

resource "aws_api_gateway_method" "test" {
  rest_api_id   = "${aws_api_gateway_rest_api.example.id}"
  resource_id   = "${aws_api_gateway_resource.test.id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_test" {
  rest_api_id = "${aws_api_gateway_rest_api.example.id}"
  resource_id = "${aws_api_gateway_method.test.resource_id}"
  http_method = "${aws_api_gateway_method.test.http_method}"

  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.example.invoke_arn}"
  integration_http_method = "POST"
}

resource "aws_api_gateway_deployment" "example" {
  depends_on = [
    "aws_api_gateway_method.test",
    "aws_api_gateway_integration.lambda_test"
  ]

  rest_api_id = "${aws_api_gateway_rest_api.example.id}"
  stage_name  = "test"
}
