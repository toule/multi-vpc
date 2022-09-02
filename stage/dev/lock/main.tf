resource "aws_dynamodb_table" "tfstate_lock" {
  name           = "rayhli-tfstate-lock"
  hash_key       = "LockID"
  billing_mode   = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
}

output "mutax" {
	value = aws_dynamodb_table.tfstate_lock
}
