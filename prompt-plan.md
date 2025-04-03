# 🚀 Crossplane Helm Conversion Prompts for Serverlesspresso (No XRD/Composition)

This document contains a step-by-step series of LLM-friendly prompts for converting the Serverlesspresso CloudFormation template into a Helm chart using Crossplane and the Upbound AWS provider family. This approach avoids using XRD or Composition — resources are created directly.

---

## ✅ Prompt 1: Scaffolding the Helm Chart

```
Create a Helm chart named `serverlesspresso` in the `charts` directory. The chart should have the 
following structure:

- A `Chart.yaml` with metadata.
- A `values.yaml` containing values for:
  - appName
  - service
  - logRetentionInDays
  - timeInterval
  - codeLength
  - tokensPerBucket
  - source

In the `templates/` directory, create a `_helpers.tpl` for naming helpers.
Output should be clean YAML and support templating via `.Values`. Don’t include any Crossplane resources yet.
```

---

## ✅ Prompt 2: Define the EventBridge Bus (Crossplane)

```
Write a Crossplane `aws.eventbridge.EventBus` resource using Upbound's provider-family-aws and any providers in that family that are necessary.

The name should be templated via `.Values.appName`. The resource should be defined as a Helm template.

Use a standard `providerConfigRef` and make sure metadata, spec, and status are included. Follow Helm best practices (don’t hardcode names or ARNs).
```

---

## ✅ Prompt 3: Define SSM Parameters

```
Define three `aws.ssm.Parameter` Crossplane resources to store:
1. EventBus name
2. EventBus ARN
3. IoT Endpoint URL

These should be templated via `.Values`, and each parameter should have descriptive metadata.

Make sure to include Helm templating and Crossplane fields like `value`, `name`, and `type`.
```

---

## ✅ Prompt 4: Define IoT Thing + Custom Resource Logic

```
Define an `aws.iot.Thing` resource using Crossplane.

The name should be `serverlesspresso-realtime-workshop`.

Also, describe how a `CustomResource` equivalent of the `GetIoTEndpointFunction` would be managed in Crossplane, ideally via Composition or external provisioning step. If unsupported, recommend moving logic outside of Crossplane.
```

---

## ✅ Prompt 5: Define DynamoDB Tables

```
Create Helm templates for the following `aws.dynamodb.Table` resources:

1. CountingTable
2. ConfigTable
3. ValidatorTable
4. OrderTable
5. ReviewWorkflowTable

Each table should use `PAY_PER_REQUEST`, define hash and sort keys as needed, and stream config if specified.

Include Helm-friendly naming and tags.
```

---

## ✅ Prompt 6: Define Cognito Resources

```
Create the following Crossplane resources:

- `aws.cognito.UserPool`
- `aws.cognito.UserPoolClient`
- `aws.cognito.IdentityPool`
- IAM roles for authenticated and unauthenticated identities

Map the user pool attributes (email), disable MFA, and configure pool settings per template. Output as Helm templates.
```

---

## ✅ Prompt 7: Define Lambda Functions

```
Generate Crossplane `aws.lambda.Function` resources for:

- PublisherFunctionAdmin
- PublisherFunctionUser
- PublisherFunctionConfig
- GetIoTEndpointFunction
- ConfigChangedFunction
- GetQRcodeFunction
- VerifyQRcodeFunction

Use `.Values` for parameters like CodeUri, environment vars, and function names. Assume inline code is moved to S3 or git-backed infra.
```

---

## ✅ Prompt 8: Define API Gateway (REST APIs)

```
Write Helm templates for API Gateway REST APIs:

- ConfigService API
- ValidatorService API
- OrderManager API
- Review API

Use `aws.apigatewayv2.Api` or SAM-compatible replacements if abstracted. Define CORS settings, stages, and integrations. Assume Swagger/OpenAPI files are hosted in S3.
```

---

## ✅ Prompt 9: State Machine Definitions

```
Create Crossplane-managed `aws.sfn.StateMachine` resources for:

- OrderManagerStateMachine
- ReviewWorkflowStateMachine

Assume definition JSON is passed via `definition` or `definitionS3Location`. Use environment variables and role ARNs as needed.
```

---

## ✅ Prompt 10: Wiring IAM Roles

```
Define IAM roles and policies for:

- Lambda execution (GetIoT, Publishers, Review, etc.)
- API Gateway integration roles
- Cognito identity roles (auth + unauth)
- Step Functions roles

Use `aws.iam.Role` and `aws.iam.PolicyAttachment`. Include trust policies, inline permissions, and Crossplane best practices.
```

---
