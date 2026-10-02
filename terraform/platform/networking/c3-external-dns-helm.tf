# ------------------------------------------------------------------------------
# Add the ExternalDNS Helm Repository
# ------------------------------------------------------------------------------

resource "helm_release" "external_dns" {

  name = "external-dns"

  namespace = "kube-system"

  repository = "https://kubernetes-sigs.github.io/external-dns"

  chart = "external-dns"

  create_namespace = false

  timeout = 600

  # ---------------------------------------------------------------------------
  # Configure ExternalDNS
  # ---------------------------------------------------------------------------

  values = [

    yamlencode({

      provider = {

        name = "aws"

      }

      sources = [

        "service",
        "ingress"

      ]

      policy = "upsert-only"

      registry = "txt"

      txtOwnerId = data.terraform_remote_state.eks.outputs.eks_cluster_name

      domainFilters = [

        "tinacloud.dev"

      ]

      serviceAccount = {

        create = false

        name = "external-dns"

      }

      extraArgs = [

        "--aws-zone-type=public"

      ]

      logLevel = "info"

    })

  ]

  depends_on = [

    aws_eks_pod_identity_association.externaldns

  ]

}

# ------------------------------------------------------------------------------
# Outputs
# ------------------------------------------------------------------------------

output "external_dns_helm_release" {

  description = "ExternalDNS Helm Release"

  value = helm_release.external_dns.name

}