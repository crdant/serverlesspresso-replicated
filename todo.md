# ✅ Serverlesspresso Helm Chart Conversion — TODO Checklist

This checklist tracks the conversion of the Serverlesspresso CloudFormation stack into a Crossplane-managed Helm chart using the Upbound AWS provider family. **No XRD or Composition** — all resources are directly managed.

---

## 📁 Phase 1: Helm Scaffolding

- [✅] Create `Chart.yaml` with metadata
- [✅] Create `values.yaml` with parameters:
  - [✅] appName
  - [✅] service
  - [✅] logRetentionInDays
  - [✅] timeInterval
  - [✅] codeLength
  - [✅] tokensPerBucket
  - [✅] source
- [✅] Create `_helpers.tpl` for naming helpers
- [✅] Create base `templates/` directory
- [✅] Set up default `providerConfigRef` as a Helm value:
  - [✅] Ensure provider config is properly named and labeled in `cloud-providers` chart
  - [✅] Add providerConfigRef value in `serverlesspresso` chart with empty default

---

## ⚙️ Phase 2: Core AWS Infrastructure

### EventBridge
- [ ] Define EventBridge `aws.eventbridge.EventBus`
- [ ] Create SSM Parameter for EventBus name
- [ ] Create SSM Parameter for EventBus ARN

### IoT
- [ ] Create `aws.iot.Thing` for serverlesspresso realtime
- [ ] (Optional) Define strategy for managing custom IoT endpoint Lambda
- [ ] Create SSM Parameter for IoT Endpoint (if extracted externally)

### DynamoDB Tables
- [ ] Define `CountingTable`
- [ ] Define `ConfigTable` (+ stream)
- [ ] Define `ValidatorTable` (+ stream)
- [ ] Define `OrderTable` (+ GSIs, LSIs, stream)
- [ ] Define `ReviewWorkflowTable`

### SSM Parameters
- [ ] Add missing app-related parameters for:
  - [ ] userPool
  - [ ] userPoolClient
  - [ ] IoT URL

---

## 🔐 Cognito & IAM

### Cognito
- [ ] Create `aws.cognito.UserPool`
- [ ] Create `aws.cognito.UserPoolClient`
- [ ] Create `aws.cognito.IdentityPool`
- [ ] Define authorized/unauthorized IAM roles for IdentityPool
- [ ] Attach roles to IdentityPool

### IAM Roles
- [ ] Define Lambda execution roles
- [ ] Define API Gateway integration roles
- [ ] Define Step Functions roles
- [ ] Define Cognito federated roles
- [ ] Attach IAM policies (inline or separate resources)

---

## 🧠 Phase 3: Lambda Functions

- [ ] PublisherFunctionAdmin
- [ ] PublisherFunctionUser
- [ ] PublisherFunctionConfig
- [ ] GetIoTEndpointFunction (or externalized logic)
- [ ] ConfigChangedFunction
- [ ] GetQRcodeFunction
- [ ] VerifyQRcodeFunction
- [ ] ValidatorNewOrderFunction
- [ ] WaitingCompletion
- [ ] WorkFlowStarted
- [ ] GetOrderByIdFunction
- [ ] NewReviewFunction
- [ ] ReviewHandlerLambda
- [ ] FillDatabasesCustomResource
- [ ] ReviewHumanApprovalHelperFunction

---

## 🌐 Phase 4: API Gateway

- [ ] Define ConfigService API Gateway
- [ ] Define ValidatorService API Gateway
- [ ] Define OrderManager API Gateway
- [ ] Define Review API Gateway
- [ ] Attach Lambda integrations
- [ ] Apply CORS and Cognito Auth config

---

## 🔁 Step Functions

- [ ] Define OrderManagerStateMachine
- [ ] Define ReviewWorkflowStateMachine
- [ ] Reference Lambda ARNs and tables
- [ ] Reference IAM roles
- [ ] Include `definitionS3Location` or inline JSON

---

## 🧪 Testing & Validation

- [ ] Helm Lint
- [ ] Crossplane `kubectl apply` dry-runs
- [ ] Validate IAM permissions
- [ ] Validate resource outputs
- [ ] Deploy into sandbox AWS account
- [ ] Smoke test EventBridge, IoT, APIs

---

## 🎯 Final Touches

- [ ] Add output values to `NOTES.txt` or chart outputs
- [ ] Add Helm install instructions to README
- [ ] CI/CD automation (optional)
