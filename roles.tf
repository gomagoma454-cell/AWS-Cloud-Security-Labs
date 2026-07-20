# Create a secure, hardened custom Azure RBAC role
resource "azurerm_role_definition" "hardened_developer_role" {
  name        = "Engineering-Dev-Role-Azure"
  scope       = "/subscriptions/00000000-0000-0000-0000-000000000000"
  description = "Hardened custom role for application developers with explicit least-privilege boundaries"

  permissions {
    # SECURE: Explicitly defined actions instead of a wide-open wildcard
    actions     = [
      "Microsoft.Compute/virtualMachines/read",
      "Microsoft.Compute/virtualMachines/restart/action",
      "Microsoft.Network/virtualNetworks/subnets/join/action",
      "Microsoft.Resources/subscriptions/resourceGroups/read"
    ]
    not_actions = []
  }

  assignable_scopes = [
    "/subscriptions/00000000-0000-0000-0000-000000000000"
  ]
}
