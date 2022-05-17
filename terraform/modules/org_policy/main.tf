# ----------------------------------------------------------------------------------------------------------------------
# Organization policy
# ----------------------------------------------------------------------------------------------------------------------
resource "google_project_organization_policy" "enable-ip-forward" {
    project = var.project_id
    constraint = "compute.vmCanIpForward"

    list_policy {
        allow {
            all = true
        }
    }
}

# resource "google_project_organization_policy" "enable-external-ip" {
#     project = var.project_id
#     constraint = "compute.vmExternalIpAccess"

#     list_policy {
#         allow {
#             all = true
#         }
#     }
# }

resource "time_sleep" "wait_30_seconds" {
    depends_on = [
        google_project_organization_policy.enable-ip-forward
        ]

    create_duration = "30s"
}