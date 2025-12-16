############################################################
# GuardDuty – Organization Configuration
############################################################
resource "aws_guardduty_detector" "org" {
  enable = true
}

resource "aws_guardduty_organization_configuration" "org" {
  detector_id = aws_guardduty_detector.org.id
  auto_enable_organization_members = "ALL"
}
