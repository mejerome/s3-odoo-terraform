resource "aws_backup_vault" "ssx-backups" {
  name = "ssx-backups"
  tags = {
    Name = var.tag_name
  }
}

resource "aws_backup_plan" "ssx-backup-plan" {
  name = "ssx-backup-plan"
  rule {
    rule_name         = "Backup-SSX-DB"
    target_vault_name = aws_backup_vault.ssx-backups.name
    schedule          = "cron(0 12 * * ? *)"
    lifecycle {
      delete_after = 7
    }
  }
}

resource "aws_backup_selection" "ssx-backup-selection" {
  iam_role_arn = aws_iam_role.aws-backup-service-role.arn
  plan_id      = aws_backup_plan.ssx-backup-plan.id
  name         = "ssx-backup-resources"
  selection_tag {
    type  = "STRINGEQUALS"
    key   = "backup"
    value = "True"
  }
}