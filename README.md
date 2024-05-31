# Examples

## JSON defintion file

```json
{
  "project_name": "my-project",
  "environment": "development",
  "region": "us-east-1",
  "jira_ticket": "NFI-xxxx",
  "bucket_name": "remote-state-bucket",
  "dynamodb_table": "remote-tf-state-locks-table-name"
}
```

## Usage

`./provison_tf_template.sh json-defs/file-created-from-backend-factory.json`

