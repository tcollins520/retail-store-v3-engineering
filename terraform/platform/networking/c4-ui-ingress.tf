# ------------------------------------------------------------------------------
# UI Ingress
#
# Creates an Internet-facing AWS Application Load Balancer
# and exposes the Retail Store UI.
#
# ExternalDNS automatically creates:
#
#   shop-v3.tinacloud.dev
#
# ------------------------------------------------------------------------------

resource "kubernetes_ingress_v1" "ui" {

  metadata {

    name = "ui"

    namespace = "default"

    annotations = {

      "kubernetes.io/ingress.class" = "alb"

      "alb.ingress.kubernetes.io/scheme" = "internet-facing"

      "alb.ingress.kubernetes.io/target-type" = "ip"

      "alb.ingress.kubernetes.io/listen-ports" = "[{\"HTTP\":80},{\"HTTPS\":443}]"

      "alb.ingress.kubernetes.io/certificate-arn" = "arn:aws:acm:us-east-1:801242830567:certificate/f1c53ba0-38c2-43b3-9513-2bd356199caf"
      "alb.ingress.kubernetes.io/ssl-redirect"    = "443"

      "alb.ingress.kubernetes.io/healthcheck-path" = "/"

      "alb.ingress.kubernetes.io/success-codes" = "200"

      "external-dns.alpha.kubernetes.io/hostname" = "shop-v3.tinacloud.dev"

    }

  }

  spec {

    ingress_class_name = "alb"

    rule {

      host = "shop-v3.tinacloud.dev"

      http {

        path {

          path = "/"

          path_type = "Prefix"

          backend {

            service {

              name = "ui"

              port {

                number = 80

              }

            }

          }

        }

      }

    }

  }

  depends_on = [

    helm_release.external_dns

  ]

}

# ------------------------------------------------------------------------------
# Outputs
# ------------------------------------------------------------------------------

output "ui_hostname" {

  value = "shop-v3.tinacloud.dev"

}